import 'package:flutter/foundation.dart';
import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/product_option_model.dart';

class ProductOptionRepository {
  const ProductOptionRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Product Options
  // ============================================================

  Future<ProductOptionModel> getProductOptions() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.productOptions,
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> ProductOption Model
    // ----------------------------------------------------------

    final result = ProductOptionModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== PRODUCT OPTIONS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Categories
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CATEGORIES ----------');
      debugPrint('CATEGORIES COUNT: ${result.categories.length}');

      if (result.categories.isNotEmpty) {
        for (final category in result.categories) {
          debugPrint(
            'CATEGORY: '
            'ID: ${category.id ?? 'N/A'} | '
            'NAME: ${category.name ?? 'N/A'} | '
            'SLUG: ${category.slug ?? 'N/A'} | '
            'PARENT ID: ${category.parentId ?? 'N/A'} | '
            'PRODUCT COUNT: ${category.productCount ?? 0} | '
            'IMAGE: ${category.image ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // Brands
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- BRANDS ----------');
      debugPrint('BRANDS COUNT: ${result.brands.length}');

      if (result.brands.isNotEmpty) {
        for (final brand in result.brands) {
          debugPrint(
            'BRAND: '
            'ID: ${brand.id ?? 'N/A'} | '
            'NAME: ${brand.name ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}
