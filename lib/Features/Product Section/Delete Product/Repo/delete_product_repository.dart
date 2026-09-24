import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/delete_product_model.dart';

class DeleteProductRepository {
  const DeleteProductRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Delete Product
  // ============================================================

  Future<DeleteProductModel> deleteProduct({required int productId}) async {
    // ----------------------------------------------------------
    // Build Endpoint
    // ----------------------------------------------------------

    final endpoint = ApiUrls.deleteProduct(productId);

    // ----------------------------------------------------------
    // POST Request
    // Backend uses POST /vendor/products/{id}/delete
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(endpoint);

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
    // Convert API Response -> Delete Product Model
    // ----------------------------------------------------------

    final result = DeleteProductModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== DELETE PRODUCT RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('METHOD: POST');
      debugPrint('PRODUCT ID: $productId');
      debugPrint('ENDPOINT: $endpoint');

      // --------------------------------------------------------
      // Response
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('===========================================');
      debugPrint('');
    }

    return result;
  }
}
