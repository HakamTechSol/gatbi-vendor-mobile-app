class NotificationSettingModel {
  const NotificationSettingModel({
    this.success = false,
    this.message,
    this.user,
  });

  final bool success;
  final String? message;
  final NotificationSettingUserModel? user;

  // ============================================================
  // From JSON
  // ============================================================

  factory NotificationSettingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NotificationSettingModel();
    }

    return NotificationSettingModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      user: json['user'] is Map
          ? NotificationSettingUserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'user': user?.toJson()};
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ================================================================
// Notification Setting User Model
// ================================================================

class NotificationSettingUserModel {
  const NotificationSettingUserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.emailNotifications = false,
    this.smsNotifications = false,
    this.marketingEmails = false,
    this.language,
    this.currency,
  });

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  final bool emailNotifications;
  final bool smsNotifications;
  final bool marketingEmails;

  final String? language;
  final String? currency;

  // ============================================================
  // From JSON
  // ============================================================

  factory NotificationSettingUserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NotificationSettingUserModel();
    }

    return NotificationSettingUserModel(
      id: _parseInt(json['id']),
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      emailNotifications: _parseBool(json['email_notifications']),
      smsNotifications: _parseBool(json['sms_notifications']),
      marketingEmails: _parseBool(json['marketing_emails']),
      language: _parseString(json['language']),
      currency: _parseString(json['currency']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'marketing_emails': marketingEmails,
      'language': language,
      'currency': currency,
    };
  }

  // ============================================================
  // Parse Int
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
