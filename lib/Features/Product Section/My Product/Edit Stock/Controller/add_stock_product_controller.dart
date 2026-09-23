import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/add_stock_product_model.dart';
import '../Repo/add_stock_product_repository.dart';

// ============================================================
// Add Stock Product Provider
// ============================================================

final addStockProductControllerProvider = Provider<AddStockProductController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return AddStockProductController(dioClient: dioClient);
});

// ============================================================
// Add Stock Product Controller
// ============================================================

class AddStockProductController {
  AddStockProductController({required DioClient dioClient})
    : _repository = AddStockProductRepository(dioClient);

  final AddStockProductRepository _repository;

  // ==========================================================
  // Add / Update Stock Product
  // ==========================================================

  Future<AddStockProductModel> addStockProduct({
    required int productId,
    required int stockQty,
    required String inStock,
    required int lowStockThreshold,
  }) async {
    try {
      final result = await _repository.addStockProduct(
        productId: productId,
        stockQty: stockQty,
        inStock: inStock,
        lowStockThreshold: lowStockThreshold,
      );

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
