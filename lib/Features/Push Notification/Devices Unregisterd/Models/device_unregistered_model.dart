class DeviceUnregisteredModel {
  const DeviceUnregisteredModel({
    this.success = false,
    this.message,
    this.unreadCount,
  });

  final bool success;
  final String? message;
  final int? unreadCount;

  factory DeviceUnregisteredModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeviceUnregisteredModel();
    }

    return DeviceUnregisteredModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      unreadCount: _parseInt(json['unread_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'unread_count': unreadCount,
    };
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
}
