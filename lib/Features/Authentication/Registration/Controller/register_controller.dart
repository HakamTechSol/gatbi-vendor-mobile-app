import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../Models/register_model.dart';
import '../Repo/register_repository.dart';

class RegisterController {
  RegisterController({required DioClient dioClient})
    : _repository = RegisterRepository(dioClient);

  final RegisterRepository _repository;

  Future<RegisterModel> register({
    required String businessName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      final result = await _repository.register(
        businessName: businessName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

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
