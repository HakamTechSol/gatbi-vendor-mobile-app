import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Model/answer_model.dart';
import '../Repo/answer_repository.dart';

// ============================================================
// Answer Provider
// ============================================================

final answerControllerProvider = Provider<AnswerController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return AnswerController(dioClient: dioClient);
});

// ============================================================
// Answer Controller
// ============================================================

class AnswerController {
  AnswerController({required DioClient dioClient})
    : _repository = AnswerRepository(dioClient);

  final AnswerRepository _repository;

  // ==========================================================
  // Answer Question
  // ==========================================================

  Future<AnswerModel> answerQuestion({
    required int questionId,
    required String answer,
  }) async {
    try {
      final result = await _repository.answerQuestion(
        questionId: questionId,
        answer: answer,
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
