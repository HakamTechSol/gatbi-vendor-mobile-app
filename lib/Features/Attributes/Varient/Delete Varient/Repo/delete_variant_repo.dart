import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/delete_variant_model.dart';

class DeleteVariantRepository {
  const DeleteVariantRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Delete Variant
  // ============================================================

  Future<DeleteVariantModel> deleteVariant({required int valueId}) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '${ApiUrls.vendorAttributeValues}/$valueId/delete',
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
    // Convert API Response -> Delete Variant Model
    // ----------------------------------------------------------

    final result = DeleteVariantModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== DELETE VARIANT RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

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
