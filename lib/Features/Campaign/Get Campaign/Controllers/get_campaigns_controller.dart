import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/get_campaigns_model.dart';
import '../Repo/get_campaigns_repository.dart';

// ============================================================
// Get Campaigns Provider
// ============================================================

final getCampaignsControllerProvider = Provider<GetCampaignsController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return GetCampaignsController(dioClient: dioClient);
});

// ============================================================
// Get Campaigns Controller
// ============================================================

class GetCampaignsController {
  GetCampaignsController({required DioClient dioClient})
    : _repository = GetCampaignsRepository(dioClient);

  final GetCampaignsRepository _repository;

  // ==========================================================
  // Get Campaigns
  // ==========================================================

  Future<GetCampaignsModel> getCampaigns({
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final result = await _repository.getCampaigns(
        page: page,
        perPage: perPage,
      );

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak
      // jane dein taake statusCode/code/details
      // preserve rahein.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException
      // mein convert kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }

  // ==========================================================
  // Get First Page
  // ==========================================================

  Future<GetCampaignsModel> getFirstPage({int perPage = 50}) async {
    return getCampaigns(page: 1, perPage: perPage);
  }

  // ==========================================================
  // Get Next Page
  // ==========================================================

  Future<GetCampaignsModel> getNextPage({
    required GetCampaignsModel currentData,
    int perPage = 50,
  }) async {
    if (!currentData.hasNextPage) {
      return currentData;
    }

    return getCampaigns(
      page: currentData.pagination!.nextPage,
      perPage: perPage,
    );
  }

  // ==========================================================
  // Get Previous Page
  // ==========================================================

  Future<GetCampaignsModel> getPreviousPage({
    required GetCampaignsModel currentData,
    int perPage = 50,
  }) async {
    if (!currentData.hasPreviousPage) {
      return currentData;
    }

    return getCampaigns(
      page: currentData.pagination!.previousPage,
      perPage: perPage,
    );
  }
}
