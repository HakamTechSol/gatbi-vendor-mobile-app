import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';
import '../Models/login_resend_otp_model.dart';
import '../Models/login_verify_otp_model.dart';
import '../Repo/login_otp_repo.dart';

class OtpController {
  OtpController({required DioClient dioClient})
    : _repository = OtpRepository(dioClient);

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

      if (result.success != true) {
        throw ApiException(
          message:
              result.message ?? 'OTP verification failed. Please try again.',
          code: 'OTP_VERIFICATION_FAILED',
        );
      }

      final token = result.token;

      if (token == null || token.isEmpty) {
        throw const ApiException(
          message: 'Authentication token was not received.',
          code: 'TOKEN_NOT_RECEIVED',
        );
      }

      await SecureStorageService.instance.saveToken(token);

      AuthSession.instance.markAuthenticated();

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
