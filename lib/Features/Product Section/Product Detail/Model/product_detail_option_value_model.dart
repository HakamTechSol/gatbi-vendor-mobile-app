class ProductDetailOptionValueModel {
  const ProductDetailOptionValueModel({
    this.attributeId,
    this.attribute,
    this.attributeValueId,
    this.value,
    this.code,
  });

  final int? attributeId;
  final String? attribute;

  final int? attributeValueId;
  final String? value;

  final String? code;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailOptionValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailOptionValueModel();
    }

    return ProductDetailOptionValueModel(
      attributeId: _parseInt(json['attribute_id']),
      attribute: json['attribute']?.toString(),
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: json['value']?.toString(),
      code: json['code']?.toString(),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'attribute': attribute,
      'attribute_value_id': attributeValueId,
      'value': value,
      'code': code,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

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
