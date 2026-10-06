import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../firebase_options.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance =
      FirebaseMessagingService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin
      _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<String>?
      _tokenRefreshSubscription;

  StreamSubscription<RemoteMessage>?
      _foregroundMessageSubscription;

  StreamSubscription<RemoteMessage>?
      _messageOpenedAppSubscription;

  // ============================================================
  // ANDROID NOTIFICATION CHANNEL
  // ============================================================

  static const AndroidNotificationChannel
      _notificationChannel =
      AndroidNotificationChannel(
    'gatbi_vendor_notifications',
    'Gatbi Vendor Notifications',
    description:
        'Notifications for Gatbi Vendor application.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '==============================================',
        );
        debugPrint(
          '       FIREBASE CLOUD MESSAGING SETUP',
        );
        debugPrint(
          '==============================================',
        );
      }

      await _initializeLocalNotifications();

      await _requestPermission();

      await _configureForegroundNotificationPresentation();

      await _getAndPrintToken();

      _listenToTokenRefresh();

      _listenToForegroundMessages();

      _listenToNotificationOpenedApp();

      await _checkInitialMessage();

      if (kDebugMode) {
        debugPrint(
          '==============================================',
        );
        debugPrint(
          '       FCM INITIALIZATION COMPLETED',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint('');
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== FCM INITIALIZATION ERROR ==========',
        );
        debugPrint('ERROR: $error');
        debugPrint(
          'STACK TRACE: $stackTrace',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint('');
      }
    }
  }

  // ============================================================
  // LOCAL NOTIFICATION INITIALIZATION
  // ============================================================

  Future<void> _initializeLocalNotifications() async {
    try {
      // ----------------------------------------------------------
      // ANDROID
      // ----------------------------------------------------------

      const AndroidInitializationSettings
          androidSettings =
          AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // ----------------------------------------------------------
      // IOS
      // ----------------------------------------------------------

      const DarwinInitializationSettings
          iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      // ----------------------------------------------------------
      // GENERAL SETTINGS
      // ----------------------------------------------------------

      const InitializationSettings settings =
          InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // ----------------------------------------------------------
      // INITIALIZE
      // ----------------------------------------------------------

      await _localNotifications.initialize(
        settings: settings,
        onDidReceiveNotificationResponse:
            _onLocalNotificationTap,
      );

      // ----------------------------------------------------------
      // ANDROID CHANNEL
      // ----------------------------------------------------------

      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin?
            androidPlugin =
            _localNotifications
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

        await androidPlugin
            ?.createNotificationChannel(
          _notificationChannel,
        );

        await androidPlugin
            ?.requestNotificationsPermission();
      }

      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== LOCAL NOTIFICATION READY ==========',
        );
        debugPrint(
          'CHANNEL ID: ${_notificationChannel.id}',
        );
        debugPrint(
          'CHANNEL NAME: ${_notificationChannel.name}',
        );
        debugPrint(
          'IMPORTANCE: '
          '${_notificationChannel.importance}',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint('');
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== LOCAL NOTIFICATION ERROR ==========',
        );
        debugPrint('ERROR: $error');
        debugPrint(
          'STACK TRACE: $stackTrace',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint('');
      }
    }
  }

  // ============================================================
  // LOCAL NOTIFICATION TAP
  // ============================================================

  void _onLocalNotificationTap(
    NotificationResponse response,
  ) {
    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '========== LOCAL NOTIFICATION TAP ==========',
      );
      debugPrint(
        'PAYLOAD: '
        '${response.payload ?? 'N/A'}',
      );
      debugPrint(
        '============================================',
      );
      debugPrint('');
    }
  }

  // ============================================================
  // FCM PERMISSION
  // ============================================================

  Future<void> _requestPermission() async {
    try {
      final NotificationSettings settings =
          await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '---------- FCM PERMISSION ----------',
        );
        debugPrint(
          'AUTHORIZATION STATUS: '
          '${settings.authorizationStatus}',
        );
        debugPrint(
          'ALERT: ${settings.alert}',
        );
        debugPrint(
          'BADGE: ${settings.badge}',
        );
        debugPrint(
          'SOUND: ${settings.sound}',
        );
        debugPrint(
          '------------------------------------',
        );
        debugPrint('');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          'FCM permission error: $error',
        );
      }
    }
  }

  // ============================================================
  // FOREGROUND PRESENTATION
  // ============================================================

  Future<void>
      _configureForegroundNotificationPresentation() async {
    if (!Platform.isIOS) {
      return;
    }

    await _messaging
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      debugPrint(
        'iOS foreground notification presentation enabled.',
      );
    }
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final String? apnsToken =
            await _waitForApnsToken();

        if (kDebugMode) {
          debugPrint(
            'APNs TOKEN: '
            '${apnsToken ?? 'NOT AVAILABLE'}',
          );
        }

        if (apnsToken == null ||
            apnsToken.isEmpty) {
          if (kDebugMode) {
            debugPrint(
              'FCM TOKEN: '
              'APNs token is not available yet.',
            );
          }

          return null;
        }
      }

      final String? token =
          await _messaging.getToken();

      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '==============================================',
        );
        debugPrint(
          '                 FCM TOKEN',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint(
          token ?? 'FCM TOKEN IS NULL',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint('');
      }

      return token;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== FCM TOKEN ERROR ==========',
        );
        debugPrint('ERROR: $error');
        debugPrint(
          'STACK TRACE: $stackTrace',
        );
        debugPrint(
          '=====================================',
        );
        debugPrint('');
      }

      return null;
    }
  }

  // ============================================================
  // INITIAL TOKEN
  // ============================================================

  Future<void> _getAndPrintToken() async {
    await getToken();
  }

  // ============================================================
  // APNs TOKEN
  // ============================================================

  Future<String?> _waitForApnsToken({
    int attempts = 10,
    Duration delay =
        const Duration(milliseconds: 500),
  }) async {
    for (int i = 0; i < attempts; i++) {
      final String? token =
          await _messaging.getAPNSToken();

      if (token != null &&
          token.isNotEmpty) {
        return token;
      }

      await Future<void>.delayed(delay);
    }

    return null;
  }

  // ============================================================
  // TOKEN REFRESH
  // ============================================================

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription =
        _messaging.onTokenRefresh.listen(
      (String token) {
        if (kDebugMode) {
          debugPrint('');
          debugPrint(
            '==============================================',
          );
          debugPrint(
            '             FCM TOKEN REFRESHED',
          );
          debugPrint(
            '==============================================',
          );
          debugPrint(token);
          debugPrint(
            '==============================================',
          );
          debugPrint('');
        }

        // Device registration API
        // yahan later connect karenge.
      },
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint(
            'FCM token refresh error: $error',
          );
        }
      },
    );
  }

  // ============================================================
  // FOREGROUND MESSAGE
  // ============================================================

  void _listenToForegroundMessages() {
    _foregroundMessageSubscription?.cancel();

    _foregroundMessageSubscription =
        FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        _printMessage(
          message,
          source: 'FOREGROUND',
        );

        await _showForegroundNotification(
          message,
        );
      },
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint(
            'FCM foreground listener error: $error',
          );
        }
      },
    );
  }

  // ============================================================
  // SHOW FOREGROUND NOTIFICATION
  // ============================================================

  Future<void> _showForegroundNotification(
    RemoteMessage message,
  ) async {
    try {
      final RemoteNotification? notification =
          message.notification;

      final String title =
          notification?.title ??
              message.data['title']?.toString() ??
              'Gatbi Vendor';

      final String body =
          notification?.body ??
              message.data['body']?.toString() ??
              'You have a new notification.';

      // ----------------------------------------------------------
      // ANDROID
      // ----------------------------------------------------------

      const AndroidNotificationDetails
          androidDetails =
          AndroidNotificationDetails(
        'gatbi_vendor_notifications',
        'Gatbi Vendor Notifications',
        channelDescription:
            'Notifications for Gatbi Vendor application.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      // ----------------------------------------------------------
      // IOS
      // ----------------------------------------------------------

      const DarwinNotificationDetails
          iosDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // ----------------------------------------------------------
      // GENERAL
      // ----------------------------------------------------------

      const NotificationDetails details =
          NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final int notificationId =
          message.messageId?.hashCode ??
              DateTime.now()
                  .millisecondsSinceEpoch;

      // ----------------------------------------------------------
      // SHOW
      // ----------------------------------------------------------

      await _localNotifications.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: details,
        payload: message.data.isNotEmpty
            ? message.data.toString()
            : null,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== LOCAL NOTIFICATION SHOWN ==========',
        );
        debugPrint(
          'ID: $notificationId',
        );
        debugPrint(
          'TITLE: $title',
        );
        debugPrint(
          'BODY: $body',
        );
        debugPrint(
          'DATA: ${message.data}',
        );
        debugPrint(
          '==============================================',
        );
        debugPrint('');
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== SHOW NOTIFICATION ERROR ==========',
        );
        debugPrint(
          'ERROR: $error',
        );
        debugPrint(
          'STACK TRACE: $stackTrace',
        );
        debugPrint(
          '=============================================',
        );
        debugPrint('');
      }
    }
  }

  // ============================================================
  // BACKGROUND TAP
  // ============================================================

  void _listenToNotificationOpenedApp() {
    _messageOpenedAppSubscription?.cancel();

    _messageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        _printMessage(
          message,
          source: 'OPENED FROM BACKGROUND',
        );

        _handleNotificationTap(message);
      },
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint(
            'FCM notification opened error: $error',
          );
        }
      },
    );
  }

  // ============================================================
  // TERMINATED STATE
  // ============================================================

  Future<void> _checkInitialMessage() async {
    try {
      final RemoteMessage? message =
          await _messaging.getInitialMessage();

      if (message == null) {
        if (kDebugMode) {
          debugPrint(
            'No initial FCM notification found.',
          );
        }

        return;
      }

      _printMessage(
        message,
        source: 'OPENED FROM TERMINATED STATE',
      );

      _handleNotificationTap(message);
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          'Initial FCM message error: $error',
        );
      }
    }
  }

  // ============================================================
  // BACKGROUND MESSAGE
  // ============================================================

  @pragma('vm:entry-point')
  static Future<void>
      firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    try {
      await Firebase.initializeApp(
        options:
            DefaultFirebaseOptions.currentPlatform,
      );

      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '========== FCM BACKGROUND MESSAGE ==========',
        );
        debugPrint(
          'MESSAGE ID: ${message.messageId}',
        );
        debugPrint(
          'TITLE: '
          '${message.notification?.title ?? 'N/A'}',
        );
        debugPrint(
          'BODY: '
          '${message.notification?.body ?? 'N/A'}',
        );
        debugPrint(
          'DATA: ${message.data}',
        );
        debugPrint(
          '============================================',
        );
        debugPrint('');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          'FCM background handler error: $error',
        );
      }
    }
  }

  // ============================================================
  // PRINT MESSAGE
  // ============================================================

  void _printMessage(
    RemoteMessage message, {
    required String source,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint(
      '==============================================',
    );
    debugPrint(
      '              FCM MESSAGE',
    );
    debugPrint(
      'SOURCE: $source',
    );
    debugPrint(
      '==============================================',
    );

    debugPrint(
      'MESSAGE ID: '
      '${message.messageId ?? 'N/A'}',
    );

    debugPrint(
      'FROM: '
      '${message.from ?? 'N/A'}',
    );

    debugPrint(
      'TITLE: '
      '${message.notification?.title ?? 'N/A'}',
    );

    debugPrint(
      'BODY: '
      '${message.notification?.body ?? 'N/A'}',
    );

    debugPrint(
      'IMAGE: '
      '${message.notification?.android?.imageUrl ?? 'N/A'}',
    );

    debugPrint(
      'DATA: ${message.data}',
    );

    debugPrint(
      'SENT TIME: '
      '${message.sentTime ?? 'N/A'}',
    );

    debugPrint(
      '==============================================',
    );
    debugPrint('');
  }

  // ============================================================
  // NOTIFICATION TAP
  // ============================================================

  void _handleNotificationTap(
    RemoteMessage message,
  ) {
    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '========== FCM NOTIFICATION TAP ==========',
      );
      debugPrint(
        'DATA: ${message.data}',
      );
      debugPrint(
        '==========================================',
      );
      debugPrint('');
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();

    await _foregroundMessageSubscription?.cancel();

    await _messageOpenedAppSubscription?.cancel();

    _tokenRefreshSubscription = null;
    _foregroundMessageSubscription = null;
    _messageOpenedAppSubscription = null;
  }
}