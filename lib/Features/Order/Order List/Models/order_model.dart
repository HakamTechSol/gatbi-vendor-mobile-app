import 'order_customer_model.dart';
import 'order_item_model.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  draft,
  unknown,
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.draft:
        return 'draft';
      case OrderStatus.unknown:
        return 'unknown';
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.draft:
        return 'Draft';
      case OrderStatus.unknown:
        return 'Unknown';
    }
  }

  static OrderStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'draft':
        return OrderStatus.draft;
      default:
        return OrderStatus.unknown;
    }
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.customer,
    this.items = const [],
    this.itemCount = 0,
    this.currency = 'AED',
    this.subtotal,
    this.shippingAmount,
    this.discountAmount,
  });

  final String id;
  final String orderNumber;
  final OrderStatus status;
  final double totalAmount;
  final DateTime createdAt;

  final OrderCustomerModel customer;
  final List<OrderItemModel> items;

  final int itemCount;
  final String currency;

  final double? subtotal;
  final double? shippingAmount;
  final double? discountAmount;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      status: OrderStatusExtension.fromString(
        json['status']?.toString(),
      ),
      totalAmount: _parseDouble(json['total_amount']),
      createdAt: _parseDateTime(json['created_at']),
      customer: OrderCustomerModel.fromJson(
        (json['customer'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) => OrderItemModel.fromJson(
                    item.cast<String, dynamic>(),
                  ),
                )
                .toList()
          : const [],
      itemCount: _parseInt(json['item_count']),
      currency: json['currency']?.toString() ?? 'AED',
      subtotal: _parseNullableDouble(json['subtotal']),
      shippingAmount: _parseNullableDouble(json['shipping_amount']),
      discountAmount: _parseNullableDouble(json['discount_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status.value,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'customer': customer.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'item_count': itemCount,
      'currency': currency,
      'subtotal': subtotal,
      'shipping_amount': shippingAmount,
      'discount_amount': discountAmount,
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    OrderStatus? status,
    double? totalAmount,
    DateTime? createdAt,
    OrderCustomerModel? customer,
    List<OrderItemModel>? items,
    int? itemCount,
    String? currency,
    double? subtotal,
    double? shippingAmount,
    double? discountAmount,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      currency: currency ?? this.currency,
      subtotal: subtotal ?? this.subtotal,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;

    return DateTime.tryParse(value?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString());
  }
}