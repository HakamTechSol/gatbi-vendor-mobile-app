import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/delete_variant_model.dart';
import '../Repo/delete_variant_repo.dart';

// ============================================================
// Delete Variant Provider
// ============================================================

final deleteVariantControllerProvider = Provider<DeleteVariantController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return DeleteVariantController(dioClient: dioClient);
});

// ============================================================
// Delete Variant Controller
// ============================================================

class DeleteVariantController {
  DeleteVariantController({required DioClient dioClient})
    : _repository = DeleteVariantRepository(dioClient);

  final DeleteVariantRepository _repository;

  // ==========================================================
  // Delete Variant
  // ==========================================================

  Future<DeleteVariantModel> deleteVariant({required int valueId}) async {
    try {
      final result = await _repository.deleteVariant(valueId: valueId);

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
