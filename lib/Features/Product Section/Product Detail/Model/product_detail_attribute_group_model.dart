import 'product_detail_attribute_group_value_model.dart';

class ProductDetailAttributeGroupModel {
  const ProductDetailAttributeGroupModel({
    this.attributeId,
    this.name,
    this.values = const [],
  });

  final int? attributeId;
  final String? name;

  final List<ProductDetailAttributeGroupValueModel> values;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailAttributeGroupModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const ProductDetailAttributeGroupModel();
    }

    return ProductDetailAttributeGroupModel(
      attributeId: _parseInt(json['attribute_id']),
      name: json['name']?.toString(),
      values: _parseList(
        json['values'],
        ProductDetailAttributeGroupValueModel.fromJson,
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'name': name,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

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
