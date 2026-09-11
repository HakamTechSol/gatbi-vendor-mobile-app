import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import 'settings_model.dart';
import 'settings_repo.dart';

// ============================================================
// Settings Provider
// ============================================================

final settingsControllerProvider = Provider<SettingsController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return SettingsController(dioClient: dioClient);
});

// ============================================================
// Settings Controller
// ============================================================

class SettingsController {
  SettingsController({required DioClient dioClient})
    : _repository = SettingsRepository(dioClient);

  final SettingsRepository _repository;

  // ==========================================================
  // Get Settings
  // ==========================================================

  Future<SettingsModel> getSettings() async {
    try {
      final result = await _repository.getSettings();

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur errors preserve rehte hain.
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
