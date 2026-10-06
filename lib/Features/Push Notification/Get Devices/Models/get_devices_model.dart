import 'device_item_model.dart';

class GetDevicesModel {
  const GetDevicesModel({this.success = false, this.devices = const []});

  final bool success;
  final List<DeviceItemModel> devices;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetDevicesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetDevicesModel();
    }

    return GetDevicesModel(
      success: _parseBool(json['success']),
      devices: _parseList(json['devices'], DeviceItemModel.fromJson),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'devices': devices.map((device) => device.toJson()).toList(),
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
  // Parse List
  // ============================================================

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
