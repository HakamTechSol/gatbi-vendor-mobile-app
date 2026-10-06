import 'dart:io';

import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';

import '../../../Push Notification/Devices Registered/Controller/device_registered_controller.dart';
import '../../../Push Notification/Devices Registered/Models/device_registered_model.dart';
import '../../../Push Notification/Services/firebase_messaging_service.dart';

import '../Models/login_resend_otp_model.dart';
import '../Models/login_verify_otp_model.dart';
import '../Repo/login_otp_repo.dart';

class OtpController {
  OtpController({required DioClient dioClient})
    : _dioClient = dioClient,
      _repository = OtpRepository(dioClient);

  final DioClient _dioClient;
  final OtpRepository _repository;

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<VerifyOtpModel> verifyOtp({
    required int merchantId,
    required String otp,
  }) async {
    try {
      final result = await _repository.verifyOtp(
        merchantId: merchantId,
        otp: otp,
      );

      // ==========================================================
      // VERIFY API SUCCESS
      // ==========================================================

      if (result.success != true) {
        throw ApiException(
          message:
              result.message ?? 'OTP verification failed. Please try again.',
          code: 'OTP_VERIFICATION_FAILED',
        );
      }

      // ==========================================================
      // GET AUTH TOKEN
      // ==========================================================

      final token = result.token;

      if (token == null || token.isEmpty) {
        throw const ApiException(
          message: 'Authentication token was not received.',
          code: 'TOKEN_NOT_RECEIVED',
        );
      }

      // ==========================================================
      // SAVE JWT
      // ==========================================================

      await SecureStorageService.instance.saveToken(token);

      // ==========================================================
      // MARK USER AUTHENTICATED
      // ==========================================================

      AuthSession.instance.markAuthenticated();

      // ==========================================================
      // REGISTER FCM DEVICE
      // ==========================================================

      await _registerDevice();

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
  // REGISTER DEVICE
  // ============================================================

  Future<void> _registerDevice() async {
    try {
      // ----------------------------------------------------------
      // Get FCM Token
      // ----------------------------------------------------------

      final String? fcmToken = await FirebaseMessagingService.instance
          .getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
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

      print('');
      print('========== DEVICE REGISTRATION ==========');
      print('FCM TOKEN: $fcmToken');
      print('PLATFORM: $platform');
      print('=========================================');
      print('');

      // ----------------------------------------------------------
      // Controller
      // ----------------------------------------------------------

      final controller = DeviceRegisteredController(dioClient: _dioClient);

      // ----------------------------------------------------------
      // Register API
      // ----------------------------------------------------------

      final DeviceRegisteredModel result = await controller.registerDevice(
        token: fcmToken,
        platform: platform,
      );

      // ----------------------------------------------------------
      // Result
      // ----------------------------------------------------------

      if (result.success != true) {
        if (result.message != null) {
          print('DEVICE REGISTRATION FAILED: ${result.message}');
        }

        return;
      }

      print('DEVICE REGISTRATION SUCCESS');
      print('MESSAGE: ${result.message ?? 'N/A'}');
      print('');
    } catch (error) {
      // ----------------------------------------------------------
      // Device registration failure should NOT undo
      // successful OTP authentication.
      // ----------------------------------------------------------

      print('');
      print('========== DEVICE REGISTRATION ERROR ==========');
      print('ERROR: $error');
      print('===============================================');
      print('');
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<ResendOtpModel> resendOtp({required int merchantId}) async {
    try {
      final result = await _repository.resendOtp(merchantId: merchantId);

      if (result.success != true) {
        throw ApiException(
          message: result.message ?? 'Unable to resend OTP. Please try again.',
          code: 'RESEND_OTP_FAILED',
        );
      }

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
}
