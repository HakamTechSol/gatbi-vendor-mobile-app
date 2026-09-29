import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/add_attributes_model.dart';
import '../Repo/add_attributes_repo.dart';

// ============================================================
// Add Attributes Provider
// ============================================================

final addAttributesControllerProvider = Provider<AddAttributesController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return AddAttributesController(dioClient: dioClient);
});

// ============================================================
// Add Attributes Controller
// ============================================================

class AddAttributesController {
  AddAttributesController({required DioClient dioClient})
    : _repository = AddAttributesRepository(dioClient);

  final AddAttributesRepository _repository;

  // ==========================================================
  // Add Attribute
  // ==========================================================

  Future<AddAttributesModel> addAttribute({
    required String name,
    required String inputType,
    required String slug,
    required String isActive,
  }) async {
    try {
      final result = await _repository.addAttribute(
        name: name,
        inputType: inputType,
        slug: slug,
        isActive: isActive,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
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
