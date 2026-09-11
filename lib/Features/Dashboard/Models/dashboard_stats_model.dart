class DashboardStatsModel {
  const DashboardStatsModel({
    this.totalProducts = 0,
    this.activeProducts = 0,
    this.totalOrders = 0,

    this.vendorGross = 0,
    this.vendorShippingTotal = 0,
    this.vendorCommission = 0,
    this.vendorNet = 0,

    this.commissionRateDisplay = 0,
    this.commissionRate = 0,

    this.affiliateCommissionRateDisplay = 0,
    this.affiliateAllowed = 0,
    this.affiliateBlocked = 0,

    this.monthlyRevenueProducts = 0,
    this.monthlyRevenueCommission = 0,

    this.totalRevenue = 0,
    this.pendingOrders = 0,
    this.lowStock = 0,
    this.outOfStock = 0,
    this.monthlyRevenue = 0,
    this.ordersToday = 0,
  });

  // ------------------------------------------------------------
  // Basic Stats
  // ------------------------------------------------------------

  final int totalProducts;
  final int activeProducts;
  final int totalOrders;

  // ------------------------------------------------------------
  // Vendor Revenue / Commission Stats
  // ------------------------------------------------------------

  final double vendorGross;
  final double vendorShippingTotal;
  final double vendorCommission;
  final double vendorNet;

  // ------------------------------------------------------------
  // Commission Stats
  // ------------------------------------------------------------

  final double commissionRateDisplay;
  final double commissionRate;

  final double affiliateCommissionRateDisplay;

  final int affiliateAllowed;
  final int affiliateBlocked;

  // ------------------------------------------------------------
  // Monthly Revenue Breakdown
  // ------------------------------------------------------------

  final double monthlyRevenueProducts;
  final double monthlyRevenueCommission;

  // ------------------------------------------------------------
  // Existing Revenue / Order Stats
  // ------------------------------------------------------------

  final double totalRevenue;
  final int pendingOrders;
  final int lowStock;
  final int outOfStock;
  final double monthlyRevenue;
  final int ordersToday;

  factory DashboardStatsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardStatsModel();
    }

    return DashboardStatsModel(
      // Basic stats
      totalProducts: _parseInt(json['total_products']) ?? 0,
      activeProducts: _parseInt(json['active_products']) ?? 0,
      totalOrders: _parseInt(json['total_orders']) ?? 0,

      // Vendor revenue
      vendorGross: _parseDouble(json['vendor_gross']) ?? 0,
      vendorShippingTotal: _parseDouble(json['vendor_shipping_total']) ?? 0,
      vendorCommission: _parseDouble(json['vendor_commission']) ?? 0,
      vendorNet: _parseDouble(json['vendor_net']) ?? 0,

      // Commission
      commissionRateDisplay: _parseDouble(json['commission_rate_display']) ?? 0,
      commissionRate: _parseDouble(json['commission_rate']) ?? 0,

      affiliateCommissionRateDisplay:
          _parseDouble(json['affiliate_commission_rate_display']) ?? 0,

      affiliateAllowed: _parseInt(json['affiliate_allowed']) ?? 0,
      affiliateBlocked: _parseInt(json['affiliate_blocked']) ?? 0,

      // Monthly revenue breakdown
      monthlyRevenueProducts:
          _parseDouble(json['monthly_revenue_products']) ?? 0,
      monthlyRevenueCommission:
          _parseDouble(json['monthly_revenue_commission']) ?? 0,

      // Existing stats
      totalRevenue: _parseDouble(json['total_revenue']) ?? 0,
      pendingOrders: _parseInt(json['pending_orders']) ?? 0,
      lowStock: _parseInt(json['low_stock']) ?? 0,
      outOfStock: _parseInt(json['out_of_stock']) ?? 0,
      monthlyRevenue: _parseDouble(json['monthly_revenue']) ?? 0,
      ordersToday: _parseInt(json['orders_today']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Basic stats
      'total_products': totalProducts,
      'active_products': activeProducts,
      'total_orders': totalOrders,

      // Vendor revenue
      'vendor_gross': vendorGross,
      'vendor_shipping_total': vendorShippingTotal,
      'vendor_commission': vendorCommission,
      'vendor_net': vendorNet,

      // Commission
      'commission_rate_display': commissionRateDisplay,
      'commission_rate': commissionRate,
      'affiliate_commission_rate_display': affiliateCommissionRateDisplay,
      'affiliate_allowed': affiliateAllowed,
      'affiliate_blocked': affiliateBlocked,

      // Monthly revenue breakdown
      'monthly_revenue_products': monthlyRevenueProducts,
      'monthly_revenue_commission': monthlyRevenueCommission,

      // Existing stats
      'total_revenue': totalRevenue,
      'pending_orders': pendingOrders,
      'low_stock': lowStock,
      'out_of_stock': outOfStock,
      'monthly_revenue': monthlyRevenue,
      'orders_today': ordersToday,
    };
  }

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
}
