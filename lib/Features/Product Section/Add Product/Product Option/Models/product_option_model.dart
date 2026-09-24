import 'product_option_brand_model.dart';
import 'product_option_category_model.dart';

class ProductOptionModel {
  const ProductOptionModel({
    this.success = false,
    this.categories = const [],
    this.brands = const [],
  });

  final bool success;
  final List<ProductOptionCategoryModel> categories;
  final List<ProductOptionBrandModel> brands;

  factory ProductOptionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductOptionModel();
    }

    final options = json['options'] is Map
        ? Map<String, dynamic>.from(json['options'] as Map)
        : <String, dynamic>{};

    return ProductOptionModel(
      success: _parseBool(json['success']),
      categories: _parseList(
        options['categories'],
        ProductOptionCategoryModel.fromJson,
      ),
      brands: _parseList(options['brands'], ProductOptionBrandModel.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'options': {
        'categories': categories.map((e) => e.toJson()).toList(),
        'brands': brands.map((e) => e.toJson()).toList(),
      },
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is num) return value != 0;
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
