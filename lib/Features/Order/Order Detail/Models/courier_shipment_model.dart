// ============================================================
//  COURIER SHIPMENT MODEL  (Vendor app — singular object)
//  Supports both internal rider AND EMX external carrier.
// ============================================================

class VendorCourierShipmentModel {
  const VendorCourierShipmentModel({
    this.shipmentNo,
    this.providerName,
    this.provider,
    this.carrier,
    this.carrierStatus,
    this.status,
    this.awbNumber,
    this.trackingUrl,
    this.riderName,
    this.riderPhone,
    this.codAmount,
    this.codCollected,
    this.receiverName,
    this.failureReason,
    this.pickupScheduledAt,
    this.pickedUpAt,
    this.deliveredAt,
  });

  // ── Identity ──
  final String? shipmentNo;
  final String? providerName; // e.g. "EMX (Emirates Post)"
  final String? provider; // alias fallback
  final String? carrier; // "internal" | "emx"
  final String? carrierStatus; // raw EMX status, e.g. "Out For Delivery"
  final String? status; // normalised, e.g. "pickup_scheduled"
  final String? awbNumber;
  final String? trackingUrl;

  // ── Rider (internal only) ──
  final String? riderName;
  final String? riderPhone;

  // ── COD ──
  final num? codAmount;
  final num? codCollected;

  // ── Delivery ──
  final String? receiverName;
  final String? failureReason;
  final String? pickupScheduledAt;
  final String? pickedUpAt;
  final String? deliveredAt;

  // ============================================================
  //  PARSING
  // ============================================================
  factory VendorCourierShipmentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const VendorCourierShipmentModel();

    // rider can be map OR null
    String? riderName;
    String? riderPhone;
    final rider = json['rider'];
    if (rider is Map) {
      riderName = _parseString(rider['name']);
      riderPhone = _parseString(rider['phone']);
    }

    return VendorCourierShipmentModel(
      shipmentNo: _parseString(json['shipment_no']),
      providerName: _parseString(json['provider_name'] ?? json['provider']),
      provider: _parseString(json['provider']),
      carrier: _parseString(json['carrier']),
      carrierStatus: _parseString(json['carrier_status']),
      status: _parseString(json['status']),
      awbNumber: _parseString(json['awb_number']),
      trackingUrl: _parseString(json['tracking_url']),
      riderName: riderName,
      riderPhone: riderPhone,
      codAmount: _parseNum(json['cod_amount']),
      codCollected: _parseNum(json['cod_collected']),
      receiverName: _parseString(json['receiver_name']),
      failureReason: _parseString(json['failure_reason']),
      pickupScheduledAt: _parseString(json['pickup_scheduled_at']),
      pickedUpAt: _parseString(json['picked_up_at']),
      deliveredAt: _parseString(json['delivered_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'shipment_no': shipmentNo,
    'provider_name': providerName,
    'provider': provider,
    'carrier': carrier,
    'carrier_status': carrierStatus,
    'status': status,
    'awb_number': awbNumber,
    'tracking_url': trackingUrl,
    'rider': {'name': riderName, 'phone': riderPhone},
    'cod_amount': codAmount,
    'cod_collected': codCollected,
    'receiver_name': receiverName,
    'failure_reason': failureReason,
    'pickup_scheduled_at': pickupScheduledAt,
    'picked_up_at': pickedUpAt,
    'delivered_at': deliveredAt,
  };

  // ============================================================
  //  COMPUTED
  // ============================================================
  bool get isEmx => (carrier ?? '').trim().toLowerCase() == 'emx';

  bool get isInternal => (carrier ?? '').trim().toLowerCase() == 'internal';

  /// Terminal → delivered / cancelled / returned
  bool get isTerminal {
    final s = (status ?? '').trim().toLowerCase();
    return s == 'delivered' || s == 'cancelled' || s == 'returned';
  }

  /// Active → not terminal (buttons hide karne ke liye)
  bool get isActive => !isTerminal;

  String get displayProvider {
    if (providerName != null && providerName!.trim().isNotEmpty) {
      return providerName!.trim();
    }
    if (provider != null && provider!.trim().isNotEmpty) {
      return provider!.trim();
    }
    return isEmx ? 'EMX (Emirates Post)' : 'Gatbi Courier';
  }

  String get safeCarrierStatus {
    final raw = (carrierStatus ?? '').trim();
    final low = raw.toLowerCase();
    if (low == 'booking_failed') return 'Shipment is being arranged';
    if (low == 'tracking_error') return 'Status temporarily unavailable';
    return raw;
  }

  bool get isBookingFailed =>
      (carrierStatus ?? '').trim().toLowerCase() == 'booking_failed';

  // ============================================================
  //  HELPERS
  // ============================================================
  static String? _parseString(dynamic v) {
    if (v == null) return null;
    if (v is String) {
      final s = v.trim();
      return s.isEmpty || s == 'null' ? null : s;
    }
    return v.toString();
  }

  static num? _parseNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}
