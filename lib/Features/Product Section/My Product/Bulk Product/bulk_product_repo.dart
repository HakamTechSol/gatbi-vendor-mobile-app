import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import 'bulk_product_model.dart';

class BulkProductRepository {
  const BulkProductRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Bulk Product Action
  // ============================================================

  Future<BulkProductModel> bulkProductAction({
    required String action,
    required List<int> productIds,
  }) async {
    // ============================================================
    // Validate Product IDs
    // ============================================================

    if (productIds.isEmpty) {
      throw const ApiException(
        message: 'Please select at least one product.',
        code: 'NO_PRODUCTS_SELECTED',
      );
    }

    // ============================================================
    // Validate Action
    // ============================================================

    const allowedActions = {'activate', 'deactivate', 'delete'};

    final normalizedAction = action.trim().toLowerCase();

    if (!allowedActions.contains(normalizedAction)) {
      throw const ApiException(
        message: 'Invalid bulk product action.',
        code: 'INVALID_ACTION',
      );
    }

    // ============================================================
    // Prepare FormData
    //
    // IMPORTANT:
    //
    // product_ids[] must be sent as separate fields:
    //
    // product_ids[] = 144
    // product_ids[] = 142
    //
    // NOT:
    //
    // product_ids[] = "144,142"
    // ============================================================

    final formData = FormData();

    formData.fields.add(MapEntry('action', normalizedAction));

    for (final productId in productIds) {
      formData.fields.add(MapEntry('product_ids[]', productId.toString()));
    }

    // ============================================================
    // Debug Request
    // ============================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== BULK PRODUCT REQUEST ==========');
      debugPrint('ACTION: $normalizedAction');
      debugPrint('PRODUCT IDS: $productIds');
      debugPrint('PRODUCT IDS COUNT: ${productIds.length}');

      debugPrint('FORM DATA FIELDS:');

      for (final field in formData.fields) {
        debugPrint('  ${field.key}: ${field.value}');
      }

      debugPrint('==========================================');
      debugPrint('');
    }

    // ============================================================
    // API Request
    // ============================================================

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.bulkProduct,
      data: formData,
    );

    final data = response.data;

    // ============================================================
    // Validate Response
    // ============================================================

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ============================================================
    // Parse Response
    // ============================================================

    final result = BulkProductModel.fromJson(data);

    // ============================================================
    // Debug Response
    // ============================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== BULK PRODUCT RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('SUCCESS COUNT: ${result.successCount}');
      debugPrint('FAILED COUNT: ${result.failedCount}');
      debugPrint('=========================================');
      debugPrint('');
    }

    return result;
  }
}
