import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/campaign_detail_model.dart';

class CampaignDetailRepository {
  const CampaignDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Campaign Detail
  // ============================================================

  Future<CampaignDetailModel> getCampaignDetail(int campaignId) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiUrls.campaignDetail}/$campaignId',
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
    // Convert API Response -> Campaign Detail Model
    // ----------------------------------------------------------

    final result = CampaignDetailModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final campaign = result.campaign;

      debugPrint('');
      debugPrint('========== CAMPAIGN DETAIL RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Campaign
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGN ----------');

      debugPrint(
        'CAMPAIGN ID: '
        '${campaign?.id ?? 'N/A'}',
      );

      debugPrint(
        'CAMPAIGN NAME: '
        '${campaign?.name ?? 'N/A'}',
      );

      debugPrint(
        'CAMPAIGN TYPE: '
        '${campaign?.campaignType ?? 'N/A'}',
      );

      debugPrint(
        'STATUS: '
        '${campaign?.status ?? 'N/A'}',
      );

      debugPrint(
        'STATUS LABEL: '
        '${campaign?.statusLabel ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Discount
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- DISCOUNT ----------');

      debugPrint(
        'DISCOUNT PERCENTAGE: '
        '${campaign?.discountPercentage ?? 0}',
      );

      debugPrint(
        'REQUESTED DISCOUNT PERCENTAGE: '
        '${campaign?.requestedDiscountPercentage ?? 0}',
      );

      // --------------------------------------------------------
      // Products
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRODUCTS ----------');

      debugPrint(
        'PRODUCT IDS: '
        '${campaign?.productIds ?? 'N/A'}',
      );

      debugPrint(
        'PRODUCT URLS: '
        '${campaign?.productUrls ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Campaign Dates
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGN DATES ----------');

      debugPrint(
        'START DATE: '
        '${campaign?.startDate ?? 'N/A'}',
      );

      debugPrint(
        'END DATE: '
        '${campaign?.endDate ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Notes
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- NOTES ----------');

      debugPrint(
        'VENDOR NOTES: '
        '${campaign?.vendorNotes ?? 'N/A'}',
      );

      debugPrint(
        'ADMIN NOTES: '
        '${campaign?.adminNotes ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Timestamps
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- TIMESTAMPS ----------');

      debugPrint(
        'CREATED AT: '
        '${campaign?.createdAt ?? 'N/A'}',
      );

      debugPrint(
        'UPDATED AT: '
        '${campaign?.updatedAt ?? 'N/A'}',
      );

      debugPrint(
        'APPROVED AT: '
        '${campaign?.approvedAt ?? 'N/A'}',
      );

      debugPrint(
        'ACTIVATED AT: '
        '${campaign?.activatedAt ?? 'N/A'}',
      );

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
