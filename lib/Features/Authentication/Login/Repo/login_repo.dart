import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/auth_session.dart';
import '../../../../Services/token_storage.dart'; 
import '../../../../Services/dio_client.dart';
import '../../../../Services/device_registration_helper.dart';
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

    // ============================================================
    // SAVE TOKEN (Direct login without OTP)
    // ============================================================
    if (result.token != null && result.token!.isNotEmpty) {
      // 1. Save token securely (SecureStorage use kiya hai taake restart par bhi rahe)
      await SecureStorageService.instance.saveToken(result.token!); // ✅ FIXED

      // 2. Update DioClient Authorization header for future requests
      _dioClient.updateAuthToken(result.token!);

      // 3. Mark user as authenticated so Splash/Routing knows
      AuthSession.instance.markAuthenticated(); // ✅ FIXED

      if (kDebugMode) {
        debugPrint('✅ Token securely saved for future requests.');
        debugPrint('✅ Auth Session: AUTHENTICATED');
      }

      // 4. REGISTER FCM DEVICE (Without OTP flow)
      await DeviceRegistrationHelper.registerDevice(dioClient: _dioClient);
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== LOGIN RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('REQUIRES OTP: ${result.requiresOtp}');
      debugPrint('MERCHANT ID: ${result.merchantId}');
      debugPrint('EXPIRES IN MINUTES: ${result.expiresInMinutes}');
      debugPrint('TOKEN: ${result.token != null ? '✔ present' : 'NULL'}');
      debugPrint('VENDOR: ${result.vendor?.name ?? 'NULL'}');
      debugPrint('=================================');
      debugPrint('');
    }

    return result;
  }
}
