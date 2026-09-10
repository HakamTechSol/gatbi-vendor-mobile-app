import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/login_resend_otp_model.dart';
import '../Models/login_verify_otp_model.dart';

class OtpRepository {
  const OtpRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<VerifyOtpModel> verifyOtp({
    required int merchantId,
    required String otp,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.verifyOtp,
      data: {'merchant_id': merchantId, 'otp': otp.trim()},
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = VerifyOtpModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== VERIFY OTP RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('TOKEN RECEIVED: ${result.token != null}');
      debugPrint('MERCHANT ID: ${result.vendor?.merchantId}');
      debugPrint('USER ID: ${result.vendor?.userId}');
      debugPrint('VENDOR NAME: ${result.vendor?.name}');
      debugPrint('VENDOR EMAIL: ${result.vendor?.email}');
      debugPrint('VENDOR STATUS: ${result.vendor?.status}');
      debugPrint('KYC STATUS: ${result.vendor?.kycStatus}');
      debugPrint('=======================================');
      debugPrint('');
    }

    return result;
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<ResendOtpModel> resendOtp({required int merchantId}) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.resendOtp,
      data: {'merchant_id': merchantId},
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = ResendOtpModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== RESEND OTP RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('MERCHANT ID: ${result.merchantId}');
      debugPrint('EXPIRES IN MINUTES: ${result.expiresInMinutes}');
      debugPrint('=======================================');
      debugPrint('');
    }

    return result;
  }
}
