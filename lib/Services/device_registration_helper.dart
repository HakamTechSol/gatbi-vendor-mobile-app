import 'dart:io';
import 'package:flutter/foundation.dart';

import '../Features/Push Notification/Devices Registered/Controller/device_registered_controller.dart';
import '../Features/Push Notification/Devices Registered/Models/device_registered_model.dart';
import '../Features/Push Notification/Services/firebase_messaging_service.dart';
import '../Services/dio_client.dart';
class DeviceRegistrationHelper {
  const DeviceRegistrationHelper._();

  /// Registers the current FCM device with the backend.
  /// Should be called AFTER the auth token has been saved to DioClient.
  static Future<void> registerDevice({
    required DioClient dioClient,
  }) async {
    try {
      // ----------------------------------------------------------
      // Get FCM Token
      // ----------------------------------------------------------
      final String? fcmToken = await FirebaseMessagingService.instance.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        if (kDebugMode) {
          debugPrint('DEVICE REGISTRATION: FCM token is empty. Skipping.');
        }
        return;
      }

      // ----------------------------------------------------------
      // Platform
      // ----------------------------------------------------------
      final String platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : 'web';

      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== DEVICE REGISTRATION (HELPER) ==========');
        debugPrint('FCM TOKEN: $fcmToken');
        debugPrint('PLATFORM: $platform');
        debugPrint('==================================================');
        debugPrint('');
      }

      // ----------------------------------------------------------
      // Controller
      // ----------------------------------------------------------
      final controller = DeviceRegisteredController(dioClient: dioClient);

      // ----------------------------------------------------------
      // API Call
      // ----------------------------------------------------------
      final DeviceRegisteredModel result = await controller.registerDevice(
        token: fcmToken,
        platform: platform,
      );

      // ----------------------------------------------------------
      // Handle Result
      // ----------------------------------------------------------
      if (result.success != true) {
        if (kDebugMode) {
          debugPrint(
            'DEVICE REGISTRATION FAILED: ${result.message ?? 'Unknown error'}',
          );
        }
        return;
      }

      if (kDebugMode) {
        debugPrint('DEVICE REGISTRATION SUCCESS');
        debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
        debugPrint('');
      }
    } catch (error) {
      // ----------------------------------------------------------
      // Device registration failure should NOT block login.
      // ----------------------------------------------------------
      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== DEVICE REGISTRATION ERROR ==========');
        debugPrint('ERROR: $error');
        debugPrint('===============================================');
        debugPrint('');
      }
    }
  }
}