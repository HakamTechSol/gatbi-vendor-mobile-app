import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/review_summary_model.dart';
import '../Repo/review_summary_repository.dart';

// ============================================================
// Review Summary Provider
// ============================================================

final reviewSummaryControllerProvider = Provider<ReviewSummaryController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return ReviewSummaryController(dioClient: dioClient);
});

// ============================================================
// Review Summary Controller
// ============================================================

class ReviewSummaryController {
  ReviewSummaryController({required DioClient dioClient})
    : _repository = ReviewSummaryRepository(dioClient);

  final ReviewSummaryRepository _repository;

  // ==========================================================
  // Get Review Summary
  // ==========================================================

  Future<ReviewSummaryModel> getReviewSummary() async {
    try {
      final result = await _repository.getReviewSummary();

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
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
