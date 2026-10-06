import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/notification_setting_model.dart';
import '../Repo/notification_setting_repository.dart';

// ============================================================
// Notification Setting Provider
// ============================================================

final notificationSettingControllerProvider =
    Provider<NotificationSettingController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return NotificationSettingController(dioClient: dioClient);
    });

// ============================================================
// Notification Setting Controller
// ============================================================

class NotificationSettingController {
  NotificationSettingController({required DioClient dioClient})
    : _repository = NotificationSettingRepository(dioClient);

  final NotificationSettingRepository _repository;

  // ==========================================================
  // Update Notification Settings
  // ==========================================================

  Future<NotificationSettingModel> updateNotificationSettings({
    required bool emailNotifications,
    required bool smsNotifications,
    required bool marketingEmails,
  }) async {
    try {
      final result = await _repository.updateNotificationSettings(
        emailNotifications: emailNotifications,
        smsNotifications: smsNotifications,
        marketingEmails: marketingEmails,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
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
