import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import 'product_arabic_translation_model.dart';
import 'product_arabic_translation_repository.dart';

// ============================================================
// PRODUCT ARABIC TRANSLATOR PROVIDER
// ============================================================

final productArabicTranslatorControllerProvider =
    Provider<ProductArabicTranslatorController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return ProductArabicTranslatorController(
    dioClient: dioClient,
  );
});

// ============================================================
// PRODUCT ARABIC TRANSLATOR CONTROLLER
// ============================================================

class ProductArabicTranslatorController {
  ProductArabicTranslatorController({
    required DioClient dioClient,
  }) : _repository = ProductArabicTranslatorRepository(
          dioClient,
        );

  final ProductArabicTranslatorRepository _repository;

  // ==========================================================
  // TRANSLATE PRODUCT
  // ==========================================================

  Future<ProductArabicTranslatorModel> translateProduct({
    required String name,
    required String shortDescription,
    required String description,
    required String metaTitle,
    required String metaKeywords,
    required String metaDescription,
    required String sourceLocale,
    required String targetLocale,
  }) async {
    try {
      final result = await _repository.translateProduct(
        name: name,
        shortDescription: shortDescription,
        description: description,
        metaTitle: metaTitle,
        metaKeywords: metaKeywords,
        metaDescription: metaDescription,
        sourceLocale: sourceLocale,
        targetLocale: targetLocale,
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