
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/campaign_type_model.dart';
import '../Repo/campaign_type_repo.dart';

// ============================================================
// Campaign Type Provider
// ============================================================

final campaignTypeControllerProvider =
    Provider<CampaignTypeController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CampaignTypeController(
    dioClient: dioClient,
  );
});

// ============================================================
// Campaign Type Controller
// ============================================================

class CampaignTypeController {
  CampaignTypeController({
    required DioClient dioClient,
  }) : _repository = CampaignTypeRepository(dioClient);

  final CampaignTypeRepository _repository;

  // ==========================================================
  // Get Campaign Types
  // ==========================================================

  Future<CampaignTypeModel> getCampaignTypes() async {
    try {
      final result = await _repository.getCampaignTypes();

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein convert
      // kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}