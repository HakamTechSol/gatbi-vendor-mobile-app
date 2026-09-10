import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../Models/login_model.dart';
import '../Repo/login_repo.dart';

class LoginController {
  LoginController({required DioClient dioClient})
    : _repository = LoginRepository(dioClient);

  final LoginRepository _repository;

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _repository.login(email: email, password: password);

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
