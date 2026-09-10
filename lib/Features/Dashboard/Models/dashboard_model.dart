import 'dashboard_merchant_model.dart';
import 'dashboard_order_model.dart';
import 'dashboard_product_access_model.dart';
import 'dashboard_product_model.dart';
import 'dashboard_stats_model.dart';

class DashboardModel {
  const DashboardModel({
    this.success = false,
    this.merchant,
    this.stats,
    this.ordersByStatus = const {},
    this.recentOrders = const [],
    this.recentProducts = const [],
    this.productAccess,
  });

  final bool success;
  final DashboardMerchantModel? merchant;
  final DashboardStatsModel? stats;
  final Map<String, int> ordersByStatus;
  final List<DashboardOrderModel> recentOrders;
  final List<DashboardProductModel> recentProducts;
  final DashboardProductAccessModel? productAccess;

  factory DashboardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardModel();
    }

    return DashboardModel(
      success: _parseBool(json['success']),
      merchant: json['merchant'] is Map
          ? DashboardMerchantModel.fromJson(
              Map<String, dynamic>.from(json['merchant'] as Map),
            )
          : null,
      stats: json['stats'] is Map
          ? DashboardStatsModel.fromJson(
              Map<String, dynamic>.from(json['stats'] as Map),
            )
          : null,
      ordersByStatus: _parseIntMap(json['orders_by_status']),
      recentOrders: _parseList(
        json['recent_orders'],
        DashboardOrderModel.fromJson,
      ),
      recentProducts: _parseList(
        json['recent_products'],
        DashboardProductModel.fromJson,
      ),
      productAccess: json['product_access'] is Map
          ? DashboardProductAccessModel.fromJson(
              Map<String, dynamic>.from(json['product_access'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'merchant': merchant?.toJson(),
      'stats': stats?.toJson(),
      'orders_by_status': ordersByStatus,
      'recent_orders': recentOrders.map((e) => e.toJson()).toList(),
      'recent_products': recentProducts.map((e) => e.toJson()).toList(),
      'product_access': productAccess?.toJson(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static Map<String, int> _parseIntMap(dynamic value) {
    if (value is! Map) return const {};

    final result = <String, int>{};

    value.forEach((key, value) {
      if (key == null) return;

      final parsed = _parseInt(value);

      if (parsed != null) {
        result[key.toString()] = parsed;
      }
    });

    return result;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
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
}
