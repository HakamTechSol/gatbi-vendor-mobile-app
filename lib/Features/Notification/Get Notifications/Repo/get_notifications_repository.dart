import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_notifications_model.dart';

class GetNotificationsRepository {
  const GetNotificationsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Notifications
  // ============================================================

  Future<GetNotificationsModel> getNotifications({
    int? page,
    int? limit,
    String? filter,
    String? type,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (page != null) {
      queryParameters['page'] = page;
    }

    if (limit != null) {
      queryParameters['limit'] = limit;
    }

    if (filter != null && filter.isNotEmpty) {
      queryParameters['filter'] = filter;
    }

    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.getNotifications,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
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
    // Convert API Response -> Get Notifications Model
    // ----------------------------------------------------------

    final result = GetNotificationsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== GET NOTIFICATIONS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('UNREAD COUNT: ${result.unreadCount}');

      // --------------------------------------------------------
      // Request Filters
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST FILTERS ----------');
      debugPrint('PAGE: ${page ?? 'N/A'}');
      debugPrint('LIMIT: ${limit ?? 'N/A'}');
      debugPrint('FILTER: ${filter ?? 'N/A'}');
      debugPrint('TYPE: ${type ?? 'N/A'}');

      // --------------------------------------------------------
      // Notifications
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- NOTIFICATIONS ----------');
      debugPrint(
        'NOTIFICATIONS COUNT: '
        '${result.notifications.length}',
      );

      if (result.notifications.isNotEmpty) {
        for (final notification in result.notifications) {
          debugPrint(
            'NOTIFICATION: '
            'ID: ${notification.id ?? 'N/A'} | '
            'TYPE: ${notification.type ?? 'N/A'} | '
            'TITLE: ${notification.title ?? 'N/A'} | '
            'READ: ${notification.isRead} | '
            'CREATED AT: ${notification.createdAt ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // Pagination
      // --------------------------------------------------------

      final pagination = result.pagination;

      debugPrint('');
      debugPrint('---------- PAGINATION ----------');
      debugPrint(
        'CURRENT PAGE: '
        '${pagination?.currentPage ?? 0}',
      );
      debugPrint(
        'TOTAL PAGES: '
        '${pagination?.totalPages ?? 0}',
      );
      debugPrint(
        'TOTAL ITEMS: '
        '${pagination?.totalItems ?? 0}',
      );
      debugPrint(
        'LIMIT: '
        '${pagination?.limit ?? 0}',
      );

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
