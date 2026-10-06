import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/device_unregistered_model.dart';

class DeviceUnregisteredRepository {
  const DeviceUnregisteredRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Unregister Device
  // ============================================================

  Future<DeviceUnregisteredModel> unregisterDevice({
    required String token,
  }) async {
    // ----------------------------------------------------------
    // Request Body
    // ----------------------------------------------------------

    final Map<String, dynamic> requestBody = {'token': token};

    // ----------------------------------------------------------
    // Debug Request Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== UNREGISTER DEVICE REQUEST ==========');
      debugPrint('ENDPOINT: ${ApiUrls.unregisterDevice}');
      debugPrint('');
      debugPrint('TOKEN: $token');
      debugPrint('');
      debugPrint('REQUEST BODY: $requestBody');
      debugPrint('===============================================');
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Call
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.unregisterDevice,
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

    final result = DeviceUnregisteredModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Response Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== UNREGISTER DEVICE RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Additional Data
      // --------------------------------------------------------

      debugPrint('UNREAD COUNT: ${result.unreadCount ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==============================================');
      debugPrint('');
    }

    return result;
  }
}
