import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/add_stock_product_model.dart';

class AddStockProductRepository {
  const AddStockProductRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Add / Update Stock Product
  // ============================================================

  Future<AddStockProductModel> addStockProduct({
    required int productId,
    required int stockQty,
    required String inStock,
    required int lowStockThreshold,
  }) async {
    // ----------------------------------------------------------
    // Request Body
    // ----------------------------------------------------------

    final requestData = {
      'stock_qty': stockQty,
      'in_stock': inStock,
      'low_stock_threshold': lowStockThreshold,
    };

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== ADD STOCK PRODUCT REQUEST ==========');
      debugPrint('PRODUCT ID: $productId');
      debugPrint('STOCK QTY: $stockQty');
      debugPrint('IN STOCK: $inStock');
      debugPrint('LOW STOCK THRESHOLD: $lowStockThreshold');
      debugPrint('REQUEST BODY: $requestData');
      debugPrint('===============================================');
    }

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.updateStock(productId),
      data: requestData,
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

    final result = AddStockProductModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final product = result.product;

      debugPrint('');
      debugPrint('========== ADD STOCK PRODUCT RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Product
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRODUCT ----------');
      debugPrint('PRODUCT ID: ${product?.id ?? 'N/A'}');
      debugPrint('PRODUCT NAME: ${product?.name ?? 'N/A'}');
      debugPrint('STOCK QUANTITY: ${product?.stockQuantity ?? 0}');
      debugPrint('STOCK STATUS: ${product?.stockStatus ?? 'N/A'}');
      debugPrint('IS ACTIVE: ${product?.isActive ?? false}');

      debugPrint('');
      debugPrint('=============================================');
      debugPrint('');
    }

    return result;
  }
}
