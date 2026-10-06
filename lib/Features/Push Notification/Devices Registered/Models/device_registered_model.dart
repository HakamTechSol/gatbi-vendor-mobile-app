class DeviceRegisteredModel {
  const DeviceRegisteredModel({
    this.success = false,
    this.message,
    this.device,
  });

  final bool success;
  final String? message;
  final DeviceRegisteredItemModel? device;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory DeviceRegisteredModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeviceRegisteredModel();
    }

    return DeviceRegisteredModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      device: json['device'] is Map
          ? DeviceRegisteredItemModel.fromJson(
              Map<String, dynamic>.from(json['device'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'device': device?.toJson()};
  }

  // ============================================================
  // PARSERS
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
}

// ================================================================
// DEVICE REGISTERED ITEM MODEL
// ================================================================

class DeviceRegisteredItemModel {
  const DeviceRegisteredItemModel({
    this.id,
    this.token,
    this.platform,
    this.deviceId,
    this.appVersion,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? token;
  final String? platform;
  final String? deviceId;
  final String? appVersion;
  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory DeviceRegisteredItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeviceRegisteredItemModel();
    }

    return DeviceRegisteredItemModel(
      id: _parseInt(json['id']),
      token: _parseString(json['token']),
      platform: _parseString(json['platform']),
      deviceId: _parseString(json['device_id']),
      appVersion: _parseString(json['app_version']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'platform': platform,
      'device_id': deviceId,
      'app_version': appVersion,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // PARSERS
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
