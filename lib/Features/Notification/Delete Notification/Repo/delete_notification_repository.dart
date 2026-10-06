import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/delete_notification_model.dart';

class DeleteNotificationRepository {
  const DeleteNotificationRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Delete Notification
  // ============================================================

  Future<DeleteNotificationModel> deleteNotification({
    required int notificationId,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.deleteNotification,
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
    // Convert API Response -> Delete Notification Model
    // ----------------------------------------------------------

    final result = DeleteNotificationModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== DELETE NOTIFICATION RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('NOTIFICATION ID: $notificationId');

      // --------------------------------------------------------
      // Response
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
      debugPrint('===============================================');
      debugPrint('');
    }

    return result;
  }
}
