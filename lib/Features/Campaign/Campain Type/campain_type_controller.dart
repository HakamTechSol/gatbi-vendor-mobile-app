import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../Services/dio_client.dart';
import 'campain_type_model.dart';
import 'campain_type_repo.dart';

final campaignsControllerProvider = Provider<CampaignsController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CampaignsController(dioClient: dioClient);
});

class CampaignsController {
  CampaignsController({required DioClient dioClient})
    : _repository = CampaignsRepository(dioClient);

  final CampaignsRepository _repository;

  // ============================================================
  // Get Campaigns
  // ============================================================

  Future<CampaignsModel> getCampaigns() async {
    try {
      return await _repository.getCampaigns();
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
