import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../../Web Socket/Controller/vendor_chat_ws_ticket_controller.dart';
import '../../Web Socket/services/websocket_service.dart';
import '../../Web Socket/services/ws_connection_state.dart';
import '../Models/vendor_chat_detail_message_model.dart';
import '../Repo/vendor_chat_detail_repository.dart';

import 'vendor_chat_detail_state.dart';

// ============================================================
// Provider
// ============================================================

final vendorChatDetailControllerProvider =
    StateNotifierProvider.family<
      VendorChatDetailController,
      VendorChatDetailState,
      int
    >((ref, chatId) {
      final dioClient = ref.watch(dioProvider);

      final wsTicketController = ref.read(
        vendorChatWsTicketControllerProvider.notifier,
      );

      return VendorChatDetailController(
        dioClient: dioClient,
        chatId: chatId,
        getWsTicket: () async {
          final ticket = await wsTicketController.getWsTicket();

          return ticket?.token;
        },
      );
    });

// ============================================================
// Controller
// ============================================================

class VendorChatDetailController extends StateNotifier<VendorChatDetailState>
    with WidgetsBindingObserver {
  VendorChatDetailController({
    required DioClient dioClient,
    required int chatId,
    required Future<String?> Function() getWsTicket,
  }) : _repository = VendorChatDetailRepository(dioClient),
       _wsService = VendorChatWebSocketService(getWsTicket: getWsTicket),
       super(VendorChatDetailState(chatId: chatId)) {
    WidgetsBinding.instance.addObserver(this);

    _initializeWebSocketListeners();
  }

  // ============================================================
  // Repository
  // ============================================================

  final VendorChatDetailRepository _repository;

  // ============================================================
  // WebSocket
  // ============================================================

  final VendorChatWebSocketService _wsService;

  StreamSubscription<Map<String, dynamic>>? _wsMessageSubscription;

  StreamSubscription<VendorChatWsConnectionState>? _wsConnectionSubscription;

  // ============================================================
  // Polling
  // ============================================================

  static const Duration _pollingInterval = Duration(seconds: 5);

  Timer? _pollingTimer;

  bool _pollingInProgress = false;

  // ============================================================
  // Request Protection
  // ============================================================

  bool _requestInProgress = false;

  bool _isDisposed = false;

  // ============================================================
  // Visibility / Lifecycle
  // ============================================================

  bool _chatVisible = false;

  bool _appInForeground = true;

  // ============================================================
  // Initialization
  // ============================================================

  void _initializeWebSocketListeners() {
    // ----------------------------------------------------------
    // WS messages
    // ----------------------------------------------------------

    _wsMessageSubscription = _wsService.messageStream.listen(
      _handleWsMessage,
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint('VENDOR CHAT DETAIL WS STREAM ERROR: $error');
        }

        _startPollingIfAllowed();
      },
    );

    // ----------------------------------------------------------
    // WS connection state
    // ----------------------------------------------------------

    _wsConnectionSubscription = _wsService.connectionStateStream.listen(
      _handleWsConnectionState,
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint('VENDOR CHAT DETAIL WS STATE ERROR: $error');
        }

        _startPollingIfAllowed();
      },
    );
  }

  // ============================================================
  // Chat Visibility
  //
  // Call this from ChatDetailScreen:
  //
  // controller.setChatVisible(true);
  //
  // and on dispose:
  //
  // controller.setChatVisible(false);
  // ============================================================

  void setChatVisible(bool visible) {
    if (_isDisposed) {
      return;
    }

    _chatVisible = visible;

    if (kDebugMode) {
      debugPrint('VENDOR CHAT DETAIL VISIBILITY: $visible');
    }

    if (!visible) {
      _stopPolling();

      unawaited(_wsService.disconnect());

      return;
    }

    if (!_appInForeground) {
      return;
    }

    _startRealtimeConnection();
  }

  // ============================================================
  // APP LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (_isDisposed) {
      return;
    }

    if (kDebugMode) {
      debugPrint('VENDOR CHAT DETAIL LIFECYCLE: $lifecycleState');
    }

    switch (lifecycleState) {
      // --------------------------------------------------------
      // FOREGROUND
      // --------------------------------------------------------

      case AppLifecycleState.resumed:
        _appInForeground = true;

        if (_chatVisible) {
          _realtimeStarted = true;

          unawaited(_startWebSocket());

          if (!_wsService.isConnected) {
            _startPollingIfAllowed();
          }
        }

        break;

      // --------------------------------------------------------
      // BACKGROUND / HIDDEN
      // --------------------------------------------------------

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _appInForeground = false;

        // Stop polling immediately.
        _stopPolling();

        // Stop WS and disable auto reconnect.
        unawaited(_wsService.disconnect());

        break;
    }
  }

  // ============================================================
  // Start Realtime Connection
  // ============================================================

  void _startRealtimeConnection() {
    if (_isDisposed) {
      return;
    }

    if (!_chatVisible) {
      return;
    }

    if (!_appInForeground) {
      return;
    }

    if (state.chatId == null) {
      return;
    }

    // ----------------------------------------------------------
    // Start polling immediately.
    //
    // It will automatically stop when WS becomes subscribed.
    // ----------------------------------------------------------

    _startPollingIfAllowed();

    // ----------------------------------------------------------
    // Start WebSocket.
    // ----------------------------------------------------------

    unawaited(_connectWebSocket());
  }

  // ============================================================
  // WebSocket Connect
  // ============================================================

  Future<void> _connectWebSocket() async {
    if (_isDisposed) {
      return;
    }

    if (!_chatVisible) {
      return;
    }

    if (!_appInForeground) {
      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT DETAIL: WS INITIALIZE               ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('CHAT ID: $chatId');
      }

      await _wsService.connect(conversationId: chatId);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL WS CONNECT ERROR: $error');
      }

      _startPollingIfAllowed();
    }
  }

  // ============================================================
  // WebSocket Lifecycle Protection
  // ============================================================

  bool _wsConnectInProgress = false;

  bool _realtimeStarted = false;
  // ============================================================
  // CHAT OPEN
  // ============================================================
  //
  // Call when ChatDetailScreen becomes visible.
  //
  // controller.startChatRealtime();
  //
  // ============================================================

  Future<void> startChatRealtime() async {
    if (_isDisposed) {
      return;
    }

    if (_realtimeStarted) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: Realtime already started.');
      }

      return;
    }

    _chatVisible = true;

    if (!_appInForeground) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL: Chat visible but app is not foreground.',
        );
      }

      return;
    }

    _realtimeStarted = true;

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT DETAIL: REALTIME START               ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('CHAT ID: ${state.chatId}');
    }

    // ----------------------------------------------------------
    // Start WS.
    // ----------------------------------------------------------

    await _startWebSocket();

    // ----------------------------------------------------------
    // If WS is not connected, polling is fallback.
    // ----------------------------------------------------------

    if (!_wsService.isConnected) {
      _startPollingIfAllowed();
    }
  }

  // ============================================================
  // CHAT CLOSE
  // ============================================================
  //
  // Call when ChatDetailScreen is closed/disposed.
  //
  // controller.stopChatRealtime();
  //
  // ============================================================

  Future<void> stopChatRealtime() async {
    if (_isDisposed) {
      return;
    }

    _chatVisible = false;
    _realtimeStarted = false;

    // ----------------------------------------------------------
    // Stop polling immediately.
    // ----------------------------------------------------------

    _stopPolling();

    // ----------------------------------------------------------
    // Prevent pending WS connection from continuing.
    // ----------------------------------------------------------

    _wsConnectInProgress = false;

    // ----------------------------------------------------------
    // Completely disconnect WebSocket.
    //
    // disconnect() sets manualDisconnect=true,
    // therefore automatic reconnect is disabled.
    // ----------------------------------------------------------

    await _wsService.disconnect();

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT DETAIL: REALTIME STOP                ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('CHAT ID: ${state.chatId}');
      debugPrint('POLLING: STOPPED');
      debugPrint('WEBSOCKET: DISCONNECTED');
      debugPrint('AUTO RECONNECT: DISABLED');
    }
  }

  // ============================================================
  // START WEBSOCKET
  // ============================================================

  Future<void> _startWebSocket() async {
    if (_isDisposed) {
      return;
    }

    if (!_chatVisible) {
      return;
    }

    if (!_appInForeground) {
      return;
    }

    if (!_realtimeStarted) {
      return;
    }

    if (_wsService.isConnected) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: WebSocket already connected.');
      }

      return;
    }

    if (_wsConnectInProgress) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL: WebSocket connection already in progress.',
        );
      }

      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    _wsConnectInProgress = true;

    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT DETAIL: WS START                     ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('CHAT ID: $chatId');
      }

      await _wsService.connect(conversationId: chatId);

      if (_isDisposed) {
        return;
      }

      // --------------------------------------------------------
      // Chat may have been closed while connecting.
      // --------------------------------------------------------

      if (!_chatVisible || !_realtimeStarted) {
        await _wsService.disconnect();
        return;
      }

      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: WS connect request completed.');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: WS START ERROR: $error');
      }

      // --------------------------------------------------------
      // WS failed.
      //
      // Polling fallback.
      // --------------------------------------------------------

      _startPollingIfAllowed();
    } finally {
      _wsConnectInProgress = false;
    }
  }

  // ============================================================
  // WebSocket Connection State
  // ============================================================

  void _handleWsConnectionState(VendorChatWsConnectionState connectionState) {
    if (_isDisposed) {
      return;
    }

    if (kDebugMode) {
      debugPrint('VENDOR CHAT DETAIL WS STATE: $connectionState');
    }

    switch (connectionState) {
      case VendorChatWsConnectionState.connected:
        // ------------------------------------------------------
        // auth_success + subscribed completed.
        //
        // Polling is no longer required.
        // ------------------------------------------------------

        _stopPolling();

        if (kDebugMode) {
          debugPrint('VENDOR CHAT DETAIL: WS CONNECTED -> POLLING STOPPED');
        }

        break;

      case VendorChatWsConnectionState.disconnected:
        // ------------------------------------------------------
        // WS closed/error.
        //
        // Polling becomes fallback.
        // ------------------------------------------------------

        _startPollingIfAllowed();

        if (kDebugMode) {
          debugPrint('VENDOR CHAT DETAIL: WS DISCONNECTED -> POLLING STARTED');
        }

        break;

      case VendorChatWsConnectionState.connecting:
      case VendorChatWsConnectionState.authenticating:
      case VendorChatWsConnectionState.subscribing:
        // ------------------------------------------------------
        // Keep polling while WS is connecting/authenticating.
        // ------------------------------------------------------

        _startPollingIfAllowed();

        break;
    }
  }

  // ============================================================
  // Polling
  // ============================================================

  void _startPollingIfAllowed() {
    if (_isDisposed) {
      return;
    }

    if (!_chatVisible) {
      return;
    }

    if (!_appInForeground) {
      return;
    }

    if (_wsService.isConnected) {
      return;
    }

    if (_pollingTimer != null) {
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'VENDOR CHAT DETAIL: POLLING STARTED '
        '(every ${_pollingInterval.inSeconds}s)',
      );
    }

    // ----------------------------------------------------------
    // Immediate poll
    // ----------------------------------------------------------

    unawaited(_pollLatestMessages());

    // ----------------------------------------------------------
    // Periodic polling
    // ----------------------------------------------------------

    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      if (_isDisposed || !_chatVisible || !_appInForeground) {
        _stopPolling();
        return;
      }

      if (_wsService.isConnected) {
        _stopPolling();
        return;
      }

      unawaited(_pollLatestMessages());
    });
  }

  // ============================================================
  // Stop Polling
  // ============================================================

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;

    if (kDebugMode) {
      debugPrint('VENDOR CHAT DETAIL: POLLING STOPPED');
    }
  }

  // ============================================================
  // Poll Latest Messages
  //
  // IMPORTANT:
  //
  // This does NOT reset pagination.
  //
  // It only checks page 1 for newly arrived messages.
  // ============================================================

  Future<void> _pollLatestMessages() async {
    if (_isDisposed) {
      return;
    }

    if (_pollingInProgress) {
      return;
    }

    if (!_chatVisible) {
      return;
    }

    if (!_appInForeground) {
      return;
    }

    if (_wsService.isConnected) {
      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    _pollingInProgress = true;

    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('VENDOR CHAT DETAIL: POLLING REQUEST');
        debugPrint('CHAT ID: $chatId');
        debugPrint('PAGE: 1');
        debugPrint('LIMIT: ${state.limit}');
      }

      final result = await _repository.getChatDetail(chatId: chatId);

      if (_isDisposed) {
        return;
      }

      // --------------------------------------------------------
      // Update chat info if API returned it.
      // --------------------------------------------------------

      final mergedMessages = _mergeMessages(result.messages, state.messages);

      final sortedMessages = _sortMessages(mergedMessages);

      final hasNewMessages = sortedMessages.length > state.messages.length;

      state = state.copyWith(
        chat: result.chat ?? state.chat,
        messages: sortedMessages,
        clearError: true,
      );

      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: POLLING SUCCESS');
        debugPrint('INCOMING: ${result.messages.length}');
        debugPrint('TOTAL: ${sortedMessages.length}');
        debugPrint('NEW MESSAGES: $hasNewMessages');
        debugPrint('LATEST: ${_latestMessageText(sortedMessages)}');
      }
    } on ApiException catch (error) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL POLLING API ERROR: '
          '${error.message}',
        );
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL POLLING ERROR: $error');
      }
    } finally {
      _pollingInProgress = false;
    }
  }

  // ============================================================
  // Initial Load
  // ============================================================

  Future<void> loadChat() async {
    if (_requestInProgress) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: Load already in progress.');
      }

      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: Cannot load chat. Chat ID is null.');
      }

      return;
    }

    _requestInProgress = true;

    // ------------------------------------------------------------
    // Stop polling while fresh API request is running.
    // ------------------------------------------------------------

    _stopPolling();

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT DETAIL: FRESH OPEN / LOAD            ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('CHAT ID: $chatId');
      debugPrint('PAGE: 1');
      debugPrint('LIMIT: ${state.limit}');
      debugPrint('SHIMMER: SHOW');
    }

    // ------------------------------------------------------------
    // IMPORTANT:
    //
    // Clear old messages immediately.
    //
    // This guarantees:
    //
    // isLoading = true
    // messages = empty
    //
    // Therefore ChatDetailShimmer is displayed.
    // ------------------------------------------------------------

    state = state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      isRefreshing: false,
      messages: const [],
      currentPage: 1,
      hasMore: true,
      clearError: true,
    );

    try {
      // ----------------------------------------------------------
      // FRESH API REQUEST
      // ----------------------------------------------------------

      final result = await _repository.getChatDetail(chatId: chatId);

      if (_isDisposed) {
        return;
      }

      // ----------------------------------------------------------
      // Sort fresh messages.
      // ----------------------------------------------------------

      final messages = _sortMessages(result.messages);

      final pagination = result.pagination;

      final currentPage = pagination?.currentPage ?? 1;

      final limit = pagination?.limit ?? state.limit;

      final hasMore = messages.length >= limit;

      // ----------------------------------------------------------
      // Update state with fresh API data.
      // ----------------------------------------------------------

      state = state.copyWith(
        chat: result.chat,
        messages: messages,
        currentPage: currentPage,
        limit: limit,
        hasMore: hasMore,
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        clearError: true,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT DETAIL: FRESH LOAD SUCCESS          ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('CHAT ID: $chatId');
        debugPrint('MESSAGE COUNT: ${messages.length}');
        debugPrint('CURRENT PAGE: $currentPage');
        debugPrint('LIMIT: $limit');
        debugPrint('HAS MORE: $hasMore');
        debugPrint('SHIMMER: HIDE');
        debugPrint('LATEST: ${_latestMessageText(messages)}');
        debugPrint('OLDEST: ${_oldestMessageText(messages)}');
      }
    } on ApiException catch (error) {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: error.message,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT DETAIL: FRESH LOAD API ERROR        ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('CHAT ID: $chatId');
        debugPrint('ERROR: ${error.message}');
        debugPrint('SHIMMER: HIDE');
      }
    } catch (error) {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        errorMessage: 'Something went wrong. Please try again.',
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('╔════════════════════════════════════════════════════╗');
        debugPrint('║ VENDOR CHAT DETAIL: FRESH LOAD ERROR            ║');
        debugPrint('╚════════════════════════════════════════════════════╝');
        debugPrint('CHAT ID: $chatId');
        debugPrint('ERROR: $error');
        debugPrint('SHIMMER: HIDE');
      }
    } finally {
      _requestInProgress = false;

      // ----------------------------------------------------------
      // Resume polling fallback if WebSocket is unavailable.
      // ----------------------------------------------------------

      if (_chatVisible && _appInForeground && !_wsService.isConnected) {
        _startPollingIfAllowed();
      }
    }
  }
  // ============================================================
  // Load Older Messages
  // ============================================================

  Future<void> loadMoreMessages() async {
    if (_requestInProgress) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    if (state.isLoadingMore) {
      return;
    }

    if (!state.hasMore) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: No more older messages.');
      }

      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    final nextPage = state.currentPage + 1;

    _requestInProgress = true;

    state = state.copyWith(isLoadingMore: true, clearError: true);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT DETAIL: LOAD OLDER MESSAGES           ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('CHAT ID: $chatId');
      debugPrint('NEXT PAGE: $nextPage');
      debugPrint('LIMIT: ${state.limit}');
    }

    try {
      final result = await _repository.getChatDetail(chatId: chatId);

      if (_isDisposed) {
        return;
      }

      final incomingMessages = _sortMessages(result.messages);

      final mergedMessages = _mergeMessages(incomingMessages, state.messages);

      final sortedMessages = _sortMessages(mergedMessages);

      final pagination = result.pagination;

      final currentPage = pagination?.currentPage ?? nextPage;

      final limit = pagination?.limit ?? state.limit;

      final hasMore = incomingMessages.length >= limit;

      state = state.copyWith(
        chat: result.chat ?? state.chat,
        messages: sortedMessages,
        currentPage: currentPage,
        limit: limit,
        hasMore: hasMore,
        isLoadingMore: false,
        clearError: true,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('VENDOR CHAT DETAIL: LOAD MORE SUCCESS');
        debugPrint('INCOMING: ${incomingMessages.length}');
        debugPrint('TOTAL: ${sortedMessages.length}');
        debugPrint('CURRENT PAGE: $currentPage');
        debugPrint('HAS MORE: $hasMore');
        debugPrint('OLDEST: ${_oldestMessageText(sortedMessages)}');
        debugPrint('LATEST: ${_latestMessageText(sortedMessages)}');
      }
    } on ApiException catch (error) {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(isLoadingMore: false, errorMessage: error.message);

      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL LOAD MORE API ERROR: '
          '${error.message}',
        );
      }
    } catch (error) {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Unable to load older messages.',
      );

      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL LOAD MORE ERROR: $error');
      }
    } finally {
      _requestInProgress = false;
    }
  }

  // ============================================================
  // ADD REAL-TIME / SENT MESSAGE
  // ============================================================

  void addMessage(VendorChatDetailMessageModel message) {
    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // Validate conversation ID
    // ----------------------------------------------------------

    final messageConversationId = message.conversationId;

    if (messageConversationId != null &&
        state.chatId != null &&
        messageConversationId != state.chatId) {
      debugPrint(
        'VENDOR CHAT DETAIL: Ignored message '
        'for different conversation.',
      );

      debugPrint('EXPECTED CHAT ID: ${state.chatId}');

      debugPrint('MESSAGE CHAT ID: $messageConversationId');

      return;
    }

    // ----------------------------------------------------------
    // Message must have an ID.
    //
    // This is important for reliable duplicate protection.
    // ----------------------------------------------------------

    final messageId = message.id;

    if (messageId == null) {
      debugPrint(
        'VENDOR CHAT DETAIL: Ignored message '
        'because message ID is missing.',
      );

      return;
    }

    final existingMessages = List<VendorChatDetailMessageModel>.from(
      state.messages,
    );

    // ----------------------------------------------------------
    // Find existing message.
    // ----------------------------------------------------------

    final existingIndex = existingMessages.indexWhere(
      (item) => item.id == messageId,
    );

    if (existingIndex >= 0) {
      // --------------------------------------------------------
      // Same message already exists.
      //
      // Replace instead of adding duplicate.
      // This also allows fields such as is_read to update.
      // --------------------------------------------------------

      existingMessages[existingIndex] = message;

      debugPrint(
        'VENDOR CHAT DETAIL: Message updated '
        '(duplicate ID prevented).',
      );

      debugPrint('MESSAGE ID: $messageId');
    } else {
      // --------------------------------------------------------
      // New message.
      // --------------------------------------------------------

      existingMessages.add(message);

      debugPrint('VENDOR CHAT DETAIL: New message appended.');

      debugPrint('MESSAGE ID: $messageId');
    }

    // ----------------------------------------------------------
    // Always keep chronological order:
    //
    // oldest -> latest
    //
    // ListView reverse=false
    // latest message = last item
    // ----------------------------------------------------------

    final sortedMessages = _sortMessages(existingMessages);

    state = state.copyWith(messages: sortedMessages, clearError: true);

    debugPrint(
      'VENDOR CHAT DETAIL: TOTAL MESSAGES '
      '${sortedMessages.length}',
    );

    debugPrint(
      'VENDOR CHAT DETAIL: LATEST MESSAGE '
      '${_latestMessageText(sortedMessages)}',
    );
  }

  // ============================================================
  // Refresh Chat
  //
  // IMPORTANT:
  //
  // Refresh resets pagination to page 1.
  //
  // Then WS is manually reconnected.
  // ============================================================

  Future<void> refreshChat() async {
    if (_requestInProgress) {
      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    _requestInProgress = true;

    _stopPolling();

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT DETAIL: REFRESH                       ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('CHAT ID: $chatId');
      debugPrint('RESET PAGE: 1');
    }

    state = state.copyWith(
      isLoading: true,
      isRefreshing: true,
      isLoadingMore: false,
      currentPage: 1,
      hasMore: true,
      clearError: true,
    );

    try {
      // --------------------------------------------------------
      // Force WS reconnect.
      //
      // Polling remains active until WS reaches subscribed.
      // --------------------------------------------------------

      if (_chatVisible && _appInForeground) {
        unawaited(_manualReconnectWebSocket());
      }

      final result = await _repository.getChatDetail(chatId: chatId);

      if (_isDisposed) {
        return;
      }

      final messages = _sortMessages(result.messages);

      final pagination = result.pagination;

      final currentPage = pagination?.currentPage ?? 1;

      final limit = pagination?.limit ?? state.limit;

      final hasMore = messages.length >= limit;

      state = state.copyWith(
        chat: result.chat,
        messages: messages,
        currentPage: currentPage,
        limit: limit,
        hasMore: hasMore,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        clearError: true,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint('VENDOR CHAT DETAIL: REFRESH SUCCESS');
        debugPrint('MESSAGES: ${messages.length}');
        debugPrint('CURRENT PAGE: $currentPage');
        debugPrint('LIMIT: $limit');
        debugPrint('HAS MORE: $hasMore');
      }
    } on ApiException catch (error) {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        errorMessage: error.message,
      );

      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL REFRESH API ERROR: '
          '${error.message}',
        );
      }
    } catch (error) {
      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        errorMessage: 'Unable to refresh chat.',
      );

      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL REFRESH ERROR: $error');
      }
    } finally {
      _requestInProgress = false;

      // --------------------------------------------------------
      // If WS reconnect did not happen / failed, polling fallback
      // will automatically remain active.
      // --------------------------------------------------------

      if (_chatVisible && _appInForeground && !_wsService.isConnected) {
        _startPollingIfAllowed();
      }
    }
  }

  // ============================================================
  // Manual WebSocket Reconnect
  // ============================================================

  Future<void> _manualReconnectWebSocket() async {
    if (_isDisposed) {
      return;
    }

    if (!_chatVisible) {
      return;
    }

    if (!_appInForeground) {
      return;
    }

    final chatId = state.chatId;

    if (chatId == null) {
      return;
    }

    try {
      // --------------------------------------------------------
      // Polling fallback starts while reconnecting.
      // --------------------------------------------------------

      _startPollingIfAllowed();

      await _wsService.reconnect();

      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: WS MANUAL RECONNECT REQUESTED');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL WS RECONNECT ERROR: $error');
      }

      _startPollingIfAllowed();
    }
  }

  // ============================================================
  // WebSocket Message
  // ============================================================

  void _handleWsMessage(Map<String, dynamic> event) {
    if (_isDisposed) {
      return;
    }

    final type = event['type']?.toString();

    if (type != 'new_message') {
      return;
    }

    final conversationId = _parseInt(event['conversation_id']);

    if (conversationId == null) {
      return;
    }

    if (conversationId != state.chatId) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL: Ignoring WS message '
          'for chat $conversationId.',
        );
      }

      return;
    }

    final rawMessage = event['message'];

    if (rawMessage is! Map) {
      if (kDebugMode) {
        debugPrint('VENDOR CHAT DETAIL: Invalid WS message.');
      }

      return;
    }

    try {
      final message = VendorChatDetailMessageModel.fromJson(
        Map<String, dynamic>.from(rawMessage),
      );

      _addRealtimeMessage(message);
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          'VENDOR CHAT DETAIL: WS message parse error: '
          '$error',
        );
      }
    }
  }

  // ============================================================
  // Add Realtime Message
  // ============================================================

  void _addRealtimeMessage(VendorChatDetailMessageModel message) {
    if (_isDisposed) {
      return;
    }

    final messageId = message.id;

    // ----------------------------------------------------------
    // Duplicate protection
    // ----------------------------------------------------------

    if (messageId != null) {
      final alreadyExists = state.messages.any((item) => item.id == messageId);

      if (alreadyExists) {
        if (kDebugMode) {
          debugPrint(
            'VENDOR CHAT DETAIL: Duplicate WS message '
            'ignored. ID: $messageId',
          );
        }

        return;
      }
    }

    // ----------------------------------------------------------
    // Add at end first.
    //
    // Sorting below guarantees latest stays at bottom.
    // ----------------------------------------------------------

    final updatedMessages = <VendorChatDetailMessageModel>[
      ...state.messages,
      message,
    ];

    final sortedMessages = _sortMessages(updatedMessages);

    state = state.copyWith(messages: sortedMessages, clearError: true);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('╔════════════════════════════════════════════════════╗');
      debugPrint('║ VENDOR CHAT DETAIL: WS NEW MESSAGE              ║');
      debugPrint('╚════════════════════════════════════════════════════╝');
      debugPrint('MESSAGE ID: ${message.id}');
      debugPrint('SENDER TYPE: ${message.senderType}');
      debugPrint('MESSAGE: ${message.message}');
      debugPrint('TOTAL: ${sortedMessages.length}');
      debugPrint('LATEST: ${_latestMessageText(sortedMessages)}');
    }
  }

  // ============================================================
  // Merge Messages
  // ============================================================

  List<VendorChatDetailMessageModel> _mergeMessages(
    List<VendorChatDetailMessageModel> incomingMessages,
    List<VendorChatDetailMessageModel> existingMessages,
  ) {
    final result = <VendorChatDetailMessageModel>[];

    final ids = <int>{};

    // ----------------------------------------------------------
    // Incoming messages
    // ----------------------------------------------------------

    for (final message in incomingMessages) {
      final id = message.id;

      if (id != null) {
        if (ids.add(id)) {
          result.add(message);
        }
      } else {
        result.add(message);
      }
    }

    // ----------------------------------------------------------
    // Existing messages
    // ----------------------------------------------------------

    for (final message in existingMessages) {
      final id = message.id;

      if (id != null) {
        if (ids.add(id)) {
          result.add(message);
        }
      } else {
        result.add(message);
      }
    }

    return result;
  }

  // ============================================================
  // Sort Messages
  //
  // OLD -> NEW
  //
  // Therefore:
  //
  // first = oldest
  // last  = latest
  // ============================================================

  List<VendorChatDetailMessageModel> _sortMessages(
    List<VendorChatDetailMessageModel> messages,
  ) {
    final sorted = List<VendorChatDetailMessageModel>.from(messages);

    sorted.sort((a, b) {
      final dateA = _parseDate(a.createdAt);
      final dateB = _parseDate(b.createdAt);

      // ------------------------------------------------------
      // Both dates
      // ------------------------------------------------------

      if (dateA != null && dateB != null) {
        return dateA.compareTo(dateB);
      }

      // ------------------------------------------------------
      // A has date
      // ------------------------------------------------------

      if (dateA != null && dateB == null) {
        return -1;
      }

      // ------------------------------------------------------
      // B has date
      // ------------------------------------------------------

      if (dateA == null && dateB != null) {
        return 1;
      }

      // ------------------------------------------------------
      // ID fallback
      // ------------------------------------------------------

      final idA = a.id ?? 0;
      final idB = b.id ?? 0;

      return idA.compareTo(idB);
    });

    return sorted;
  }

  // ============================================================
  // Parse Date
  // ============================================================

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value.replaceFirst(' ', 'T'));
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // Int Parser
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
  // Latest Message
  // ============================================================

  String _latestMessageText(List<VendorChatDetailMessageModel> messages) {
    if (messages.isEmpty) {
      return 'N/A';
    }

    final message = messages.last;

    if (message.isProductCard) {
      return '[Product Card]';
    }

    return message.message?.isNotEmpty == true
        ? message.message!
        : '[Empty Message]';
  }

  // ============================================================
  // Oldest Message
  // ============================================================

  String _oldestMessageText(List<VendorChatDetailMessageModel> messages) {
    if (messages.isEmpty) {
      return 'N/A';
    }

    final message = messages.first;

    if (message.isProductCard) {
      return '[Product Card]';
    }

    return message.message?.isNotEmpty == true
        ? message.message!
        : '[Empty Message]';
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _isDisposed = true;

    WidgetsBinding.instance.removeObserver(this);

    _stopPolling();

    _wsMessageSubscription?.cancel();
    _wsMessageSubscription = null;

    _wsConnectionSubscription?.cancel();
    _wsConnectionSubscription = null;

    unawaited(_wsService.dispose());

    super.dispose();
  }
}
