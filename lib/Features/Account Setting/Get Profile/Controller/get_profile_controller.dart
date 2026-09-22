import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_profile_model.dart';
import '../Repo/get_profile_repo.dart';

// ============================================================
// Vendor Settings Provider
// ============================================================

final vendorSettingsControllerProvider =
    Provider<VendorSettingsController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return VendorSettingsController(
    dioClient: dioClient,
  );
});

// ============================================================
// Vendor Settings Controller
// ============================================================

class VendorSettingsController {
  VendorSettingsController({
    required DioClient dioClient,
  }) : _repository = VendorSettingsRepository(dioClient);

  final VendorSettingsRepository _repository;

  // ==========================================================
  // Get Vendor Settings
  // ==========================================================

  Future<VendorSettingsModel> getVendorSettings() async {
    try {
      final result = await _repository.getVendorSettings();

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
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