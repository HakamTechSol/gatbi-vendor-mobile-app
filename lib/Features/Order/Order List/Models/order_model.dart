import 'order_customer_model.dart';

class VendorOrderModel {
  const VendorOrderModel({
    this.id,
    this.orderNumber,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.customer,
    this.vendorTotal,
    this.vendorQuantity,
    this.productName,
    this.productImage,
    this.createdAt,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? orderNumber;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final VendorOrderCustomerModel? customer;
  final num? vendorTotal;
  final int? vendorQuantity;
  final String? productName;
  final String? productImage;
  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderModel();
    }

    return VendorOrderModel(
      id: _parseInt(json['id']),
      orderNumber: _parseString(json['order_number']),
      status: _parseString(json['status']),
      paymentStatus: _parseString(json['payment_status']),
      paymentMethod: _parseString(json['payment_method']),
      customer: json['customer'] is Map
          ? VendorOrderCustomerModel.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map),
            )
          : null,
      vendorTotal: _parseNum(json['vendor_total']),
      vendorQuantity: _parseInt(json['vendor_quantity']),
      productName: _parseString(json['product_name']),
      productImage: _parseString(json['product_image']),
      createdAt: _parseString(json['created_at']),
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
      'customer': customer?.toJson(),
      'vendor_total': vendorTotal,
      'vendor_quantity': vendorQuantity,
      'product_name': productName,
      'product_image': productImage,
      'created_at': createdAt,
    };
  }

  // ============================================================
  // Safe String Parser
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  // ============================================================
  // Safe Int Parser
  // ============================================================

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

  // ============================================================
  // Safe Num Parser
  // ============================================================

  static num? _parseNum(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }
}
