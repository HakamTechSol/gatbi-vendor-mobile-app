import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/campaign_detail_model.dart';
import '../Repo/campaign_detail_repository.dart';

// ============================================================
// Campaign Detail Provider
// ============================================================

final campaignDetailControllerProvider = Provider<CampaignDetailController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return CampaignDetailController(dioClient: dioClient);
});

// ============================================================
// Campaign Detail Controller
// ============================================================

class CampaignDetailController {
  CampaignDetailController({required DioClient dioClient})
    : _repository = CampaignDetailRepository(dioClient);

  final CampaignDetailRepository _repository;

  // ==========================================================
  // Get Campaign Detail
  // ==========================================================

  Future<CampaignDetailModel> getCampaignDetail(int campaignId) async {
    try {
      final result = await _repository.getCampaignDetail(campaignId);

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
