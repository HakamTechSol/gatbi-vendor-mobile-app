class AddProductAttributeGroupValueModel {
  const AddProductAttributeGroupValueModel({
    this.attributeValueId,
    this.value,
    this.priceModifier,
  });

  final int? attributeValueId;
  final String? value;
  final num? priceModifier;

  factory AddProductAttributeGroupValueModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const AddProductAttributeGroupValueModel();
    }

    return AddProductAttributeGroupValueModel(
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: _parseString(json['value']),
      priceModifier: _parseNum(json['price_modifier']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_value_id': attributeValueId,
      'value': value,
      'price_modifier': priceModifier,
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

  static num? _parseNum(dynamic value) {
    if (value is num) return value;

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    return value.toString();
  }
}
