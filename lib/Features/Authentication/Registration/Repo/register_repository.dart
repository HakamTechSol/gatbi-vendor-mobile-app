import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/register_model.dart';

class RegisterRepository {
  const RegisterRepository(this._dioClient);

  final DioClient _dioClient;

  Future<RegisterModel> register({
    required String businessName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final model = RegisterModel(
      businessName: businessName.trim(),
      email: email.trim(),
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone?.trim(),
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
      debugPrint('MERCHANT ID: ${result.merchantId}');
      debugPrint('REQUIRES OTP: ${result.requiresOtp}');
      debugPrint('=====================================');
      debugPrint('');
    }

    return result;
  }
}
