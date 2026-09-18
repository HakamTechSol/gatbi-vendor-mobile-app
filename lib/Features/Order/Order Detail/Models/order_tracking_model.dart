class VendorOrderTrackingModel {
  const VendorOrderTrackingModel({
    this.id,
    this.orderId,
    this.trackingNumber,
    this.carrier,
    this.trackingUrl,
    this.estimatedDelivery,
    this.lastLocation,
    this.lastUpdate,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final int? orderId;
  final String? trackingNumber;
  final String? carrier;
  final String? trackingUrl;
  final String? estimatedDelivery;
  final String? lastLocation;
  final String? lastUpdate;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderTrackingModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorOrderTrackingModel();
    }

    return VendorOrderTrackingModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      trackingNumber: _parseString(json['tracking_number']),
      carrier: _parseString(json['carrier']),
      trackingUrl: _parseString(json['tracking_url']),
      estimatedDelivery: _parseString(
        json['estimated_delivery'],
      ),
      lastLocation: _parseString(
        json['last_location'],
      ),
      lastUpdate: _parseString(
        json['last_update'],
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'tracking_number': trackingNumber,
      'carrier': carrier,
      'tracking_url': trackingUrl,
      'estimated_delivery': estimatedDelivery,
      'last_location': lastLocation,
      'last_update': lastUpdate,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  bool get hasValidTracking {
  final number = trackingNumber?.trim();
  final carrierName = carrier?.trim();

  return number != null &&
      number.isNotEmpty &&
      carrierName != null &&
      carrierName.isNotEmpty;
}

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}