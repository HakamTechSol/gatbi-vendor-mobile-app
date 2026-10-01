import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/mark_read_notification_model.dart';

class MarkReadNotificationRepository {
  const MarkReadNotificationRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Mark Notification As Read
  // ============================================================

  Future<MarkReadNotificationModel> markReadNotification({
    required int notificationId,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.markReadNotification,
      data: {'notif_id': notificationId},
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
    // Convert API Response -> Mark Read Notification Model
    // ----------------------------------------------------------

    final result = MarkReadNotificationModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== MARK READ NOTIFICATION RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('NOTIFICATION ID: $notificationId');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RESPONSE ----------');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('UNREAD COUNT: ${result.unreadCount}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('====================================================');
      debugPrint('');
    }

    return result;
  }
}
