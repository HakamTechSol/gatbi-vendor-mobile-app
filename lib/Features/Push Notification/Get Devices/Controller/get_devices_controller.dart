import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_devices_model.dart';
import '../Repo/get_devices_repository.dart';

// ============================================================
// Get Devices Provider
// ============================================================

final getDevicesControllerProvider = Provider<GetDevicesController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return GetDevicesController(dioClient: dioClient);
});

// ============================================================
// Get Devices Controller
// ============================================================

class GetDevicesController {
  GetDevicesController({required DioClient dioClient})
    : _repository = GetDevicesRepository(dioClient);

  final GetDevicesRepository _repository;

  // ==========================================================
  // Get Devices
  // ==========================================================

  Future<GetDevicesModel> getDevices() async {
    try {
      final result = await _repository.getDevices();

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
