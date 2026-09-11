import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import 'phone_rules_model.dart';
import 'phone_rules_repo.dart';

// ============================================================
// Phone Rules Provider
// ============================================================

final phoneRulesControllerProvider = Provider<PhoneRulesController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return PhoneRulesController(dioClient: dioClient);
});

// ============================================================
// Phone Rules Controller
// ============================================================

class PhoneRulesController {
  PhoneRulesController({required DioClient dioClient})
    : _repository = PhoneRulesRepository(dioClient);

  final PhoneRulesRepository _repository;

  // ==========================================================
  // Get Phone Rules
  // ==========================================================

  Future<PhoneRulesModel> getPhoneRules() async {
    try {
      final result = await _repository.getPhoneRules();

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
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
