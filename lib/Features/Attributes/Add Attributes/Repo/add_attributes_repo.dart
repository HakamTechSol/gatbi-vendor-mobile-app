import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/add_attributes_model.dart';

class AddAttributesRepository {
  const AddAttributesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Add Attribute
  // ============================================================

  Future<AddAttributesModel> addAttribute({
    required String name,
    required String inputType,
    required String slug,
    required String isActive,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.vendorAttributes,
      data: {
        'name': name,
        'input_type': inputType,
        'slug': slug,
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = AddAttributesModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final attribute = result.attribute;

      debugPrint('');
      debugPrint('========== ADD ATTRIBUTE RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Created Attribute
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ATTRIBUTE ----------');
      debugPrint('ATTRIBUTE ID: ${attribute?.id ?? 'N/A'}');
      debugPrint('NAME: ${attribute?.name ?? 'N/A'}');
      debugPrint('ADMIN LABEL: ${attribute?.adminLabel ?? 'N/A'}');
      debugPrint('SLUG: ${attribute?.slug ?? 'N/A'}');
      debugPrint('INPUT TYPE: ${attribute?.inputType ?? 'N/A'}');
      debugPrint('MERCHANT ID: ${attribute?.merchantId ?? 'N/A'}');
      debugPrint('IS ACTIVE: ${attribute?.isActive ?? false}');
      debugPrint('CREATED AT: ${attribute?.createdAt ?? 'N/A'}');
      debugPrint('UPDATED AT: ${attribute?.updatedAt ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('');
    }

    return result;
  }
}
