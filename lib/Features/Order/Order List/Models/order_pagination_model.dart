import 'order_model.dart';

class OrderPaginationModel {
  const OrderPaginationModel({
    required this.orders,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  final List<OrderModel> orders;

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  final bool hasMore;

  factory OrderPaginationModel.fromJson(Map<String, dynamic> json) {
    final rawOrders = json['orders'] ?? json['data'];

    final orders = rawOrders is List
        ? rawOrders
              .whereType<Map>()
              .map(
                (item) => OrderModel.fromJson(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList()
        : <OrderModel>[];

    final meta = json['meta'] is Map
        ? (json['meta'] as Map).cast<String, dynamic>()
        : json;

    return OrderPaginationModel(
      orders: orders,
      currentPage: _parseInt(
        meta['current_page'] ?? meta['page'],
        fallback: 1,
      ),
      perPage: _parseInt(
        meta['per_page'] ?? meta['perPage'],
        fallback: 20,
      ),
      total: _parseInt(meta['total']),
      lastPage: _parseInt(
        meta['last_page'] ?? meta['lastPage'],
        fallback: 1,
      ),
      hasMore: _parseBool(
        meta['has_more'] ?? meta['hasMore'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toJson()).toList(),
      'meta': {
        'current_page': currentPage,
        'per_page': perPage,
        'total': total,
        'last_page': lastPage,
        'has_more': hasMore,
      },
    };
  }

  OrderPaginationModel copyWith({
    List<OrderModel>? orders,
    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
    bool? hasMore,
  }) {
    return OrderPaginationModel(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  static int _parseInt(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is num) {
      return value != 0;
    }

    switch (value?.toString().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
        return true;
      default:
        return false;
    }
  }
}