class VendorOrderPaymentProofModel {
  const VendorOrderPaymentProofModel({
    this.id,
    this.orderId,
    this.paymentMethod,
    this.transactionReference,
    this.amount,
    this.paymentDate,
    this.bankName,
    this.accountHolderName,
    this.verificationStatus,
    this.rejectionReason,
    this.notes,
    this.proofImageUrl,
    this.createdAt,
  });

  // ============================================================
  // Payment Proof Fields
  // ============================================================

  final int? id;
  final int? orderId;

  final String? paymentMethod;
  final String? transactionReference;

  final num? amount;

  final String? paymentDate;
  final String? bankName;
  final String? accountHolderName;

  final String? verificationStatus;
  final String? rejectionReason;
  final String? notes;

  final String? proofImageUrl;

  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderPaymentProofModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderPaymentProofModel();
    }

    return VendorOrderPaymentProofModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      paymentMethod: _parseString(json['payment_method']),
      transactionReference: _parseString(json['transaction_reference']),
      amount: _parseNum(json['amount']),
      paymentDate: _parseString(json['payment_date']),
      bankName: _parseString(json['bank_name']),
      accountHolderName: _parseString(json['account_holder_name']),
      verificationStatus: _parseString(json['verification_status']),
      rejectionReason: _parseString(json['rejection_reason']),
      notes: _parseString(json['notes']),
      proofImageUrl: _parseString(json['proof_image_url']),
      createdAt: _parseString(json['created_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'payment_method': paymentMethod,
      'transaction_reference': transactionReference,
      'amount': amount,
      'payment_date': paymentDate,
      'bank_name': bankName,
      'account_holder_name': accountHolderName,
      'verification_status': verificationStatus,
      'rejection_reason': rejectionReason,
      'notes': notes,
      'proof_image_url': proofImageUrl,
      'created_at': createdAt,
    };
  }

  // ============================================================
  // Helpers
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
      return int.tryParse(value);
    }

    return null;
  }

  static num? _parseNum(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }
}
