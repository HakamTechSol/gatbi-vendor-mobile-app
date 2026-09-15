class AnalyticsModel {
  const AnalyticsModel({
    this.success = false,
    this.merchant,
    this.dateRange,
    this.stats,
    this.topProducts = const [],
  });

  final bool success;
  final AnalyticsMerchantModel? merchant;
  final AnalyticsDateRangeModel? dateRange;
  final AnalyticsStatsModel? stats;
  final List<AnalyticsTopProductModel> topProducts;

  factory AnalyticsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AnalyticsModel();
    }

    return AnalyticsModel(
      success: _parseBool(json['success']),
      merchant: json['merchant'] is Map
          ? AnalyticsMerchantModel.fromJson(
              Map<String, dynamic>.from(json['merchant'] as Map),
            )
          : null,
      dateRange: json['date_range'] is Map
          ? AnalyticsDateRangeModel.fromJson(
              Map<String, dynamic>.from(json['date_range'] as Map),
            )
          : null,
      stats: json['stats'] is Map
          ? AnalyticsStatsModel.fromJson(
              Map<String, dynamic>.from(json['stats'] as Map),
            )
          : null,
      topProducts: _parseList(
        json['top_products'],
        AnalyticsTopProductModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'merchant': merchant?.toJson(),
      'date_range': dateRange?.toJson(),
      'stats': stats?.toJson(),
      'top_products': topProducts.map((e) => e.toJson()).toList(),
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
}

// ============================================================
// Analytics Merchant Model
// ============================================================

class AnalyticsMerchantModel {
  const AnalyticsMerchantModel({this.id, this.name, this.status});

  final int? id;
  final String? name;
  final String? status;

  factory AnalyticsMerchantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AnalyticsMerchantModel();
    }

    return AnalyticsMerchantModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      status: _parseString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'status': status};
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}

// ============================================================
// Analytics Date Range Model
// ============================================================

class AnalyticsDateRangeModel {
  const AnalyticsDateRangeModel({this.start, this.end});

  final String? start;
  final String? end;

  factory AnalyticsDateRangeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AnalyticsDateRangeModel();
    }

    return AnalyticsDateRangeModel(
      start: _parseString(json['start']),
      end: _parseString(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end};
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}

// ============================================================
// Analytics Stats Model
// ============================================================

class AnalyticsStatsModel {
  const AnalyticsStatsModel({
    this.totalProducts = 0,
    this.activeProducts = 0,
    this.totalOrders = 0,
    this.paidOrders = 0,
    this.grossSales = 0,
    this.commissionTotal = 0,
    this.netSales = 0,
    this.ordersToday = 0,
    this.pendingOrders = 0,
  });

  final int totalProducts;
  final int activeProducts;
  final int totalOrders;
  final int paidOrders;

  final double grossSales;
  final double commissionTotal;
  final double netSales;

  final int ordersToday;
  final int pendingOrders;

  factory AnalyticsStatsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AnalyticsStatsModel();
    }

    return AnalyticsStatsModel(
      totalProducts: _parseInt(json['total_products']) ?? 0,
      activeProducts: _parseInt(json['active_products']) ?? 0,
      totalOrders: _parseInt(json['total_orders']) ?? 0,
      paidOrders: _parseInt(json['paid_orders']) ?? 0,
      grossSales: _parseDouble(json['gross_sales']) ?? 0,
      commissionTotal: _parseDouble(json['commission_total']) ?? 0,
      netSales: _parseDouble(json['net_sales']) ?? 0,
      ordersToday: _parseInt(json['orders_today']) ?? 0,
      pendingOrders: _parseInt(json['pending_orders']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_products': totalProducts,
      'active_products': activeProducts,
      'total_orders': totalOrders,
      'paid_orders': paidOrders,
      'gross_sales': grossSales,
      'commission_total': commissionTotal,
      'net_sales': netSales,
      'orders_today': ordersToday,
      'pending_orders': pendingOrders,
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

// ============================================================
// Analytics Top Product Model
// ============================================================

class AnalyticsTopProductModel {
  const AnalyticsTopProductModel({
    this.id,
    this.name,
    this.slug,
    this.units = 0,
    this.revenue = 0,
  });

  final int? id;
  final String? name;
  final String? slug;

  final int units;
  final double revenue;

  factory AnalyticsTopProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AnalyticsTopProductModel();
    }

    return AnalyticsTopProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      units: _parseInt(json['units']) ?? 0,
      revenue: _parseDouble(json['revenue']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'units': units,
      'revenue': revenue,
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
