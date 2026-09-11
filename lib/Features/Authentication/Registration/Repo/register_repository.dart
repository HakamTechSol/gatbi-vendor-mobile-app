import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/register_model.dart';

class RegisterRepository {
  const RegisterRepository(this._dioClient);

  final DioClient _dioClient;

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
    final model = RegisterModel(
      storeName: storeName.trim(),
      businessType: businessType.trim(),
      email: email.trim(),
      phoneFull: phoneFull.trim(),
      phoneCountry: phoneCountry.trim(),
      address: address.trim(),
      categoryId: categoryId,
      about: about.trim(),
      tradeLicenseNumber: tradeLicenseNumber?.trim(),
      password: password,
      passwordConfirmation: passwordConfirmation,
      termsAgreed: termsAgreed,
    );

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.register,
      data: model.toJson(),
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = RegisterModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== REGISTER RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('MERCHANT ID: ${result.data?.merchantId}');
      debugPrint('EMAIL: ${result.data?.email}');
      debugPrint('STATUS: ${result.data?.status}');
      debugPrint('=====================================');
      debugPrint('');
    }

    return result;
  }
}
