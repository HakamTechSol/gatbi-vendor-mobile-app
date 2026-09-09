import '../../Order List/Models/order_customer_model.dart';
import '../../Order List/Models/order_model.dart';
import 'order_detail_item_model.dart';
import 'order_payment_model.dart';
import 'order_timeline_model.dart';

class OrderDetailModel {
  const OrderDetailModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.customer,
    this.items = const [],
    this.payment,
    this.timeline = const [],
    this.currency = 'AED',
    this.subtotal,
    this.shippingAmount,
    this.discountAmount,
    this.taxAmount,
    this.shippingAddress,
    this.billingAddress,
    this.notes,
    this.paymentProofUrl,
  });

  final String id;
  final String orderNumber;
  final OrderStatus status;
  final double totalAmount;
  final DateTime createdAt;

  final OrderCustomerModel customer;

  final List<OrderDetailItemModel> items;

  final OrderPaymentModel? payment;

  final List<OrderTimelineModel> timeline;

  final String currency;

  final double? subtotal;
  final double? shippingAmount;
  final double? discountAmount;
  final double? taxAmount;

  final Map<String, dynamic>? shippingAddress;
  final Map<String, dynamic>? billingAddress;

  final String? notes;
  final String? paymentProofUrl;

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id']?.toString() ?? '',
      orderNumber:
          json['order_number']?.toString() ??
          json['orderNumber']?.toString() ??
          '',
      status: OrderStatusExtension.fromString(json['status']?.toString()),
      totalAmount: _parseDouble(json['total_amount']),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      customer: json['customer'] is Map<String, dynamic>
          ? OrderCustomerModel.fromJson(
              json['customer'] as Map<String, dynamic>,
            )
          : const OrderCustomerModel(id: '', name: ''),
      items: _parseItems(json['items']),
      payment: json['payment'] is Map<String, dynamic>
          ? OrderPaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      timeline: _parseTimeline(json['timeline']),
      currency: json['currency']?.toString() ?? 'AED',
      subtotal: _parseNullableDouble(json['subtotal']),
      shippingAmount: _parseNullableDouble(json['shipping_amount']),
      discountAmount: _parseNullableDouble(json['discount_amount']),
      taxAmount: _parseNullableDouble(json['tax_amount']),
      shippingAddress: _parseMap(json['shipping_address']),
      billingAddress: _parseMap(json['billing_address']),
      notes: json['notes']?.toString(),
      paymentProofUrl: json['payment_proof_url']?.toString(),
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
      'payment': payment?.toJson(),
      'timeline': timeline.map((item) => item.toJson()).toList(),
      'currency': currency,
      'subtotal': subtotal,
      'shipping_amount': shippingAmount,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'shipping_address': shippingAddress,
      'billing_address': billingAddress,
      'notes': notes,
      'payment_proof_url': paymentProofUrl,
    };
  }

  OrderDetailModel copyWith({
    String? id,
    String? orderNumber,
    OrderStatus? status,
    double? totalAmount,
    DateTime? createdAt,
    OrderCustomerModel? customer,
    List<OrderDetailItemModel>? items,
    OrderPaymentModel? payment,
    List<OrderTimelineModel>? timeline,
    String? currency,
    double? subtotal,
    double? shippingAmount,
    double? discountAmount,
    double? taxAmount,
    Map<String, dynamic>? shippingAddress,
    Map<String, dynamic>? billingAddress,
    String? notes,
    String? paymentProofUrl,
  }) {
    return OrderDetailModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      payment: payment ?? this.payment,
      timeline: timeline ?? this.timeline,
      currency: currency ?? this.currency,
      subtotal: subtotal ?? this.subtotal,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      notes: notes ?? this.notes,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
    );
  }

  static List<OrderDetailItemModel> _parseItems(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(OrderDetailItemModel.fromJson)
        .toList();
  }

  static List<OrderTimelineModel> _parseTimeline(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(OrderTimelineModel.fromJson)
        .toList();
  }

  static Map<String, dynamic>? _parseMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    return null;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}
