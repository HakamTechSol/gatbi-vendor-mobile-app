import 'analytics_insight_model.dart';
import 'analytics_stat_model.dart';
import 'top_product_model.dart';

class AnalyticsModel {
  const AnalyticsModel({
    this.totalOrders = 0,
    this.todayOrders = 0,
    this.paidOrders = 0,
    this.pendingOrders = 0,
    this.netSales = 0,
    this.grossSales = 0,
    this.commission = 0,
    this.totalProducts = 0,
    this.activeProducts = 0,
    this.stats = const [],
    this.topProducts = const [],
    this.insights = const [],
    this.currency = 'AED',
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDERS
  // ═══════════════════════════════════════════════════════════════════════════

  final int totalOrders;
  final int todayOrders;
  final int paidOrders;
  final int pendingOrders;

  // ═══════════════════════════════════════════════════════════════════════════
  // SALES
  // ═══════════════════════════════════════════════════════════════════════════

  final double netSales;
  final double grossSales;
  final double commission;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  final int totalProducts;
  final int activeProducts;

  // ═══════════════════════════════════════════════════════════════════════════
  // UI DATA
  // ═══════════════════════════════════════════════════════════════════════════

  final List<AnalyticsStatModel> stats;

  final List<TopProductModel> topProducts;

  final List<AnalyticsInsightModel> insights;

  final String currency;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  bool get hasTopProducts => topProducts.isNotEmpty;

  bool get hasInsights => insights.isNotEmpty;

  bool get hasData {
    return totalOrders > 0 ||
        netSales > 0 ||
        grossSales > 0 ||
        commission > 0 ||
        totalProducts > 0 ||
        topProducts.isNotEmpty;
  }

  bool get isEmpty => !hasData;

  // ═══════════════════════════════════════════════════════════════════════════
  // COPY WITH
  // ═══════════════════════════════════════════════════════════════════════════

  AnalyticsModel copyWith({
    int? totalOrders,
    int? todayOrders,
    int? paidOrders,
    int? pendingOrders,
    double? netSales,
    double? grossSales,
    double? commission,
    int? totalProducts,
    int? activeProducts,
    List<AnalyticsStatModel>? stats,
    List<TopProductModel>? topProducts,
    List<AnalyticsInsightModel>? insights,
    String? currency,
  }) {
    return AnalyticsModel(
      totalOrders: totalOrders ?? this.totalOrders,
      todayOrders: todayOrders ?? this.todayOrders,
      paidOrders: paidOrders ?? this.paidOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      netSales: netSales ?? this.netSales,
      grossSales: grossSales ?? this.grossSales,
      commission: commission ?? this.commission,
      totalProducts: totalProducts ?? this.totalProducts,
      activeProducts: activeProducts ?? this.activeProducts,
      stats: stats ?? this.stats,
      topProducts: topProducts ?? this.topProducts,
      insights: insights ?? this.insights,
      currency: currency ?? this.currency,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FROM JSON
  // ═══════════════════════════════════════════════════════════════════════════

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalOrders: _parseInt(json['total_orders'] ?? json['totalOrders']),
      todayOrders: _parseInt(json['today_orders'] ?? json['todayOrders']),
      paidOrders: _parseInt(json['paid_orders'] ?? json['paidOrders']),
      pendingOrders: _parseInt(json['pending_orders'] ?? json['pendingOrders']),
      netSales: _parseDouble(json['net_sales'] ?? json['netSales']),
      grossSales: _parseDouble(json['gross_sales'] ?? json['grossSales']),
      commission: _parseDouble(json['commission']),
      totalProducts: _parseInt(json['total_products'] ?? json['totalProducts']),
      activeProducts: _parseInt(
        json['active_products'] ?? json['activeProducts'],
      ),
      stats: _parseStats(json['stats']),
      topProducts: _parseTopProducts(
        json['top_products'] ?? json['topProducts'],
      ),
      insights: _parseInsights(json['insights']),
      currency: json['currency']?.toString() ?? 'AED',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TO JSON
  // ═══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'today_orders': todayOrders,
      'paid_orders': paidOrders,
      'pending_orders': pendingOrders,
      'net_sales': netSales,
      'gross_sales': grossSales,
      'commission': commission,
      'total_products': totalProducts,
      'active_products': activeProducts,
      'stats': stats.map((item) => item.toJson()).toList(),
      'top_products': topProducts.map((item) => item.toJson()).toList(),
      'insights': insights.map((item) => item.toJson()).toList(),
      'currency': currency,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // JSON HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<AnalyticsStatModel> _parseStats(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) =>
              AnalyticsStatModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static List<TopProductModel> _parseTopProducts(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => TopProductModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static List<AnalyticsInsightModel> _parseInsights(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) =>
              AnalyticsInsightModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
