import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/delete_attributes_model.dart';
import '../Repo/delete_attributes_repository.dart';

// ============================================================
// Delete Attributes Provider
// ============================================================

final deleteAttributesControllerProvider = Provider<DeleteAttributesController>(
  (ref) {
    final dioClient = ref.watch(dioProvider);

    return DeleteAttributesController(dioClient: dioClient);
  },
);

// ============================================================
// Delete Attributes Controller
// ============================================================

class DeleteAttributesController {
  DeleteAttributesController({required DioClient dioClient})
    : _repository = DeleteAttributesRepository(dioClient);

  final DeleteAttributesRepository _repository;

  // ==========================================================
  // Delete Attribute
  // ==========================================================

  Future<DeleteAttributesModel> deleteAttribute({required int id}) async {
    try {
      final result = await _repository.deleteAttribute(id: id);

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
