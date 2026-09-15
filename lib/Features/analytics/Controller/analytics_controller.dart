import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/analytics_model.dart';
import '../Repo/analytics_repository.dart';

// ============================================================
// Analytics Provider
// ============================================================

final analyticsControllerProvider = Provider<AnalyticsController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return AnalyticsController(dioClient: dioClient);
});

// ============================================================
// Analytics Controller
// ============================================================

class AnalyticsController {
  AnalyticsController({required DioClient dioClient})
    : _repository = AnalyticsRepository(dioClient);

  final AnalyticsRepository _repository;

  // ==========================================================
  // Get Analytics
  // ==========================================================

  Future<AnalyticsModel> getAnalytics({String? start, String? end}) async {
    try {
      return await _repository.getAnalytics(start: start, end: end);
    } on ApiException {
      // Existing ApiException ko preserve karte hain.
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
