import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import 'bulk_product_model.dart';
import 'bulk_product_repo.dart';

// ============================================================
// Bulk Product Provider
// ============================================================

final bulkProductControllerProvider = Provider<BulkProductController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return BulkProductController(dioClient: dioClient);
});

// ============================================================
// Bulk Product Controller
// ============================================================

class BulkProductController {
  BulkProductController({required DioClient dioClient})
    : _repository = BulkProductRepository(dioClient);

  final BulkProductRepository _repository;

  // ==========================================================
  // Bulk Product Action
  // ==========================================================

  Future<BulkProductModel> bulkProductAction({
    required String action,
    required List<int> productIds,
  }) async {
    try {
      final result = await _repository.bulkProductAction(
        action: action,
        productIds: productIds,
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
