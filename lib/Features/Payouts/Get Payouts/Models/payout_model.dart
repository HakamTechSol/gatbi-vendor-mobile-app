class PayoutModel {
  const PayoutModel({
    this.id,
    this.payoutNumber,
    this.amount,
    this.currency,
    this.currencySymbol,
    this.status,
    this.paymentMethod,
    this.paymentReference,
    this.periodStart,
    this.periodEnd,
    this.notes,
    this.processedAt,
    this.paidAt,
    this.createdAt,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? payoutNumber;
  final double? amount;
  final String? currency;
  final String? currencySymbol;
  final String? status;
  final String? paymentMethod;
  final String? paymentReference;
  final String? periodStart;
  final String? periodEnd;
  final String? notes;
  final String? processedAt;
  final String? paidAt;
  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory PayoutModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PayoutModel();
    }

    return PayoutModel(
      id: _parseInt(json['id']),
      payoutNumber: _parseString(json['payout_number']),
      amount: _parseDouble(json['amount']),
      currency: _parseString(json['currency']),
      currencySymbol: _parseString(json['currency_symbol']),
      status: _parseString(json['status']),
      paymentMethod: _parseString(json['payment_method']),
      paymentReference: _parseString(json['payment_reference']),
      periodStart: _parseString(json['period_start']),
      periodEnd: _parseString(json['period_end']),
      notes: _parseString(json['notes']),
      processedAt: _parseString(json['processed_at']),
      paidAt: _parseString(json['paid_at']),
      createdAt: _parseString(json['created_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payout_number': payoutNumber,
      'amount': amount,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'status': status,
      'payment_method': paymentMethod,
      'payment_reference': paymentReference,
      'period_start': periodStart,
      'period_end': periodEnd,
      'notes': notes,
      'processed_at': processedAt,
      'paid_at': paidAt,
      'created_at': createdAt,
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
      return double.tryParse(value);
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

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
