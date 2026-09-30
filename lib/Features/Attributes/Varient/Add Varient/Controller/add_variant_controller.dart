import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/add_variant_model.dart';
import '../Repo/add_variant_repo.dart';


// ============================================================
// Add Variant Provider
// ============================================================

final addVariantControllerProvider = Provider<AddVariantController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return AddVariantController(dioClient: dioClient);
});

// ============================================================
// Add Variant Controller
// ============================================================

class AddVariantController {
  AddVariantController({required DioClient dioClient})
    : _repository = AddVariantRepository(dioClient);

  final AddVariantRepository _repository;

  // ==========================================================
  // Add Variant
  // ==========================================================

  Future<AddVariantModel> addVariant({
    required int attributeId,
    required String value,
    String? code,
    int? sortOrder,
    required String isActive,
  }) async {
    try {
      final result = await _repository.addVariant(
        attributeId: attributeId,
        value: value,
        code: code,
        sortOrder: sortOrder,
        isActive: isActive,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak
      // jane dein.
      //
      // Is se statusCode, code aur validation/error
      // details preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException
      // mein convert kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
