import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/device_registered_model.dart';

class DeviceRegisteredRepository {
  const DeviceRegisteredRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Register Device
  // ============================================================

  Future<DeviceRegisteredModel> registerDevice({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
  }) async {
    // ----------------------------------------------------------
    // Request Body
    // ----------------------------------------------------------

    final Map<String, dynamic> requestBody = {
      'token': token,
      'platform': platform,
    };

    if (deviceId != null && deviceId.trim().isNotEmpty) {
      requestBody['device_id'] = deviceId;
    }

    if (appVersion != null && appVersion.trim().isNotEmpty) {
      requestBody['app_version'] = appVersion;
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== REGISTER DEVICE REQUEST ==========');
      debugPrint('ENDPOINT: ${ApiUrls.registerDevice}');
      debugPrint('');
      debugPrint('TOKEN: $token');
      debugPrint('PLATFORM: $platform');
      debugPrint('DEVICE ID: ${deviceId ?? 'N/A'}');
      debugPrint('APP VERSION: ${appVersion ?? 'N/A'}');
      debugPrint('');
      debugPrint('REQUEST BODY: $requestBody');
      debugPrint('=============================================');
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.registerDevice,
      data: requestBody,
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = DeviceRegisteredModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final device = result.device;

      debugPrint('');
      debugPrint('========== REGISTER DEVICE RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Device
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- DEVICE ----------');

      debugPrint('DEVICE ID: ${device?.id ?? 'N/A'}');

      debugPrint('TOKEN: ${device?.token ?? 'N/A'}');

      debugPrint('PLATFORM: ${device?.platform ?? 'N/A'}');

      debugPrint('DEVICE IDENTIFIER: ${device?.deviceId ?? 'N/A'}');

      debugPrint('APP VERSION: ${device?.appVersion ?? 'N/A'}');

      debugPrint('CREATED AT: ${device?.createdAt ?? 'N/A'}');

      debugPrint('UPDATED AT: ${device?.updatedAt ?? 'N/A'}');

      debugPrint('');
      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}
