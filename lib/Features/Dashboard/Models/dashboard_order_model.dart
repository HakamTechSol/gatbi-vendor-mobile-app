class DashboardOrderModel {
  const DashboardOrderModel({
    this.id,
    this.userId,
    this.affiliateId,
    this.affiliateCode,
    this.affiliateClickId,
    this.orderNumber,
    this.subtotal,
    this.shipping,
    this.tax,
    this.discount,
    this.couponCode,
    this.commissionRate,
    this.commissionTotal,
    this.affiliateCommissionTotal,
    this.total,
    this.currency,
    this.walletAmount,
    this.paymentSurcharge,
    this.paymentMethod,
    this.stripePaymentIntentId,
    this.checkoutcomPaymentId,
    this.paymenntPaymentId,
    this.tabbyPaymentId,
    this.tamaraPaymentId,
    this.paymentStatus,
    this.orderStatus,
    this.deliveredAt,
    this.shippingAddressId,
    this.billingAddressId,
    this.shippingMethodId,
    this.notes,
    this.paymentDetails,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
    this.userEmail,
  });

  final int? id;
  final int? userId;
  final int? affiliateId;
  final String? affiliateCode;
  final int? affiliateClickId;
  final String? orderNumber;

  final double? subtotal;
  final double? shipping;
  final double? tax;
  final double? discount;
  final String? couponCode;
  final double? commissionRate;
  final double? commissionTotal;
  final double? affiliateCommissionTotal;
  final double? total;

  final String? currency;
  final double? walletAmount;
  final double? paymentSurcharge;
  final String? paymentMethod;

  final String? stripePaymentIntentId;
  final String? checkoutcomPaymentId;
  final String? paymenntPaymentId;
  final String? tabbyPaymentId;
  final String? tamaraPaymentId;

  final String? paymentStatus;
  final String? orderStatus;

  final String? deliveredAt;
  final int? shippingAddressId;
  final int? billingAddressId;
  final int? shippingMethodId;
  final String? notes;
  final String? paymentDetails;
  final String? paidAt;
  final String? createdAt;
  final String? updatedAt;
  final String? userEmail;

  factory DashboardOrderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardOrderModel();
    }

    return DashboardOrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      affiliateId: _parseInt(json['affiliate_id']),
      affiliateCode: _parseString(json['affiliate_code']),
      affiliateClickId: _parseInt(json['affiliate_click_id']),
      orderNumber: _parseString(json['order_number']),
      subtotal: _parseDouble(json['subtotal']),
      shipping: _parseDouble(json['shipping']),
      tax: _parseDouble(json['tax']),
      discount: _parseDouble(json['discount']),
      couponCode: _parseString(json['coupon_code']),
      commissionRate: _parseDouble(json['commission_rate']),
      commissionTotal: _parseDouble(json['commission_total']),
      affiliateCommissionTotal:
          _parseDouble(json['affiliate_commission_total']),
      total: _parseDouble(json['total']),
      currency: _parseString(json['currency']),
      walletAmount: _parseDouble(json['wallet_amount']),
      paymentSurcharge: _parseDouble(json['payment_surcharge']),
      paymentMethod: _parseString(json['payment_method']),
      stripePaymentIntentId:
          _parseString(json['stripe_payment_intent_id']),
      checkoutcomPaymentId:
          _parseString(json['checkoutcom_payment_id']),
      paymenntPaymentId: _parseString(json['paymennt_payment_id']),
      tabbyPaymentId: _parseString(json['tabby_payment_id']),
      tamaraPaymentId: _parseString(json['tamara_payment_id']),
      paymentStatus: _parseString(json['payment_status']),
      orderStatus: _parseString(json['order_status']),
      deliveredAt: _parseString(json['delivered_at']),
      shippingAddressId: _parseInt(json['shipping_address_id']),
      billingAddressId: _parseInt(json['billing_address_id']),
      shippingMethodId: _parseInt(json['shipping_method_id']),
      notes: _parseString(json['notes']),
      paymentDetails: _parseString(json['payment_details']),
      paidAt: _parseString(json['paid_at']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      userEmail: _parseString(json['user_email']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'affiliate_id': affiliateId,
      'affiliate_code': affiliateCode,
      'affiliate_click_id': affiliateClickId,
      'order_number': orderNumber,
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'discount': discount,
      'coupon_code': couponCode,
      'commission_rate': commissionRate,
      'commission_total': commissionTotal,
      'affiliate_commission_total': affiliateCommissionTotal,
      'total': total,
      'currency': currency,
      'wallet_amount': walletAmount,
      'payment_surcharge': paymentSurcharge,
      'payment_method': paymentMethod,
      'stripe_payment_intent_id': stripePaymentIntentId,
      'checkoutcom_payment_id': checkoutcomPaymentId,
      'paymennt_payment_id': paymenntPaymentId,
      'tabby_payment_id': tabbyPaymentId,
      'tamara_payment_id': tamaraPaymentId,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'delivered_at': deliveredAt,
      'shipping_address_id': shippingAddressId,
      'billing_address_id': billingAddressId,
      'shipping_method_id': shippingMethodId,
      'notes': notes,
      'payment_details': paymentDetails,
      'paid_at': paidAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_email': userEmail,
    };
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) return value;

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) return value.toInt();

    if (value is String) return int.tryParse(value);

    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) return value.toDouble();

    if (value is String) return double.tryParse(value);

    return null;
  }
}