enum OrderPaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  partiallyRefunded,
  unknown,
}

extension OrderPaymentStatusExtension on OrderPaymentStatus {
  String get value {
    switch (this) {
      case OrderPaymentStatus.pending:
        return 'pending';
      case OrderPaymentStatus.paid:
        return 'paid';
      case OrderPaymentStatus.failed:
        return 'failed';
      case OrderPaymentStatus.refunded:
        return 'refunded';
      case OrderPaymentStatus.partiallyRefunded:
        return 'partially_refunded';
      case OrderPaymentStatus.unknown:
        return 'unknown';
    }
  }

  String get label {
    switch (this) {
      case OrderPaymentStatus.pending:
        return 'Pending';
      case OrderPaymentStatus.paid:
        return 'Paid';
      case OrderPaymentStatus.failed:
        return 'Failed';
      case OrderPaymentStatus.refunded:
        return 'Refunded';
      case OrderPaymentStatus.partiallyRefunded:
        return 'Partially Refunded';
      case OrderPaymentStatus.unknown:
        return 'Unknown';
    }
  }

  static OrderPaymentStatus fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'pending':
        return OrderPaymentStatus.pending;
      case 'paid':
        return OrderPaymentStatus.paid;
      case 'failed':
        return OrderPaymentStatus.failed;
      case 'refunded':
        return OrderPaymentStatus.refunded;
      case 'partially_refunded':
      case 'partially-refunded':
        return OrderPaymentStatus.partiallyRefunded;
      default:
        return OrderPaymentStatus.unknown;
    }
  }
}

class OrderPaymentModel {
  const OrderPaymentModel({
    required this.id,
    required this.status,
    required this.amount,
    this.method,
    this.transactionId,
    this.currency = 'AED',
    this.paidAt,
    this.paymentProofUrl,
    this.notes,
  });

  final String id;
  final OrderPaymentStatus status;
  final double amount;

  final String? method;
  final String? transactionId;
  final String currency;
  final DateTime? paidAt;
  final String? paymentProofUrl;
  final String? notes;

  factory OrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentModel(
      id: json['id']?.toString() ?? '',
      status: OrderPaymentStatusExtension.fromString(
        json['status']?.toString(),
      ),
      amount: _parseDouble(json['amount']),
      method: json['method']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      currency: json['currency']?.toString() ?? 'AED',
      paidAt: _parseDateTime(json['paid_at']),
      paymentProofUrl: json['payment_proof_url']?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.value,
      'amount': amount,
      'method': method,
      'transaction_id': transactionId,
      'currency': currency,
      'paid_at': paidAt?.toIso8601String(),
      'payment_proof_url': paymentProofUrl,
      'notes': notes,
    };
  }

  OrderPaymentModel copyWith({
    String? id,
    OrderPaymentStatus? status,
    double? amount,
    String? method,
    String? transactionId,
    String? currency,
    DateTime? paidAt,
    String? paymentProofUrl,
    String? notes,
  }) {
    return OrderPaymentModel(
      id: id ?? this.id,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      transactionId: transactionId ?? this.transactionId,
      currency: currency ?? this.currency,
      paidAt: paidAt ?? this.paidAt,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
      notes: notes ?? this.notes,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
