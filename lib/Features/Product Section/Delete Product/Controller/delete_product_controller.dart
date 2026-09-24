import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/delete_product_model.dart';
import '../Repo/delete_product_repository.dart';

// ============================================================
// Delete Product Provider
// ============================================================

final deleteProductControllerProvider = Provider<DeleteProductController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return DeleteProductController(dioClient: dioClient);
});

// ============================================================
// Delete Product Controller
// ============================================================

class DeleteProductController {
  DeleteProductController({required DioClient dioClient})
    : _repository = DeleteProductRepository(dioClient);

  final DeleteProductRepository _repository;

  // ==========================================================
  // Delete Product
  // ==========================================================

  Future<DeleteProductModel> deleteProduct({required int productId}) async {
    try {
      final result = await _repository.deleteProduct(productId: productId);

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
