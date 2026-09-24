import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';

import '../Models/update_product_model.dart';
import '../Models/update_product_request_model.dart';
import '../Repo/update_product_repository.dart';

// ============================================================
// Update Product Provider
// ============================================================

final updateProductControllerProvider = Provider<UpdateProductController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return UpdateProductController(dioClient: dioClient);
});

// ============================================================
// Update Product Controller
// ============================================================

class UpdateProductController {
  UpdateProductController({required DioClient dioClient})
    : _repository = UpdateProductRepository(dioClient);

  final UpdateProductRepository _repository;

  // ==========================================================
  // Update Product
  // ==========================================================

  Future<UpdateProductModel> updateProduct({
    required int productId,
    required UpdateProductRequestModel request,
  }) async {
    try {
      final result = await _repository.updateProduct(
        productId: productId,
        request: request,
      );

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur original error details
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
