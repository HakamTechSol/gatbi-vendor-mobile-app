import 'my_product_model.dart';
import 'my_products_pagination_model.dart';

class MainMyProductModel {
  const MainMyProductModel({
    this.success = false,
    this.products = const [],
    this.pagination = const MyProductsPaginationModel(),
  });

  final bool success;
  final List<MyProductModel> products;
  final MyProductsPaginationModel pagination;

  factory MainMyProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MainMyProductModel();
    }

    return MainMyProductModel(
      success: _parseBool(json['success']),
      products: _parseProducts(json['products']),
      pagination: json['pagination'] is Map
          ? MyProductsPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : const MyProductsPaginationModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'products': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  static List<MyProductModel> _parseProducts(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => MyProductModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
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
}
