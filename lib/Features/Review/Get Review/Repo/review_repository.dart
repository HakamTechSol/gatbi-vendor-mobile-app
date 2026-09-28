import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/review_model.dart';

class ReviewRepository {
  const ReviewRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Reviews
  // ============================================================

  Future<ReviewListModel> getReviews({int page = 1, int limit = 100}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.reviews,
      queryParameters: {'page': page, 'limit': limit},
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
    // Convert API Response -> Review List Model
    // ----------------------------------------------------------

    final result = ReviewListModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final pagination = result.pagination;

      debugPrint('');
      debugPrint('========== REVIEWS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success ?? 'N/A'}');

      // --------------------------------------------------------
      // Request Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST PAGINATION ----------');
      debugPrint('REQUEST PAGE: $page');
      debugPrint('REQUEST LIMIT: $limit');

      // --------------------------------------------------------
      // Reviews
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REVIEWS ----------');

      debugPrint(
        'REVIEWS COUNT: '
        '${result.reviews.length}',
      );

      if (result.reviews.isNotEmpty) {
        for (final review in result.reviews) {
          debugPrint(
            'REVIEW: '
            'ID: ${review.id ?? 'N/A'} | '
            'PRODUCT: '
            '${review.product?.name ?? 'N/A'} | '
            'CUSTOMER: '
            '${review.customer?.name ?? 'N/A'} | '
            'RATING: ${review.rating ?? 'N/A'} | '
            'APPROVED: '
            '${review.isApproved ?? 'N/A'} | '
            'COMMENT: '
            '${review.comment ?? 'N/A'} | '
            'VENDOR REPLY: '
            '${review.vendorReply ?? 'N/A'} | '
            'CREATED AT: '
            '${review.createdAt ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAGINATION ----------');

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
        'HAS PREVIOUS PAGE: '
        '${pagination?.hasPreviousPage ?? false}',
      );

      debugPrint(
        'NEXT PAGE: '
        '${pagination?.nextPage ?? 'N/A'}',
      );

      debugPrint(
        'PREVIOUS PAGE: '
        '${pagination?.previousPage ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('====================================');
      debugPrint('');
    }

    return result;
  }
}
