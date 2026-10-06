import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';
import '../../../Push Notification/Devices Unregisterd/Controller/device_unregistered_controller.dart';
import '../../../Push Notification/Services/firebase_messaging_service.dart';
import '../Model/logout_model.dart';
import '../Repo/logout_repo.dart';

class LogoutController {
  LogoutController({required DioClient dioClient})
    : _dioClient = dioClient,
      _repository = LogoutRepository(dioClient);

  final DioClient _dioClient;
  final LogoutRepository _repository;

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<LogoutModel> logout() async {
    try {
      // ==========================================================
      // STEP 1
      // UNREGISTER FCM DEVICE BEFORE LOGOUT
      // ==========================================================

      await _unregisterDevice();

      // ==========================================================
      // STEP 2
      // SERVER-SIDE LOGOUT
      // ==========================================================

      final result = await _repository.logout();

      // ==========================================================
      // VALIDATE LOGOUT RESPONSE
      // ==========================================================

      if (result.success != true) {
        throw ApiException(
          message: result.message ?? 'Unable to logout. Please try again.',
          code: 'LOGOUT_FAILED',
        );
      }

      // ==========================================================
      // STEP 3
      // DELETE LOCAL JWT
      // ==========================================================

      await SecureStorageService.instance.deleteToken();

      // ==========================================================
      // STEP 4
      // CLEAR AUTH SESSION
      // ==========================================================

      await AuthSession.instance.clearSession();

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }

  // ============================================================
  // UNREGISTER DEVICE
  // ============================================================

  Future<void> _unregisterDevice() async {
    try {
      // ----------------------------------------------------------
      // Get Current FCM Token
      // ----------------------------------------------------------

      final String? fcmToken = await FirebaseMessagingService.instance
          .getToken();

      // ----------------------------------------------------------
      // Token not available
      // ----------------------------------------------------------

      if (fcmToken == null || fcmToken.isEmpty) {
        if (kDebugMode) {
          print('DEVICE UNREGISTER SKIPPED: FCM token not available.');
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

      // ----------------------------------------------------------
      // Debug
      // ----------------------------------------------------------

      if (kDebugMode) {
        print('');
        print('========== DEVICE UNREGISTRATION ==========');
        print('FCM TOKEN: $fcmToken');
        print('PLATFORM: $platform');
        print('===========================================');
        print('');
      }

      // ----------------------------------------------------------
      // Controller
      // ----------------------------------------------------------

      final controller = DeviceUnregisteredController(dioClient: _dioClient);

      // ----------------------------------------------------------
      // Unregister API
      // ----------------------------------------------------------

      final result = await controller.unregisterDevice(token: fcmToken);

      // ----------------------------------------------------------
      // Validate Result
      // ----------------------------------------------------------

      if (result.success != true) {
        throw ApiException(
          message:
              result.message ??
              'Unable to unregister device. Please try again.',
          code: 'DEVICE_UNREGISTER_FAILED',
        );
      }

      // ----------------------------------------------------------
      // Success Logs
      // ----------------------------------------------------------

      if (kDebugMode) {
        print('');
        print('DEVICE UNREGISTRATION SUCCESS');
        print('MESSAGE: ${result.message ?? 'N/A'}');
        print('');
      }
    } on ApiException {
      // Device unregister failed.
      //
      // IMPORTANT:
      // Logout continue nahi karenge.
      // User dobara logout press kar sakta hai.
      rethrow;
    } catch (error) {
      if (kDebugMode) {
        print('');
        print('========== DEVICE UNREGISTER ERROR ==========');
        print('ERROR: $error');
        print('=============================================');
        print('');
      }

      throw ApiException(
        message: 'Unable to unregister this device. Please try again.',
        code: 'DEVICE_UNREGISTER_FAILED',
        originalError: error,
      );
    }
  }
}
