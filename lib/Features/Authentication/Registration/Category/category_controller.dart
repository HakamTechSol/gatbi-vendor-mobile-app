import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import 'category_model.dart';
import 'category_repo.dart';

// ============================================================
// Category Provider
// ============================================================

final categoryControllerProvider = Provider<CategoryController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CategoryController(dioClient: dioClient);
});

// ============================================================
// Category Controller
// ============================================================

class CategoryController {
  CategoryController({required DioClient dioClient})
    : _repository = CategoryRepository(dioClient);

  final CategoryRepository _repository;

  // ==========================================================
  // Get Categories
  // ==========================================================

  Future<CategoryModel> getCategories({bool includeChildren = true}) async {
    try {
      final result = await _repository.getCategories(
        includeChildren: includeChildren,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
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
