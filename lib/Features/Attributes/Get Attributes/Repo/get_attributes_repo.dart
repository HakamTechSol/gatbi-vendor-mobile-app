import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/get_attributes_model.dart';
class GetAttributesRepository {
  const GetAttributesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Attributes
  // ============================================================

  Future<GetAttributesModel> getAttributes() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.vendorAttributes,
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
    // Convert API Response -> Get Attributes Model
    // ----------------------------------------------------------

    final result = GetAttributesModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== GET ATTRIBUTES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Attributes
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ATTRIBUTES ----------');
      debugPrint('ATTRIBUTES COUNT: ${result.attributes.length}');

      for (final attribute in result.attributes) {
        debugPrint('');
        debugPrint(
          'ATTRIBUTE: '
          '${attribute.name ?? 'N/A'} | '
          'ID: ${attribute.id ?? 'N/A'} | '
          'ADMIN LABEL: ${attribute.adminLabel ?? 'N/A'} | '
          'SLUG: ${attribute.slug ?? 'N/A'} | '
          'INPUT TYPE: ${attribute.inputType ?? 'N/A'} | '
          'IS OWN: ${attribute.isOwn} | '
          'VALUES: ${attribute.values.length}',
        );

        // ------------------------------------------------------
        // Attribute Values
        // ------------------------------------------------------

        if (attribute.values.isNotEmpty) {
          debugPrint('  ---------- VALUES ----------');

          for (final value in attribute.values) {
            debugPrint(
              '  VALUE: '
              '${value.value ?? 'N/A'} | '
              'ID: ${value.id ?? 'N/A'} | '
              'CODE: ${value.code ?? 'N/A'} | '
              'SORT ORDER: ${value.sortOrder ?? 0}',
            );
          }
        }
      }

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
