import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/edit_variant_model.dart';
import '../Repo/edit_variant_repository.dart';

// ============================================================
// Edit Variant Provider
// ============================================================

final editVariantControllerProvider = Provider<EditVariantController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return EditVariantController(dioClient: dioClient);
});

// ============================================================
// Edit Variant Controller
// ============================================================

class EditVariantController {
  EditVariantController({required DioClient dioClient})
    : _repository = EditVariantRepository(dioClient);

  final EditVariantRepository _repository;

  // ==========================================================
  // Edit Variant
  // ==========================================================

  Future<EditVariantModel> editVariant({
    required int valueId,
    required String value,
    String? code,
    int? sortOrder,
    required String isActive,
  }) async {
    try {
      final result = await _repository.editVariant(
        valueId: valueId,
        value: value,
        code: code,
        sortOrder: sortOrder,
        isActive: isActive,
      );

      return result;
    } on ApiException {
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
