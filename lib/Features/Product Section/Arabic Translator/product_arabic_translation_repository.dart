import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import 'product_arabic_translation_model.dart';

class ProductArabicTranslatorRepository {
  const ProductArabicTranslatorRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // TRANSLATE PRODUCT
  // ============================================================

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
    // ============================================================
    // REQUEST BODY
    // ============================================================

    final requestBody = <String, dynamic>{
      'name': name,
      'short_description': shortDescription,
      'description': description,
      'meta_title': metaTitle,
      'meta_keywords': metaKeywords,
      'meta_description': metaDescription,
      'source_locale': sourceLocale,
      'target_locale': targetLocale,
    };

    // ============================================================
    // DEBUG REQUEST LOG
    // ============================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== PRODUCT ARABIC TRANSLATOR REQUEST ==========');

      debugPrint('METHOD: POST');

      debugPrint('ENDPOINT: ${ApiUrls.translateProduct}');

      debugPrint('SOURCE LOCALE: $sourceLocale');

      debugPrint('TARGET LOCALE: $targetLocale');

      debugPrint('NAME: $name');

      debugPrint('SHORT DESCRIPTION: $shortDescription');

      debugPrint('DESCRIPTION: $description');

      debugPrint('META TITLE: $metaTitle');

      debugPrint('META KEYWORDS: $metaKeywords');

      debugPrint('META DESCRIPTION: $metaDescription');

      debugPrint('REQUEST BODY: $requestBody');

      debugPrint('========================================================');
      debugPrint('');
    }

    // ============================================================
    // API REQUEST
    // ============================================================

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.translateProduct,
      data: requestBody,
    );

    final data = response.data;

    // ============================================================
    // VALIDATE RESPONSE
    // ============================================================

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ============================================================
    // CONVERT RESPONSE -> MODEL
    // ============================================================

    final result = ProductArabicTranslatorModel.fromJson(data);

    // ============================================================
    // DEBUG RESPONSE LOG
    // ============================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== PRODUCT ARABIC TRANSLATOR RESULT ==========');

      debugPrint('HTTP STATUS: ${response.statusCode}');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message}');

      final translation = result.translation;

      if (translation == null) {
        debugPrint('TRANSLATION: null');
      } else {
        debugPrint('PRODUCT ID: ${translation.productId}');

        debugPrint('SOURCE LOCALE: ${translation.sourceLocale}');

        debugPrint('TARGET LOCALE: ${translation.targetLocale}');

        final translated = translation.translated;

        if (translated == null) {
          debugPrint('TRANSLATED: null');
        } else {
          debugPrint('TRANSLATED NAME: ${translated.name}');

          debugPrint(
            'TRANSLATED SHORT DESCRIPTION: '
            '${translated.shortDescription}',
          );

          debugPrint(
            'TRANSLATED DESCRIPTION: '
            '${translated.description}',
          );

          debugPrint(
            'TRANSLATED META TITLE: '
            '${translated.metaTitle}',
          );

          debugPrint(
            'TRANSLATED META DESCRIPTION: '
            '${translated.metaDescription}',
          );

          debugPrint(
            'TRANSLATED META KEYWORDS: '
            '${translated.metaKeywords}',
          );
        }
      }

      debugPrint('======================================================');

      debugPrint('');
    }

    // ============================================================
    // RETURN
    // ============================================================

    return result;
  }
}
