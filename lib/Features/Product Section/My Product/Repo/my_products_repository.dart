import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/main_my_products_model.dart';

class MyProductsRepository {
  const MyProductsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get My Products
  // ============================================================

  Future<MainMyProductModel> getMyProducts({
    int page = 1,
    int limit = 20,
  }) async {
    // ----------------------------------------------------------
    // Protect API pagination limits
    // ----------------------------------------------------------

    final safePage = page < 1 ? 1 : page;
    final safeLimit = limit.clamp(1, 100);

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.products,
      queryParameters: {
        'page': safePage,
        'limit': safeLimit,
      },
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = MainMyProductModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== MY PRODUCTS RESULT ==========');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('');
      debugPrint('---------- PAGINATION ----------');

      debugPrint(
        'CURRENT PAGE: ${result.pagination.currentPage}',
      );

      debugPrint(
        'TOTAL PAGES: ${result.pagination.totalPages}',
      );

      debugPrint(
        'TOTAL ITEMS: ${result.pagination.totalItems}',
      );

      debugPrint(
        'LIMIT: ${result.pagination.limit}',
      );

      debugPrint(
        'HAS NEXT PAGE: ${result.pagination.hasNextPage}',
      );

      debugPrint(
        'HAS PREVIOUS PAGE: '
        '${result.pagination.hasPreviousPage}',
      );

      debugPrint('');
      debugPrint('---------- PRODUCTS ----------');

      debugPrint(
        'PRODUCTS COUNT: ${result.products.length}',
      );

      for (final product in result.products) {
        debugPrint(
          'PRODUCT: '
          '${product.name ?? 'N/A'} | '
          'ID: ${product.id ?? 'N/A'} | '
          'PRICE: ${product.price ?? 0} '
          '${product.currency ?? ''} | '
          'STOCK: ${product.stockQuantity ?? 0} | '
          'STATUS: ${product.stockStatus ?? 'N/A'} | '
          'VARIANTS: ${product.variants.length} | '
          'ACTIVE: ${product.isActive}',
        );
      }

      debugPrint('');
      debugPrint('========================================');
      debugPrint('');
    }

    return result;
  }
}