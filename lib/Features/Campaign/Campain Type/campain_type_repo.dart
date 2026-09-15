import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../Services/dio_client.dart';
import 'campain_type_model.dart';

class CampaignsRepository {
  const CampaignsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Campaigns
  // ============================================================

  Future<CampaignsModel> getCampaigns() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.campaigns,
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = CampaignsModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('Campaigns API Success: ${result.success}');

      debugPrint(
        'Campaign Types Count: '
        '${result.campaignTypes.length}',
      );

      debugPrint('Campaign Notes: ${result.notes}');
    }

    return result;
  }
}
