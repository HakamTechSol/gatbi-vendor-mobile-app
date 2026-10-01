import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/mark_all_read_notification_model.dart';

class MarkAllReadNotificationRepository {
  const MarkAllReadNotificationRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Mark All Notifications As Read
  // ============================================================

  Future<MarkAllReadNotificationModel> markAllReadNotifications() async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.markAllReadNotifications,
      data: {},
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
    // Convert API Response -> Mark All Read Model
    // ----------------------------------------------------------

    final result = MarkAllReadNotificationModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== MARK ALL READ NOTIFICATIONS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('UNREAD COUNT: ${result.unreadCount}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=========================================================');
      debugPrint('');
    }

    return result;
  }
}
