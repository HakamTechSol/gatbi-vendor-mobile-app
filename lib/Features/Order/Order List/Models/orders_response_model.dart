import 'order_model.dart';
import 'orders_pagination_model.dart';
class VendorOrdersResponseModel {
  const VendorOrdersResponseModel({
    this.success = false,
    this.orders = const [],
    this.pagination,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final List<VendorOrderModel> orders;
  final VendorOrdersPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrdersResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrdersResponseModel();
    }

    return VendorOrdersResponseModel(
      success: _parseBool(json['success']),
      orders: _parseOrders(json['orders']),
      pagination: json['pagination'] is Map
          ? VendorOrdersPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'orders': orders.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Safe Bool Parser
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  // ============================================================
  // Safe Orders List Parser
  // ============================================================

  static List<VendorOrderModel> _parseOrders(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => VendorOrderModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
