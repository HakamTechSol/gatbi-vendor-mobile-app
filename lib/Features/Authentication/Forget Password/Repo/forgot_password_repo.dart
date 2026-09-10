import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/forgot_password_model.dart';

class ForgotPasswordRepository {
  const ForgotPasswordRepository(this._dioClient);

  final DioClient _dioClient;

  Future<ForgotPasswordModel> forgotPassword({required String email}) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.forgotPassword,
      data: {'email': email.trim()},
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = ForgotPasswordModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== FORGOT PASSWORD RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}
