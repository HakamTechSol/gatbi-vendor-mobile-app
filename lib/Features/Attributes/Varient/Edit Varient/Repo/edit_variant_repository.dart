import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/edit_variant_model.dart';

class EditVariantRepository {
  const EditVariantRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Edit Variant
  // ============================================================

  Future<EditVariantModel> editVariant({
    required int valueId,
    required String value,
    String? code,
    int? sortOrder,
    required String isActive,
  }) async {
    final response =
        await _dioClient.post<Map<String, dynamic>>(
      '${ApiUrls.vendorAttributeValues}/$valueId/update',
      data: {
        'value': value,
        'code': code,
        'sort_order': sortOrder,
        'is_active': isActive,
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
    // Convert API Response -> Edit Variant Model
    // ----------------------------------------------------------

    final result = EditVariantModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final variant = result.value;

      debugPrint('');
      debugPrint('========== EDIT VARIANT RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      debugPrint('');
      debugPrint('---------- VARIANT VALUE ----------');
      debugPrint('VALUE ID: ${variant?.id ?? 'N/A'}');
      debugPrint(
        'ATTRIBUTE ID: ${variant?.attributeId ?? 'N/A'}',
      );
      debugPrint('VALUE: ${variant?.value ?? 'N/A'}');
      debugPrint('CODE: ${variant?.code ?? 'N/A'}');
      debugPrint(
        'SORT ORDER: ${variant?.sortOrder ?? 'N/A'}',
      );
      debugPrint(
        'IS ACTIVE: ${variant?.isActive ?? false}',
      );
      debugPrint(
        'CREATED AT: ${variant?.createdAt ?? 'N/A'}',
      );
      debugPrint(
        'UPDATED AT: ${variant?.updatedAt ?? 'N/A'}',
      );

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('');
    }

    return result;
  }
}