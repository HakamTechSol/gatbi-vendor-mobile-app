import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/question_model.dart';
import '../Repo/question_repo.dart';

// ============================================================
// Question Provider
// ============================================================

final questionControllerProvider = Provider<QuestionController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return QuestionController(dioClient: dioClient);
});

// ============================================================
// Question Controller
// ============================================================

class QuestionController {
  QuestionController({required DioClient dioClient})
    : _repository = QuestionRepository(dioClient);

  final QuestionRepository _repository;

  // ==========================================================
  // Get Questions
  // ==========================================================

  Future<QuestionModel> getQuestions({int page = 1, int limit = 100}) async {
    try {
      final result = await _repository.getQuestions(page: page, limit: limit);

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
