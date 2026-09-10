class DashboardStatsModel {
  const DashboardStatsModel({
    this.totalProducts = 0,
    this.activeProducts = 0,
    this.totalOrders = 0,
    this.totalRevenue = 0,
    this.pendingOrders = 0,
    this.lowStock = 0,
    this.outOfStock = 0,
    this.monthlyRevenue = 0,
    this.ordersToday = 0,
  });

  final int totalProducts;
  final int activeProducts;
  final int totalOrders;
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
      totalProducts: _parseInt(json['total_products']) ?? 0,
      activeProducts: _parseInt(json['active_products']) ?? 0,
      totalOrders: _parseInt(json['total_orders']) ?? 0,
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
      'total_products': totalProducts,
      'active_products': activeProducts,
      'total_orders': totalOrders,
      'total_revenue': totalRevenue,
      'pending_orders': pendingOrders,
      'low_stock': lowStock,
      'out_of_stock': outOfStock,
      'monthly_revenue': monthlyRevenue,
      'orders_today': ordersToday,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
