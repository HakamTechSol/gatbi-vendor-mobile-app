import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/mark_all_read_notification_model.dart';
import '../Repo/mark_all_read_notification_repo.dart';

// ============================================================
// Mark All Read Notifications Provider
// ============================================================

final markAllReadNotificationControllerProvider =
    Provider<MarkAllReadNotificationController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return MarkAllReadNotificationController(dioClient: dioClient);
    });

// ============================================================
// Mark All Read Notifications Controller
// ============================================================

class MarkAllReadNotificationController {
  MarkAllReadNotificationController({required DioClient dioClient})
    : _repository = MarkAllReadNotificationRepository(dioClient);

  final MarkAllReadNotificationRepository _repository;

  // ==========================================================
  // Mark All Notifications As Read
  // ==========================================================

  Future<MarkAllReadNotificationModel> markAllReadNotifications() async {
    try {
      final result = await _repository.markAllReadNotifications();

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
