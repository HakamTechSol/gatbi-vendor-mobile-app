import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/create_campaign_model.dart';
import '../Repo/create_campaign_repository.dart';

// ============================================================
// Create Campaign Provider
// ============================================================

final createCampaignControllerProvider = Provider<CreateCampaignController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return CreateCampaignController(dioClient: dioClient);
});

// ============================================================
// Create Campaign Controller
// ============================================================

class CreateCampaignController {
  CreateCampaignController({required DioClient dioClient})
    : _repository = CreateCampaignRepository(dioClient);

  final CreateCampaignRepository _repository;

  // ==========================================================
  // Create Campaign
  // ==========================================================

  Future<CreateCampaignModel> createCampaign(
    CreateCampaignRequestModel request,
  ) async {
    try {
      final result = await _repository.createCampaign(request);

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
