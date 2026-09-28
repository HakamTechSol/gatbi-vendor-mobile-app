import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/cancel_campaign_model.dart';
import '../Repo/cancel_campaign_repository.dart';

// ============================================================
// Cancel Campaign Provider
// ============================================================

final cancelCampaignControllerProvider = Provider<CancelCampaignController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return CancelCampaignController(dioClient: dioClient);
});

// ============================================================
// Cancel Campaign Controller
// ============================================================

class CancelCampaignController {
  CancelCampaignController({required DioClient dioClient})
    : _repository = CancelCampaignRepository(dioClient);

  final CancelCampaignRepository _repository;

  // ==========================================================
  // Cancel Campaign
  // ==========================================================

  Future<CancelCampaignModel> cancelCampaign(int campaignId) async {
    try {
      final result = await _repository.cancelCampaign(campaignId);

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur original error
      // preserve rehte hain.
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
