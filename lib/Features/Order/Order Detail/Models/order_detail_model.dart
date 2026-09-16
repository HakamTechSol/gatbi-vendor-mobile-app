import 'order_detail_customer_model.dart';
import 'order_detail_item_model.dart';
import 'order_shipping_address_model.dart';
import 'order_status_history_model.dart';
import 'order_tracking_model.dart';

class VendorOrderDetailModel {
  const VendorOrderDetailModel({
    this.id,
    this.orderNumber,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.currency,
    this.currencySymbol,
    this.total,
    this.shipping,
    this.tax,
    this.subtotal,
    this.createdAt,
    this.items = const [],
    this.statusHistory = const [],
    this.tracking = const [],
    this.shippingAddress,
    this.customer,
  });

  // ============================================================
  // Order Fields
  // ============================================================

  final int? id;
  final String? orderNumber;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? currency;
  final String? currencySymbol;

  final num? total;
  final num? shipping;
  final num? tax;
  final num? subtotal;

  final String? createdAt;

  // ============================================================
  // Nested Data
  // ============================================================

  final List<VendorOrderDetailItemModel> items;

  final List<VendorOrderStatusHistoryModel> statusHistory;

  final List<VendorOrderTrackingModel> tracking;

  final VendorOrderShippingAddressModel? shippingAddress;

  final VendorOrderDetailCustomerModel? customer;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderDetailModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorOrderDetailModel();
    }

    return VendorOrderDetailModel(
      id: _parseInt(json['id']),
      orderNumber: _parseString(json['order_number']),
      status: _parseString(json['status']),
      paymentStatus: _parseString(json['payment_status']),
      paymentMethod: _parseString(json['payment_method']),
      currency: _parseString(json['currency']),
      currencySymbol: _parseString(json['currency_symbol']),
      total: _parseNum(json['total']),
      shipping: _parseNum(json['shipping']),
      tax: _parseNum(json['tax']),
      subtotal: _parseNum(json['subtotal']),
      createdAt: _parseString(json['created_at']),

      items: _parseList(
        json['items'],
        VendorOrderDetailItemModel.fromJson,
      ),

      statusHistory: _parseList(
        json['status_history'],
        VendorOrderStatusHistoryModel.fromJson,
      ),

      tracking: _parseList(
        json['tracking'],
        VendorOrderTrackingModel.fromJson,
      ),

      shippingAddress: json['shipping_address'] is Map
          ? VendorOrderShippingAddressModel.fromJson(
              Map<String, dynamic>.from(
                json['shipping_address'] as Map,
              ),
            )
          : null,

      customer: json['customer'] is Map
          ? VendorOrderDetailCustomerModel.fromJson(
              Map<String, dynamic>.from(
                json['customer'] as Map,
              ),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'total': total,
      'shipping': shipping,
      'tax': tax,
      'subtotal': subtotal,
      'created_at': createdAt,
      'items': items.map((e) => e.toJson()).toList(),
      'status_history':
          statusHistory.map((e) => e.toJson()).toList(),
      'tracking': tracking.map((e) => e.toJson()).toList(),
      'shipping_address': shippingAddress?.toJson(),
      'customer': customer?.toJson(),
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

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}