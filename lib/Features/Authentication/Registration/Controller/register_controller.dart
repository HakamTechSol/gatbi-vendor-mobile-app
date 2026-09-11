import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../Models/register_model.dart';
import '../Repo/register_repository.dart';

class RegisterController {
  RegisterController({required DioClient dioClient})
    : _repository = RegisterRepository(dioClient);

  final RegisterRepository _repository;

  // ============================================================
  // REGISTER
  // ============================================================

  Future<RegisterModel> register({
    required String storeName,
    required String businessType,
    required String email,
    required String phoneFull,
    required String phoneCountry,
    required String address,
    required int categoryId,
    required String about,
    String? tradeLicenseNumber,
    required String password,
    required String passwordConfirmation,
    required String termsAgreed,
  }) async {
    try {
      final result = await _repository.register(
        storeName: storeName,
        businessType: businessType,
        email: email,
        phoneFull: phoneFull,
        phoneCountry: phoneCountry,
        address: address,
        categoryId: categoryId,
        about: about,
        tradeLicenseNumber: tradeLicenseNumber,
        password: password,
        passwordConfirmation: passwordConfirmation,
        termsAgreed: termsAgreed,
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
