import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ws_connection_state.dart';

class VendorChatWebSocketService {
  VendorChatWebSocketService({required Future<String?> Function() getWsTicket})
    : _getWsTicket = getWsTicket;

  // ============================================================
  // CONFIGURATION
  // ============================================================

  static const String _defaultWsUrl = 'wss://gatbi.ae/ws';

  static const Duration _connectTimeout = Duration(seconds: 5);

  static const Duration _authTimeout = Duration(seconds: 10);

  static const int _maxReconnectAttempts = 5;

  // ============================================================
  // WS TICKET PROVIDER
  // ============================================================

  final Future<String?> Function() _getWsTicket;

  // ============================================================
  // CHANNEL
  // ============================================================

  WebSocketChannel? _channel;

  // ============================================================
  // TIMERS
  // ============================================================

  Timer? _connectTimeoutTimer;

  Timer? _authTimeoutTimer;

  Timer? _reconnectTimer;

  // ============================================================
  // MESSAGE STREAM
  // ============================================================

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  // ============================================================
  // CONNECTION STATE STREAM
  // ============================================================

  final StreamController<VendorChatWsConnectionState>
  _connectionStateController =
      StreamController<VendorChatWsConnectionState>.broadcast();

  // ============================================================
  // STATE
  // ============================================================

  VendorChatWsConnectionState _connectionState =
      VendorChatWsConnectionState.disconnected;

  int? _conversationId;

  int _reconnectAttempts = 0;

  bool _disposed = false;

  bool _isAuthenticated = false;

  bool _isSubscribed = false;

  bool _manualDisconnect = false;

  // ============================================================
  // GETTERS
  // ============================================================

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  Stream<VendorChatWsConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  VendorChatWsConnectionState get connectionState => _connectionState;

  bool get isConnected =>
      _connectionState == VendorChatWsConnectionState.connected;

  bool get isAuthenticated => _isAuthenticated;

  bool get isSubscribed => _isSubscribed;

  int? get conversationId => _conversationId;

  // ============================================================
  // CONNECT
  // ============================================================

  Future<void> connect({required int conversationId}) async {
    if (_disposed) {
      return;
    }

    _conversationId = conversationId;
    _manualDisconnect = false;

    _cancelReconnectTimer();

    // ----------------------------------------------------------
    // Already fully connected
    // ----------------------------------------------------------

    if (_channel != null && _isAuthenticated && _isSubscribed) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Already connected.');
      }

      return;
    }

    // ----------------------------------------------------------
    // Close old socket
    // ----------------------------------------------------------

    await _closeSocket();

    _reconnectAttempts = 0;

    await _connect();
  }

  // ============================================================
  // INTERNAL CONNECT
  // ============================================================

  Future<void> _connect() async {
    if (_disposed) {
      return;
    }

    if (_conversationId == null) {
      return;
    }

    if (_channel != null) {
      return;
    }

    _setConnectionState(VendorChatWsConnectionState.connecting);

    _isAuthenticated = false;
    _isSubscribed = false;

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT WS: CONNECTING                        ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('URL: $_defaultWsUrl');
      debugPrint('CONVERSATION ID: $_conversationId');
    }

    try {
      final channel = IOWebSocketChannel.connect(Uri.parse(_defaultWsUrl));

      _channel = channel;

      _startConnectTimeout();

      channel.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Connection error: $error');
      }

      await _handleConnectionFailure();
    }
  }

  // ============================================================
  // CONNECT TIMEOUT
  // ============================================================

  void _startConnectTimeout() {
    _connectTimeoutTimer?.cancel();

    _connectTimeoutTimer = Timer(_connectTimeout, () async {
      if (_disposed) {
        return;
      }

      if (_channel == null) {
        return;
      }

      if (_isAuthenticated) {
        return;
      }

      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT WS: Open timeout after '
          '$_connectTimeout.',
        );
      }

      await _handleConnectionFailure();
    });
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _onMessage(dynamic rawData) {
    if (_disposed) {
      return;
    }

    Map<String, dynamic>? data;

    try {
      if (rawData is String) {
        final decoded = jsonDecode(rawData);

        if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        }
      } else if (rawData is List<int>) {
        final decoded = jsonDecode(utf8.decode(rawData));

        if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Invalid JSON: $error');
      }

      return;
    }

    if (data == null) {
      return;
    }

    final type = data['type']?.toString();

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS EVENT: $type');
    }

    switch (type) {
      case 'open':
        _handleOpen();
        break;

      case 'auth_success':
        _handleAuthSuccess(data);
        break;

      case 'auth_error':
        _handleAuthError(data);
        break;

      case 'subscribed':
        _handleSubscribed(data);
        break;

      case 'new_message':
        _handleNewMessage(data);
        break;

      case 'ping':
        _sendPong();
        break;

      case 'error':
        _handleServerError(data);
        break;

      default:
        if (kDebugMode) {
          debugPrint('VENDOR CHAT WS: Unknown event type: $type');
        }
        break;
    }
  }

  // ============================================================
  // OPEN
  // ============================================================

  void _handleOpen() {
    if (_disposed) {
      return;
    }

    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Socket OPEN.');
    }

    _sendAuth();
  }

  // ============================================================
  // AUTH
  // ============================================================

  Future<void> _sendAuth() async {
    if (_disposed) {
      return;
    }

    if (_channel == null) {
      return;
    }

    _setConnectionState(VendorChatWsConnectionState.authenticating);

    try {
      final ticket = await _getWsTicket();

      if (_disposed) {
        return;
      }

      if (ticket == null || ticket.trim().isEmpty) {
        if (kDebugMode) {
          debugPrint('VENDOR CHAT WS: WS ticket unavailable.');
        }

        await _handleConnectionFailure();

        return;
      }

      _channel?.sink.add(jsonEncode({'type': 'auth', 'token': ticket}));

      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Auth message sent.');
      }

      _authTimeoutTimer?.cancel();

      _authTimeoutTimer = Timer(_authTimeout, () async {
        if (_disposed) {
          return;
        }

        if (_isAuthenticated) {
          return;
        }

        if (kDebugMode) {
          debugPrint(
            'VENDOR CHAT WS: Auth timeout after '
            '$_authTimeout.',
          );
        }

        await _handleConnectionFailure();
      });
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Ticket/auth error: $error');
      }

      await _handleConnectionFailure();
    }
  }

  // ============================================================
  // AUTH SUCCESS
  // ============================================================

  void _handleAuthSuccess(Map<String, dynamic> data) {
    if (_disposed) {
      return;
    }

    _authTimeoutTimer?.cancel();
    _authTimeoutTimer = null;

    _isAuthenticated = true;

    _reconnectAttempts = 0;

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Authentication successful.');
      debugPrint('USER ID: ${data['user_id'] ?? 'N/A'}');
      debugPrint('ROLE: ${data['role'] ?? 'N/A'}');
    }

    _subscribe();
  }

  // ============================================================
  // AUTH ERROR
  // ============================================================

  Future<void> _handleAuthError(Map<String, dynamic> data) async {
    _isAuthenticated = false;
    _isSubscribed = false;

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Authentication failed.');
      debugPrint('MESSAGE: ${data['message'] ?? 'Unknown auth error'}');
    }

    await _handleConnectionFailure();
  }

  // ============================================================
  // SUBSCRIBE
  // ============================================================

  void _subscribe() {
    if (_disposed) {
      return;
    }

    if (_channel == null) {
      return;
    }

    if (!_isAuthenticated) {
      return;
    }

    final conversationId = _conversationId;

    if (conversationId == null) {
      return;
    }

    _setConnectionState(VendorChatWsConnectionState.subscribing);

    _channel?.sink.add(
      jsonEncode({'type': 'subscribe', 'conversation_id': conversationId}),
    );

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Subscribe sent.');
      debugPrint('CONVERSATION ID: $conversationId');
    }
  }

  // ============================================================
  // SUBSCRIBED
  // ============================================================

  void _handleSubscribed(Map<String, dynamic> data) {
    if (_disposed) {
      return;
    }

    final subscribedConversationId = _parseInt(data['conversation_id']);

    if (subscribedConversationId != null &&
        subscribedConversationId != _conversationId) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT WS: Ignoring subscription '
          'for another conversation.',
        );
      }

      return;
    }

    _isSubscribed = true;

    _setConnectionState(VendorChatWsConnectionState.connected);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT WS: CONNECTED                        ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('CONVERSATION ID: $_conversationId');
      debugPrint('POLLING CAN NOW STOP.');
    }
  }

  // ============================================================
  // NEW MESSAGE
  // ============================================================

  void _handleNewMessage(Map<String, dynamic> data) {
    if (_disposed) {
      return;
    }

    final incomingConversationId = _parseInt(data['conversation_id']);

    if (incomingConversationId == null) {
      return;
    }

    if (incomingConversationId != _conversationId) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT WS: Ignoring message '
          'from another conversation.',
        );
      }

      return;
    }

    final rawMessage = data['message'];

    if (rawMessage is! Map) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: new_message has no valid message.');
      }

      return;
    }

    final message = Map<String, dynamic>.from(rawMessage);

    _messageController.add({
      'type': 'new_message',
      'conversation_id': incomingConversationId,
      'message': message,
      'timestamp': data['timestamp'],
    });

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: New message emitted.');
      debugPrint('MESSAGE ID: ${message['id'] ?? 'N/A'}');
    }
  }

  // ============================================================
  // PING
  // ============================================================

  void _sendPong() {
    if (_channel == null) {
      return;
    }

    try {
      _channel?.sink.add(jsonEncode({'type': 'pong'}));

      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: pong sent.');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Failed to send pong: $error');
      }
    }
  }

  // ============================================================
  // SERVER ERROR
  // ============================================================

  Future<void> _handleServerError(Map<String, dynamic> data) async {
    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Server error.');
      debugPrint('MESSAGE: ${data['message'] ?? 'Unknown server error'}');
    }

    await _handleConnectionFailure();
  }

  // ============================================================
  // SOCKET ERROR
  // ============================================================

  Future<void> _onError(Object error) async {
    if (_disposed) {
      return;
    }

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Socket error: $error');
    }

    await _handleConnectionFailure();
  }

  // ============================================================
  // SOCKET CLOSED
  // ============================================================

  Future<void> _onDone() async {
    if (_disposed) {
      return;
    }

    if (kDebugMode) {
      debugPrint('VENDOR CHAT WS: Socket closed.');
    }

    await _handleConnectionFailure();
  }

  // ============================================================
  // CONNECTION FAILURE
  // ============================================================

  Future<void> _handleConnectionFailure() async {
    if (_disposed) {
      return;
    }

    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;

    _authTimeoutTimer?.cancel();
    _authTimeoutTimer = null;

    _isAuthenticated = false;
    _isSubscribed = false;

    await _closeSocket();

    _setConnectionState(VendorChatWsConnectionState.disconnected);

    if (_manualDisconnect) {
      return;
    }

    _scheduleReconnect();
  }

  // ============================================================
  // RECONNECT
  // ============================================================

  void _scheduleReconnect() {
    if (_disposed) {
      return;
    }

    if (_manualDisconnect) {
      return;
    }

    if (_conversationId == null) {
      return;
    }

    if (_reconnectTimer != null) {
      return;
    }

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Maximum reconnect attempts reached.');
        debugPrint('Polling should remain active.');
      }

      return;
    }

    _reconnectAttempts++;

    final delaySeconds = switch (_reconnectAttempts) {
      1 => 2,
      2 => 4,
      3 => 8,
      _ => 15,
    };

    final delay = Duration(seconds: delaySeconds);

    if (kDebugMode) {
      debugPrint(
        'VENDOR CHAT WS: Reconnect attempt '
        '$_reconnectAttempts/$_maxReconnectAttempts '
        'in ${delay.inSeconds}s.',
      );
    }

    _reconnectTimer = Timer(delay, () async {
      _reconnectTimer = null;

      if (_disposed || _manualDisconnect || _channel != null) {
        return;
      }

      await _connect();
    });
  }

  // ============================================================
  // UNSUBSCRIBE
  // ============================================================

  void unsubscribe() {
    if (_channel == null) {
      return;
    }

    final conversationId = _conversationId;

    if (conversationId == null) {
      return;
    }

    try {
      _channel?.sink.add(
        jsonEncode({'type': 'unsubscribe', 'conversation_id': conversationId}),
      );

      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Unsubscribe sent.');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Unsubscribe error: $error');
      }
    }

    _isSubscribed = false;
  }

  // ============================================================
  // CLOSE SOCKET
  // ============================================================

  Future<void> _closeSocket() async {
    final channel = _channel;

    _channel = null;

    if (channel == null) {
      return;
    }

    try {
      await channel.sink.close();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT WS: Socket close error: $error');
      }
    }
  }
  // ============================================================
  // DISCONNECT
  // ============================================================

  Future<void> disconnect() async {
    if (_disposed) {
      return;
    }

    // ----------------------------------------------------------
    // VERY IMPORTANT:
    //
    // Manual disconnect means:
    // DO NOT reconnect automatically.
    // ----------------------------------------------------------

    _manualDisconnect = true;

    _cancelReconnectTimer();

    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;

    _authTimeoutTimer?.cancel();
    _authTimeoutTimer = null;

    _isAuthenticated = false;
    _isSubscribed = false;

    await _closeSocket();

    _setConnectionState(VendorChatWsConnectionState.disconnected);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT WS: DISCONNECTED                      ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('MANUAL DISCONNECT: TRUE');
      debugPrint('AUTO RECONNECT: DISABLED');
    }
  }

  // ============================================================
  // MANUAL RECONNECT
  // ============================================================

  Future<void> reconnect() async {
    if (_disposed) {
      return;
    }

    if (_conversationId == null) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT WS: Reconnect ignored. '
          'Conversation ID is missing.',
        );
      }

      return;
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT WS: MANUAL RECONNECT                 ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
    }

    // ----------------------------------------------------------
    // Allow connection again.
    // ----------------------------------------------------------

    _manualDisconnect = false;

    _cancelReconnectTimer();

    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;

    _authTimeoutTimer?.cancel();
    _authTimeoutTimer = null;

    _reconnectAttempts = 0;

    _isAuthenticated = false;
    _isSubscribed = false;

    await _closeSocket();

    _setConnectionState(VendorChatWsConnectionState.disconnected);

    await _connect();
  }

  // ============================================================
  // CONNECTION STATE
  // ============================================================

  void _setConnectionState(VendorChatWsConnectionState value) {
    if (_connectionState == value) {
      return;
    }

    _connectionState = value;

    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(value);
    }
  }

  // ============================================================
  // CANCEL RECONNECT
  // ============================================================

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // ============================================================
  // INT PARSER
  // ============================================================

  int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }

    _disposed = true;
    _manualDisconnect = true;

    _cancelReconnectTimer();

    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;

    _authTimeoutTimer?.cancel();
    _authTimeoutTimer = null;

    try {
      await _channel?.sink.close();
    } catch (_) {}

    _channel = null;

    await _messageController.close();
    await _connectionStateController.close();
  }
}
