import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/review_summary_model.dart';

class ReviewSummaryRepository {
  const ReviewSummaryRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Review Summary
  // ============================================================

  Future<ReviewSummaryModel> getReviewSummary() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.reviewsSummary,
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
    // Convert API Response -> Review Summary Model
    // ----------------------------------------------------------

    final result = ReviewSummaryModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final summary = result.summary;

      debugPrint('');
      debugPrint('========== REVIEW SUMMARY RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Summary
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REVIEW SUMMARY ----------');

      debugPrint(
        'AVERAGE RATING: '
        '${summary?.averageRating ?? 0}',
      );

      debugPrint(
        'TOTAL REVIEWS: '
        '${summary?.totalReviews ?? 0}',
      );

      debugPrint(
        'APPROVED REVIEWS: '
        '${summary?.approvedReviews ?? 0}',
      );

      debugPrint(
        'PENDING REVIEWS: '
        '${summary?.pendingReviews ?? 0}',
      );

      // --------------------------------------------------------
      // Rating Breakdown
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RATING BREAKDOWN ----------');

      debugPrint(
        'RATING BREAKDOWN: '
        '${summary?.ratingBreakdown ?? {}}',
      );

      if (summary?.ratingBreakdown.isNotEmpty == true) {
        summary!.ratingBreakdown.forEach((rating, count) {
          debugPrint('$rating STAR: $count');
        });
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('===========================================');
      debugPrint('');
    }

    return result;
  }
}
