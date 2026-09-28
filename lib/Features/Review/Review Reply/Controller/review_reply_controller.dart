import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/review_reply_model.dart';
import '../Repo/review_reply_repository.dart';

// ============================================================
// Review Reply Provider
// ============================================================

final reviewReplyControllerProvider = Provider<ReviewReplyController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return ReviewReplyController(dioClient: dioClient);
});

// ============================================================
// Review Reply Controller
// ============================================================

class ReviewReplyController {
  ReviewReplyController({required DioClient dioClient})
    : _repository = ReviewReplyRepository(dioClient);

  final ReviewReplyRepository _repository;

  // ==========================================================
  // Reply To Review
  // ==========================================================

  Future<ReviewReplyModel> replyToReview({
    required int reviewId,
    required String reply,
  }) async {
    try {
      final result = await _repository.replyToReview(
        reviewId: reviewId,
        reply: reply,
      );

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
