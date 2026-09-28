import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/review_model.dart';
import '../Repo/review_repository.dart';

// ============================================================
// Review Provider
// ============================================================

final reviewControllerProvider = Provider<ReviewController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return ReviewController(dioClient: dioClient);
});

// ============================================================
// Review Controller
// ============================================================

class ReviewController {
  ReviewController({required DioClient dioClient})
    : _repository = ReviewRepository(dioClient);

  final ReviewRepository _repository;

  // ==========================================================
  // Get Reviews
  // ==========================================================

  Future<ReviewListModel> getReviews({int page = 1, int limit = 100}) async {
    try {
      final result = await _repository.getReviews(page: page, limit: limit);

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
