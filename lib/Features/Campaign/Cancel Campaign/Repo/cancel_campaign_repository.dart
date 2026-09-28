import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/cancel_campaign_model.dart';

class CancelCampaignRepository {
  const CancelCampaignRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Cancel Campaign
  // ============================================================

  Future<CancelCampaignModel> cancelCampaign(int campaignId) async {
    final endpoint = '${ApiUrls.campaigns}/$campaignId/cancel';

    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== CANCEL CAMPAIGN API ==========');
      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('CAMPAIGN ID: $campaignId');
      debugPrint('=========================================');
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Request
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = CancelCampaignModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Response
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== CANCEL CAMPAIGN RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Campaign
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGN ----------');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');

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
