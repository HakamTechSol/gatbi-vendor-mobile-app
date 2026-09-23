import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Model/product_detail_model.dart';
import '../Repo/product_detail_repository.dart';

// ============================================================
// Product Detail Provider
// ============================================================

final productDetailControllerProvider =
    Provider<ProductDetailController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return ProductDetailController(
    dioClient: dioClient,
  );
});

// ============================================================
// Product Detail Controller
// ============================================================

class ProductDetailController {
  ProductDetailController({
    required DioClient dioClient,
  }) : _repository = ProductDetailRepository(dioClient);

  final ProductDetailRepository _repository;

  // ==========================================================
  // Get Product Detail
  // ==========================================================

  Future<ProductDetailModel> getProductDetail({
    required int productId,
  }) async {
    try {
      final result = await _repository.getProductDetail(
        productId: productId,
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