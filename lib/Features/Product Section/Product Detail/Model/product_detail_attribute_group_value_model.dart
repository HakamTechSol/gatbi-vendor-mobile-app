class ProductDetailAttributeGroupValueModel {
  const ProductDetailAttributeGroupValueModel({
    this.attributeValueId,
    this.value,
    this.priceModifier,
  });

  final int? attributeValueId;
  final String? value;
  final double? priceModifier;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailAttributeGroupValueModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const ProductDetailAttributeGroupValueModel();
    }

    return ProductDetailAttributeGroupValueModel(
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: json['value']?.toString(),
      priceModifier: _parseDouble(json['price_modifier']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'attribute_value_id': attributeValueId,
      'value': value,
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
