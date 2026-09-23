import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Repo/get_attributes_repo.dart';
import '../Models/get_attributes_model.dart';

// ============================================================
// Get Attributes Provider
// ============================================================

final getAttributesControllerProvider = Provider<GetAttributesController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return GetAttributesController(dioClient: dioClient);
});

// ============================================================
// Get Attributes Controller
// ============================================================

class GetAttributesController {
  GetAttributesController({required DioClient dioClient})
    : _repository = GetAttributesRepository(dioClient);

  final GetAttributesRepository _repository;

  // ==========================================================
  // Get Attributes
  // ==========================================================

  Future<GetAttributesModel> getAttributes() async {
    try {
      final result = await _repository.getAttributes();

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
