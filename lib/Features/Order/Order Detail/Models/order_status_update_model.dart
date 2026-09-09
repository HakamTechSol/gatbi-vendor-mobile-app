import '../../Order List/models/order_model.dart';

class OrderStatusUpdateModel {
  const OrderStatusUpdateModel({
    required this.status,
    this.note,
    this.trackingNumber,
    this.shippingCarrier,
    this.shippedAt,
    this.deliveredAt,
  });

  final OrderStatus status;

  final String? note;
  final String? trackingNumber;
  final String? shippingCarrier;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  factory OrderStatusUpdateModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderStatusUpdateModel(
      status: OrderStatusExtension.fromString(
        json['status']?.toString(),
      ),
      note: json['note']?.toString(),
      trackingNumber: json['tracking_number']?.toString(),
      shippingCarrier: json['shipping_carrier']?.toString(),
      shippedAt: _parseDateTime(json['shipped_at']),
      deliveredAt: _parseDateTime(json['delivered_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'note': note,
      'tracking_number': trackingNumber,
      'shipping_carrier': shippingCarrier,
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }

  OrderStatusUpdateModel copyWith({
    OrderStatus? status,
    String? note,
    String? trackingNumber,
    String? shippingCarrier,
    DateTime? shippedAt,
    DateTime? deliveredAt,
  }) {
    return OrderStatusUpdateModel(
      status: status ?? this.status,
      note: note ?? this.note,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingCarrier: shippingCarrier ?? this.shippingCarrier,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(
      value.toString(),
    );
  }
}