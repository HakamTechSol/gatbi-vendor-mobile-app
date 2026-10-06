import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/device_unregistered_model.dart';
import '../Repo/device_unregistered_repo.dart';

// ============================================================
// Device Unregistered Provider
// ============================================================

final deviceUnregisteredControllerProvider =
    Provider<DeviceUnregisteredController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return DeviceUnregisteredController(dioClient: dioClient);
    });

// ============================================================
// Device Unregistered Controller
// ============================================================

class DeviceUnregisteredController {
  DeviceUnregisteredController({required DioClient dioClient})
    : _repository = DeviceUnregisteredRepository(dioClient);

  final DeviceUnregisteredRepository _repository;

  // ==========================================================
  // Unregister Device
  // ==========================================================

  Future<DeviceUnregisteredModel> unregisterDevice({
    required String token,
  }) async {
    try {
      final result = await _repository.unregisterDevice(token: token);

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI/service tak jane dein.
      // Is se original error code/status details preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein convert
      // kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
