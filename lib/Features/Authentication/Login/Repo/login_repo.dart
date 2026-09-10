import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/login_model.dart';

class LoginRepository {
  const LoginRepository(this._dioClient);

  final DioClient _dioClient;

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.login,
      data: {'email': email.trim(), 'password': password},
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = LoginModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== LOGIN RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('REQUIRES OTP: ${result.requiresOtp}');
      debugPrint('MERCHANT ID: ${result.merchantId}');
      debugPrint('EXPIRES IN MINUTES: ${result.expiresInMinutes}');
      debugPrint('=================================');
      debugPrint('');
    }

    return result;
  }
}
