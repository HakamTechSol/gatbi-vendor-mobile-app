import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/review_reply_model.dart';

class ReviewReplyRepository {
  const ReviewReplyRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Reply To Review
  // ============================================================

  Future<ReviewReplyModel> replyToReview({
    required int reviewId,
    required String reply,
  }) async {
    final response =
        await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.reviewReply(reviewId),
      data: {
        'reply': reply,
      },
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
    // Convert API Response -> Review Reply Model
    // ----------------------------------------------------------

    final result = ReviewReplyModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== REVIEW REPLY RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');

      debugPrint(
        'REVIEW ID: $reviewId',
      );

      debugPrint(
        'REPLY: $reply',
      );

      // --------------------------------------------------------
      // Response
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');

      debugPrint(
        'SUCCESS: ${result.success ?? 'N/A'}',
      );

      debugPrint(
        'MESSAGE: ${result.message ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('');
    }

    return result;
  }
}