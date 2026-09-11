import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import 'business_type_model.dart';
import 'business_type_repository.dart';

// ============================================================
// Business Type Provider
// ============================================================

final businessTypeControllerProvider = Provider<BusinessTypeController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return BusinessTypeController(dioClient: dioClient);
});

// ============================================================
// Business Type Controller
// ============================================================

class BusinessTypeController {
  BusinessTypeController({required DioClient dioClient})
    : _repository = BusinessTypeRepository(dioClient);

  final BusinessTypeRepository _repository;

  // ==========================================================
  // Get Business Types
  // ==========================================================

  Future<BusinessTypeModel> getBusinessTypes() async {
    try {
      final result = await _repository.getBusinessTypes();

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
