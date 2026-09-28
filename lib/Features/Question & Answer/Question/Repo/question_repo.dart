import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/question_model.dart';

class QuestionRepository {
  const QuestionRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Questions
  // ============================================================

  Future<QuestionModel> getQuestions({
    int page = 1,
    int limit = 100,
  }) async {
    final response =
        await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.question,
      queryParameters: {
        'page': page,
        'limit': limit,
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
    // Convert API Response -> Question Model
    // ----------------------------------------------------------

    final result = QuestionModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final pagination = result.pagination;

      debugPrint('');
      debugPrint('========== QUESTIONS RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('PAGE: $page');
      debugPrint('LIMIT: $limit');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- GENERAL ----------');
      debugPrint(
        'SUCCESS: ${result.success ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Questions
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- QUESTIONS ----------');
      debugPrint(
        'QUESTIONS COUNT: ${result.questions.length}',
      );

      if (result.questions.isNotEmpty) {
        for (final question in result.questions) {
          final product = question.product;
          final customer = question.customer;

          debugPrint(
            'QUESTION: '
            '${question.question ?? 'N/A'} | '
            'ID: ${question.id ?? 'N/A'} | '
            'ANSWERED: ${question.isAnswered ?? false}',
          );

          debugPrint(
            'PRODUCT: '
            '${product?.name ?? 'N/A'} | '
            'ID: ${product?.id ?? 'N/A'} | '
            'SLUG: ${product?.slug ?? 'N/A'}',
          );

          debugPrint(
            'CUSTOMER: '
            '${customer?.name ?? 'N/A'} | '
            'AVATAR: ${customer?.avatar ?? 'N/A'}',
          );

          debugPrint(
            'ANSWER: '
            '${question.answer ?? 'N/A'}',
          );

          debugPrint(
            'ANSWER CREATED AT: '
            '${question.answerCreatedAt ?? 'N/A'}',
          );

          debugPrint(
            'CREATED AT: '
            '${question.createdAt ?? 'N/A'}',
          );

          debugPrint('');
        }
      }

      // --------------------------------------------------------
      // Pagination
      // --------------------------------------------------------

      debugPrint(
        '---------- PAGINATION ----------',
      );

      debugPrint(
        'CURRENT PAGE: '
        '${pagination?.currentPage ?? 'N/A'}',
      );

      debugPrint(
        'TOTAL PAGES: '
        '${pagination?.totalPages ?? 'N/A'}',
      );

      debugPrint(
        'TOTAL ITEMS: '
        '${pagination?.totalItems ?? 'N/A'}',
      );

      debugPrint(
        'LIMIT: '
        '${pagination?.limit ?? 'N/A'}',
      );

      debugPrint(
        'HAS NEXT PAGE: '
        '${pagination?.hasNextPage ?? false}',
      );

      debugPrint(
        'NEXT PAGE: '
        '${pagination?.nextPage ?? 'N/A'}',
      );

      debugPrint(
        'HAS PREVIOUS PAGE: '
        '${pagination?.hasPreviousPage ?? false}',
      );

      debugPrint(
        'PREVIOUS PAGE: '
        '${pagination?.previousPage ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('======================================');
      debugPrint('');
    }

    return result;
  }
}