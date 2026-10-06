import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/delete_notification_model.dart';
import '../Repo/delete_notification_repository.dart';

// ============================================================
// Delete Notification Provider
// ============================================================

final deleteNotificationControllerProvider =
    Provider<DeleteNotificationController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return DeleteNotificationController(dioClient: dioClient);
    });

// ============================================================
// Delete Notification Controller
// ============================================================

class DeleteNotificationController {
  DeleteNotificationController({required DioClient dioClient})
    : _repository = DeleteNotificationRepository(dioClient);

  final DeleteNotificationRepository _repository;

  // ==========================================================
  // Delete Notification
  // ==========================================================

  Future<DeleteNotificationModel> deleteNotification({
    required int notificationId,
  }) async {
    try {
      final result = await _repository.deleteNotification(
        notificationId: notificationId,
      );

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur original error details
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
