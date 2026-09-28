import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Model/answer_model.dart';


class AnswerRepository {
  const AnswerRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Answer Question
  // ============================================================

  Future<AnswerModel> answerQuestion({
    required int questionId,
    required String answer,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.answer(questionId),
      data: {'answer': answer},
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
    // Convert API Response -> Answer Model
    // ----------------------------------------------------------

    final result = AnswerModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== ANSWER QUESTION RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success ?? 'N/A'}');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('QUESTION ID: $questionId');
      debugPrint('ANSWER: $answer');

      // --------------------------------------------------------
      // Response
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}
