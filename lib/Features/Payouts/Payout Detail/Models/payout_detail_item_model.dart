class PayoutDetailItemModel {
  const PayoutDetailItemModel({
    this.id,
    this.orderId,
    this.orderNumber,
    this.orderTotal,
    this.commissionRate,
    this.commissionAmount,
    this.vendorAmount,
  });

  final int? id;
  final int? orderId;
  final String? orderNumber;
  final double? orderTotal;
  final double? commissionRate;
  final double? commissionAmount;
  final double? vendorAmount;

  // ============================================================
  // From JSON
  // ============================================================

  factory PayoutDetailItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PayoutDetailItemModel();
    }

    return PayoutDetailItemModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      orderNumber: _parseString(json['order_number']),
      orderTotal: _parseDouble(json['order_total']),
      commissionRate: _parseDouble(json['commission_rate']),
      commissionAmount: _parseDouble(json['commission_amount']),
      vendorAmount: _parseDouble(json['vendor_amount']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'order_number': orderNumber,
      'order_total': orderTotal,
      'commission_rate': commissionRate,
      'commission_amount': commissionAmount,
      'vendor_amount': vendorAmount,
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

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

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
