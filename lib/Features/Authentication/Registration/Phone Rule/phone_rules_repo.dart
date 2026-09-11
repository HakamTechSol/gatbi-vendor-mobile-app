import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import 'phone_rules_model.dart';

class PhoneRulesRepository {
  const PhoneRulesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Phone Rules
  // ============================================================

  Future<PhoneRulesModel> getPhoneRules() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.phoneRules,
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
    // Convert API Response -> Phone Rules Model
    // ----------------------------------------------------------

    final result = PhoneRulesModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');

      debugPrint('========== PHONE RULES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      debugPrint(
        'DEFAULT MIN LENGTH: '
        '${result.defaultMinLength ?? 0}',
      );

      debugPrint(
        'DEFAULT MAX LENGTH: '
        '${result.defaultMaxLength ?? 0}',
      );

      debugPrint('TOTAL: ${result.total ?? 0}');

      // --------------------------------------------------------
      // Phone Rules
      // --------------------------------------------------------

      debugPrint('');

      debugPrint('---------- PHONE RULES ----------');

      debugPrint('PHONE RULES COUNT: ${result.phoneRules.length}');

      if (result.phoneRules.isNotEmpty) {
        for (final phoneRule in result.phoneRules) {
          debugPrint(
            'PHONE RULE: '
            '${phoneRule.countryCode ?? 'N/A'} | '
            'MIN LENGTH: ${phoneRule.minLength ?? 0} | '
            'MAX LENGTH: ${phoneRule.maxLength ?? 0} | '
            'EXAMPLE: ${phoneRule.example ?? 'N/A'}',
          );
        }
      }

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
