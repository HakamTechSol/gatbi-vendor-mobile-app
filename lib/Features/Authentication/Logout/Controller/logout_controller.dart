import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/dio_client.dart';
import '../../../../Services/token_storage.dart';
import '../Model/logout_model.dart';
import '../Repo/logout_repo.dart';

class LogoutController {
  LogoutController({required DioClient dioClient})
    : _repository = LogoutRepository(dioClient);

  final LogoutRepository _repository;

  Future<LogoutModel> logout() async {
    try {
      final result = await _repository.logout();

      if (result.success != true) {
        throw ApiException(
          message: result.message ?? 'Unable to logout. Please try again.',
          code: 'LOGOUT_FAILED',
        );
      }

      // ================================================================
      // DELETE LOCAL JWT AFTER SERVER-SIDE LOGOUT SUCCESS
      // ================================================================

      await SecureStorageService.instance.deleteToken();

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
}
