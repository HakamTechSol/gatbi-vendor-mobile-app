class PayoutRequestModel {
  const PayoutRequestModel({
    this.success = false,
    this.message,
    this.payoutId,
    this.amount,
    this.currency,
    this.currencySymbol,
    this.ordersIncluded,
    this.status,
  });

  // ============================================================
  // Constructor Fields
  // ============================================================

  final bool success;
  final String? message;
  final int? payoutId;
  final double? amount;
  final String? currency;
  final String? currencySymbol;
  final int? ordersIncluded;
  final String? status;

  // ============================================================
  // From JSON
  // ============================================================

  factory PayoutRequestModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PayoutRequestModel();
    }

    return PayoutRequestModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      payoutId: _parseInt(json['payout_id']),
      amount: _parseDouble(json['amount']),
      currency: _parseString(json['currency']),
      currencySymbol: _parseString(json['currency_symbol']),
      ordersIncluded: _parseInt(json['orders_included']),
      status: _parseString(json['status']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'payout_id': payoutId,
      'amount': amount,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'orders_included': ordersIncluded,
      'status': status,
    };
  }

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final text = value.trim();

      return text.isEmpty ? null : text;
    }

    return value.toString();
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final text = value.trim().toLowerCase();

      return text == 'true' || text == '1' || text == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
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
      return int.tryParse(value.trim());
    }

    return null;
  }

  // ============================================================
  // Parse Double
  // ============================================================

  static double? _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim());
    }

    return null;
  }
}
