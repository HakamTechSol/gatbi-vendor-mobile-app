import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/create_campaign_model.dart';

class CreateCampaignRepository {
  const CreateCampaignRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Create Campaign
  // ============================================================

  Future<CreateCampaignModel> createCampaign(
    CreateCampaignRequestModel request,
  ) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.createCampaign,
      data: request.toJson(),
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
    // Convert API Response -> Create Campaign Model
    // ----------------------------------------------------------

    final result = CreateCampaignModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== CREATE CAMPAIGN RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('CAMPAIGN TYPE: ${request.campaignType}');
      debugPrint('PRODUCT URLS: ${request.productIds}');
      debugPrint('START DATE: ${request.startDate}');
      debugPrint('END DATE: ${request.endDate}');
      debugPrint('NOTES: ${request.notes}');

      // --------------------------------------------------------
      // General Response
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');
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
      // Support Ticket
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- SUPPORT TICKET ----------');
      debugPrint('TICKET ID: ${result.ticketId ?? 'N/A'}');
      debugPrint('TICKET NUMBER: ${result.ticketNumber ?? 'N/A'}');

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
