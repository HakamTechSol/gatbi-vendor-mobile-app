import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/get_edit_product_model.dart';
import '../Repo/get_edit_product_repo.dart';

// ============================================================
// Get Edit Product Provider
// ============================================================

final getEditProductControllerProvider = Provider<GetEditProductController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return GetEditProductController(dioClient: dioClient);
});

// ============================================================
// Get Edit Product Controller
// ============================================================

class GetEditProductController {
  GetEditProductController({required DioClient dioClient})
    : _repository = GetEditProductRepository(dioClient);

  final GetEditProductRepository _repository;

  // ==========================================================
  // Get Edit Product
  // ==========================================================

  Future<GetEditProductModel> getEditProduct(int productId) async {
    try {
      final result = await _repository.getEditProduct(productId);

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
