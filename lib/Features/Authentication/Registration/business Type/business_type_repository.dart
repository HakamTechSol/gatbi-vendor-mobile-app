import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import 'business_type_model.dart';

class BusinessTypeRepository {
  const BusinessTypeRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Business Types
  // ============================================================

  Future<BusinessTypeModel> getBusinessTypes() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.businesstype,
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
    // Convert API Response -> Business Type Model
    // ----------------------------------------------------------

    final result = BusinessTypeModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');

      debugPrint('========== BUSINESS TYPES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('TOTAL: ${result.total ?? 0}');

      // --------------------------------------------------------
      // Business Types
      // --------------------------------------------------------

      debugPrint('');

      debugPrint('---------- BUSINESS TYPES ----------');

      debugPrint('BUSINESS TYPES COUNT: ${result.businessTypes.length}');

      if (result.businessTypes.isNotEmpty) {
        for (final businessType in result.businessTypes) {
          debugPrint(
            'BUSINESS TYPE: '
            '${businessType.value ?? 'N/A'} | '
            'LABEL: ${businessType.label ?? 'N/A'} | '
            'LABEL AR: ${businessType.labelAr ?? 'N/A'} | '
            'DESCRIPTION: '
            '${businessType.description ?? 'N/A'}',
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
