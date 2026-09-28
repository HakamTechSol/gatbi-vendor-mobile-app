import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/campaign_type_model.dart';

class CampaignTypeRepository {
  const CampaignTypeRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Campaign Types
  // ============================================================

  Future<CampaignTypeModel> getCampaignTypes() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.campaignTypes,
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
    // Convert API Response -> Campaign Type Model
    // ----------------------------------------------------------

    final result = CampaignTypeModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== CAMPAIGN TYPES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Campaign Types
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGN TYPES ----------');

      debugPrint(
        'CAMPAIGN TYPES COUNT: '
        '${result.campaignTypes.length}',
      );

      if (result.campaignTypes.isNotEmpty) {
        for (final campaignType in result.campaignTypes) {
          debugPrint(
            'CAMPAIGN TYPE: '
            '${campaignType.name ?? 'N/A'} | '
            'ID: ${campaignType.id ?? 'N/A'} | '
            'AUTOMATED: ${campaignType.automated} | '
            'ACTIVE: ${campaignType.isActive} | '
            'SORT ORDER: ${campaignType.sortOrder ?? 'N/A'}',
          );

          debugPrint(
            'DESCRIPTION: '
            '${campaignType.description ?? 'N/A'}',
          );
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