import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/device_registered_model.dart';
import '../Repo/device_registered_repository.dart';

// ============================================================
// Device Registered Provider
// ============================================================

final deviceRegisteredControllerProvider = Provider<DeviceRegisteredController>(
  (ref) {
    final dioClient = ref.watch(dioProvider);

    return DeviceRegisteredController(dioClient: dioClient);
  },
);

// ============================================================
// Device Registered Controller
// ============================================================

class DeviceRegisteredController {
  DeviceRegisteredController({required DioClient dioClient})
    : _repository = DeviceRegisteredRepository(dioClient);

  final DeviceRegisteredRepository _repository;

  // ==========================================================
  // Register Device
  // ==========================================================

  Future<DeviceRegisteredModel> registerDevice({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
  }) async {
    try {
      final result = await _repository.registerDevice(
        token: token,
        platform: platform,
        deviceId: deviceId,
        appVersion: appVersion,
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
