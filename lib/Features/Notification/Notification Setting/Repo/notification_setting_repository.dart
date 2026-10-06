import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/notification_setting_model.dart';

class NotificationSettingRepository {
  const NotificationSettingRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Update Notification Settings
  // ============================================================

  Future<NotificationSettingModel> updateNotificationSettings({
    required bool emailNotifications,
    required bool smsNotifications,
    required bool marketingEmails,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.notificationSettings,
      data: {
        'email_notifications': emailNotifications ? '1' : '0',
        'sms_notifications': smsNotifications ? '1' : '0',
        'marketing_emails': marketingEmails ? '1' : '0',
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = NotificationSettingModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final user = result.user;

      debugPrint('');
      debugPrint('========== NOTIFICATION SETTINGS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');

      debugPrint(
        'EMAIL NOTIFICATIONS: '
        '${emailNotifications ? '1' : '0'}',
      );

      debugPrint(
        'SMS NOTIFICATIONS: '
        '${smsNotifications ? '1' : '0'}',
      );

      debugPrint(
        'MARKETING EMAILS: '
        '${marketingEmails ? '1' : '0'}',
      );

      // --------------------------------------------------------
      // User
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- USER ----------');

      debugPrint('USER ID: ${user?.id ?? 'N/A'}');

      debugPrint('FIRST NAME: ${user?.firstName ?? 'N/A'}');

      debugPrint('LAST NAME: ${user?.lastName ?? 'N/A'}');

      debugPrint('EMAIL: ${user?.email ?? 'N/A'}');

      debugPrint('PHONE: ${user?.phone ?? 'N/A'}');

      // --------------------------------------------------------
      // Notification Preferences
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- NOTIFICATION PREFERENCES ----------');

      debugPrint(
        'EMAIL NOTIFICATIONS: '
        '${user?.emailNotifications ?? false}',
      );

      debugPrint(
        'SMS NOTIFICATIONS: '
        '${user?.smsNotifications ?? false}',
      );

      debugPrint(
        'MARKETING EMAILS: '
        '${user?.marketingEmails ?? false}',
      );

      // --------------------------------------------------------
      // Other Preferences
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- OTHER PREFERENCES ----------');

      debugPrint('LANGUAGE: ${user?.language ?? 'N/A'}');

      debugPrint('CURRENCY: ${user?.currency ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('');
    }

    return result;
  }
}
