import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/mark_read_notification_model.dart';
import '../Repo/mark_read_notification_repo.dart';

// ============================================================
// Mark Read Notification Provider
// ============================================================

final markReadNotificationControllerProvider =
    Provider<MarkReadNotificationController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return MarkReadNotificationController(dioClient: dioClient);
    });

// ============================================================
// Mark Read Notification Controller
// ============================================================

class MarkReadNotificationController {
  MarkReadNotificationController({required DioClient dioClient})
    : _repository = MarkReadNotificationRepository(dioClient);

  final MarkReadNotificationRepository _repository;

  // ==========================================================
  // Mark Notification As Read
  // ==========================================================

  Future<MarkReadNotificationModel> markReadNotification({
    required int notificationId,
  }) async {
    try {
      final result = await _repository.markReadNotification(
        notificationId: notificationId,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein convert
      // kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
