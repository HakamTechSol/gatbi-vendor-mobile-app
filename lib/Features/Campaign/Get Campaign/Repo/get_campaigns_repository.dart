import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/get_campaigns_model.dart';

class GetCampaignsRepository {
  const GetCampaignsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Campaigns
  // ============================================================

  Future<GetCampaignsModel> getCampaigns({
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.campaigns,
      queryParameters: {'page': page, 'per_page': perPage},
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

    final result = GetCampaignsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== GET CAMPAIGNS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- GENERAL ----------');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('NOTES: ${result.notes ?? 'N/A'}');

      // --------------------------------------------------------
      // Request Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST PAGINATION ----------');
      debugPrint('REQUEST PAGE: $page');
      debugPrint('REQUEST PER PAGE: $perPage');

      // --------------------------------------------------------
      // Response Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE PAGINATION ----------');
      debugPrint('TOTAL: ${result.pagination?.total ?? 0}');
      debugPrint('PER PAGE: ${result.pagination?.perPage ?? 0}');
      debugPrint('CURRENT PAGE: ${result.pagination?.currentPage ?? 0}');
      debugPrint('LAST PAGE: ${result.pagination?.lastPage ?? 0}');
      debugPrint('HAS NEXT PAGE: ${result.hasNextPage}');
      debugPrint('HAS PREVIOUS PAGE: ${result.hasPreviousPage}');

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
        for (final type in result.campaignTypes) {
          debugPrint(
            'TYPE: '
            '${type.id ?? 'N/A'} | '
            'NAME: ${type.name ?? 'N/A'} | '
            'AUTOMATED: ${type.automated ?? false} | '
            'DESCRIPTION: '
            '${type.description ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // Campaigns
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGNS ----------');
      debugPrint(
        'CAMPAIGNS COUNT: '
        '${result.campaigns.length}',
      );

      if (result.campaigns.isNotEmpty) {
        for (final campaign in result.campaigns) {
          debugPrint(
            'CAMPAIGN: '
            '${campaign.name ?? 'N/A'} | '
            'ID: ${campaign.id ?? 'N/A'} | '
            'TYPE: ${campaign.campaignType ?? 'N/A'} | '
            'STATUS: ${campaign.status ?? 'N/A'} | '
            'STATUS LABEL: '
            '${campaign.statusLabel ?? 'N/A'}',
          );

          debugPrint(
            '  DISCOUNT: '
            '${campaign.discountPercentage ?? 'N/A'}',
          );

          debugPrint(
            '  REQUESTED DISCOUNT: '
            '${campaign.requestedDiscountPercentage ?? 'N/A'}',
          );

          debugPrint(
            '  PRODUCT IDS: '
            '${campaign.productIds ?? 'N/A'}',
          );

          debugPrint(
            '  PRODUCT ID LIST: '
            '${campaign.productIdList}',
          );

          debugPrint(
            '  START DATE: '
            '${campaign.startDate ?? 'N/A'}',
          );

          debugPrint(
            '  END DATE: '
            '${campaign.endDate ?? 'N/A'}',
          );

          debugPrint(
            '  VENDOR NOTES: '
            '${campaign.vendorNotes ?? 'N/A'}',
          );

          debugPrint(
            '  ADMIN NOTES: '
            '${campaign.adminNotes ?? 'N/A'}',
          );

          debugPrint(
            '  CREATED AT: '
            '${campaign.createdAt ?? 'N/A'}',
          );

          debugPrint(
            '  UPDATED AT: '
            '${campaign.updatedAt ?? 'N/A'}',
          );
        }
      }

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
