import 'product_detail_attribute_value_model.dart';

class ProductDetailAttributeModel {
  const ProductDetailAttributeModel({
    this.id,
    this.attributeId,
    this.name,
    this.inputType,
    this.isRequired = false,
    this.displayOrder,
    this.values = const [],
  });

  final int? id;
  final int? attributeId;

  final String? name;
  final String? inputType;

  final bool isRequired;

  final int? displayOrder;

  final List<ProductDetailAttributeValueModel> values;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailAttributeModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const ProductDetailAttributeModel();
    }

    return ProductDetailAttributeModel(
      id: _parseInt(json['id']),
      attributeId: _parseInt(json['attribute_id']),
      name: json['name']?.toString(),
      inputType: json['input_type']?.toString(),
      isRequired: _parseBool(json['is_required']),
      displayOrder: _parseInt(json['display_order']),
      values: _parseList(
        json['values'],
        ProductDetailAttributeValueModel.fromJson,
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_id': attributeId,
      'name': name,
      'input_type': inputType,
      'is_required': isRequired,
      'display_order': displayOrder,
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
        .map(
          (item) => fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
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