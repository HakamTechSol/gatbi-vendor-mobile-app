class DeleteNotificationModel {
  const DeleteNotificationModel({
    this.success = false,
    this.message,
    this.unreadCount = 0,
  });

  final bool success;
  final String? message;
  final int unreadCount;

  // ============================================================
  // From JSON
  // ============================================================

  factory DeleteNotificationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeleteNotificationModel();
    }

    return DeleteNotificationModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      unreadCount: _parseInt(json['unread_count']) ?? 0,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'unread_count': unreadCount,
    };
  }

  // ============================================================
  // Parsers
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

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
}
