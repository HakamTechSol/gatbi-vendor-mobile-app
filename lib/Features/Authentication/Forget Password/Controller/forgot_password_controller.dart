import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../Models/forgot_password_model.dart';
import '../Repo/forgot_password_repo.dart';

class ForgotPasswordController {
  ForgotPasswordController({required DioClient dioClient})
    : _repository = ForgotPasswordRepository(dioClient);

  final ForgotPasswordRepository _repository;

  Future<ForgotPasswordModel> forgotPassword({required String email}) async {
    try {
      final result = await _repository.forgotPassword(email: email);

      if (result.success != true) {
        throw ApiException(
          message:
              result.message ??
              'Unable to process your request. Please try again.',
          code: 'FORGOT_PASSWORD_FAILED',
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
