import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/dio.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/product_option_model.dart';
import '../Repo/product_option_repository.dart';

// ============================================================
// Product Option Provider
// ============================================================

final productOptionControllerProvider = Provider<ProductOptionController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return ProductOptionController(dioClient: dioClient);
});

// ============================================================
// Product Option Controller
// ============================================================

class ProductOptionController {
  ProductOptionController({required DioClient dioClient})
    : _repository = ProductOptionRepository(dioClient);

  final ProductOptionRepository _repository;

  // ==========================================================
  // Get Product Options
  // ==========================================================

  Future<ProductOptionModel> getProductOptions() async {
    try {
      final result = await _repository.getProductOptions();

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
