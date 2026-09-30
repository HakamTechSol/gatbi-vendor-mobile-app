import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/add_variant_model.dart';

class AddVariantRepository {
  const AddVariantRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Add Variant
  // ============================================================

  Future<AddVariantModel> addVariant({
    required int attributeId,
    required String value,
    String? code,
    int? sortOrder,
    required String isActive,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '${ApiUrls.vendorAttributes}/$attributeId/values',
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
    // Convert API Response -> Add Variant Model
    // ----------------------------------------------------------

    final result = AddVariantModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final variant = result.value;

      debugPrint('');
      debugPrint('========== ADD VARIANT RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Variant Value
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- VARIANT VALUE ----------');
      debugPrint('VALUE ID: ${variant?.id ?? 'N/A'}');
      debugPrint(
        'ATTRIBUTE ID: '
        '${variant?.attributeId ?? 'N/A'}',
      );
      debugPrint('VALUE: ${variant?.value ?? 'N/A'}');
      debugPrint('CODE: ${variant?.code ?? 'N/A'}');
      debugPrint('SORT ORDER: ${variant?.sortOrder ?? 'N/A'}');
      debugPrint('IS ACTIVE: ${variant?.isActive ?? false}');
      debugPrint(
        'CREATED AT: '
        '${variant?.createdAt ?? 'N/A'}',
      );
      debugPrint(
        'UPDATED AT: '
        '${variant?.updatedAt ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=========================================');
      debugPrint('');
    }

    return result;
  }
}
