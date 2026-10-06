class DeviceItemModel {
  const DeviceItemModel({
    this.id,
    this.userId,
    this.platform,
    this.deviceId,
    this.token,
    this.appVersion,
    this.lastSeenAt,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? userId;
  final String? platform;
  final String? deviceId;
  final String? token;
  final String? appVersion;
  final String? lastSeenAt;
  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory DeviceItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeviceItemModel();
    }

    return DeviceItemModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      platform: _parseString(json['platform']),
      deviceId: _parseString(json['device_id']),
      token: _parseString(json['token']),
      appVersion: _parseString(json['app_version']),
      lastSeenAt: _parseString(json['last_seen_at']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'platform': platform,
      'device_id': deviceId,
      'token': token,
      'app_version': appVersion,
      'last_seen_at': lastSeenAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
