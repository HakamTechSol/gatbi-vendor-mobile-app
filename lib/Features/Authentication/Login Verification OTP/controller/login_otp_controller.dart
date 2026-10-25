import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';
import '../../../../Services/device_registration_helper.dart'; // NEW: Imported Helper

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

      // IMPORTANT: Update DioClient headers immediately so
      // the device registration API is authenticated.
      _dioClient.updateAuthToken(token);

      // ==========================================================
      // MARK USER AUTHENTICATED
      // ==========================================================

      AuthSession.instance.markAuthenticated();

      // ==========================================================
      // REGISTER FCM DEVICE (Using the Helper)
      // ==========================================================

      await DeviceRegistrationHelper.registerDevice(dioClient: _dioClient);

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
