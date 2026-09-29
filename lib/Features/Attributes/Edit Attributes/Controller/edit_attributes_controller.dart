import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/edit_attributes_model.dart';
import '../Repo/edit_attributes_repository.dart';

// ============================================================
// Edit Attributes Provider
// ============================================================

final editAttributesControllerProvider = Provider<EditAttributesController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return EditAttributesController(dioClient: dioClient);
});

// ============================================================
// Edit Attributes Controller
// ============================================================

class EditAttributesController {
  EditAttributesController({required DioClient dioClient})
    : _repository = EditAttributesRepository(dioClient);

  final EditAttributesRepository _repository;

  // ==========================================================
  // Edit Attribute
  // ==========================================================

  Future<EditAttributesModel> editAttribute({
    required int id,
    required String name,
    required String inputType,
    required String isActive,
  }) async {
    try {
      final result = await _repository.editAttribute(
        id: id,
        name: name,
        inputType: inputType,
        isActive: isActive,
      );

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
