import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/add_product_model.dart';
import '../Models/add_product_request_model.dart';
import '../Repo/add_product_repository.dart';

// ============================================================
// Add Product Provider
// ============================================================

final addProductControllerProvider =
    Provider<AddProductController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return AddProductController(
    dioClient: dioClient,
  );
});

// ============================================================
// Add Product Controller
// ============================================================

class AddProductController {
  AddProductController({
    required DioClient dioClient,
  }) : _repository = AddProductRepository(dioClient);

  final AddProductRepository _repository;

  // ==========================================================
  // Add Product
  // ==========================================================

  Future<AddProductModel> addProduct(
    AddProductRequestModel request,
  ) async {
    try {
      final result = await _repository.addProduct(request);

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se:
      // - statusCode
      // - code
      // - validation details
      // - server message
      //
      // preserve rehte hain.
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