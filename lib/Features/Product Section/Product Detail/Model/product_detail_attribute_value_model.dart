class ProductDetailAttributeValueModel {
  const ProductDetailAttributeValueModel({
    this.id,
    this.attributeValueId,
    this.value,
    this.code,
    this.priceModifier,
  });

  final int? id;
  final int? attributeValueId;

  final String? value;
  final String? code;

  final double? priceModifier;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailAttributeValueModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const ProductDetailAttributeValueModel();
    }

    return ProductDetailAttributeValueModel(
      id: _parseInt(json['id']),
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: json['value']?.toString(),
      code: json['code']?.toString(),
      priceModifier: _parseDouble(json['price_modifier']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_value_id': attributeValueId,
      'value': value,
      'code': code,
      'price_modifier': priceModifier,
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
