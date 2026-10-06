import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_devices_model.dart';

class GetDevicesRepository {
  const GetDevicesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Devices
  // ============================================================

  Future<GetDevicesModel> getDevices() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.getDevices,
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
    // Convert API Response -> Get Devices Model
    // ----------------------------------------------------------

    final result = GetDevicesModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== GET DEVICES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Devices
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- DEVICES ----------');
      debugPrint('DEVICES COUNT: ${result.devices.length}');

      if (result.devices.isNotEmpty) {
        for (final device in result.devices) {
          debugPrint('');
          debugPrint('DEVICE ID: ${device.id ?? 'N/A'}');
          debugPrint('USER ID: ${device.userId ?? 'N/A'}');
          debugPrint('PLATFORM: ${device.platform ?? 'N/A'}');
          debugPrint(
            'DEVICE IDENTIFIER: '
            '${device.deviceId ?? 'N/A'}',
          );
          debugPrint('TOKEN: ${device.token ?? 'N/A'}');
          debugPrint(
            'APP VERSION: '
            '${device.appVersion ?? 'N/A'}',
          );
          debugPrint(
            'LAST SEEN AT: '
            '${device.lastSeenAt ?? 'N/A'}',
          );
          debugPrint(
            'CREATED AT: '
            '${device.createdAt ?? 'N/A'}',
          );
          debugPrint(
            'UPDATED AT: '
            '${device.updatedAt ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('========================================');
      debugPrint('');
    }

    return result;
  }
}
