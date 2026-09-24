class AddProductAttributeValueModel {
  const AddProductAttributeValueModel({
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

  final num? priceModifier;

  factory AddProductAttributeValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddProductAttributeValueModel();
    }

    return AddProductAttributeValueModel(
      id: _parseInt(json['id']),
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: _parseString(json['value']),
      code: _parseString(json['code']),
      priceModifier: _parseNum(json['price_modifier']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_value_id': attributeValueId,
      'value': value,
      'code': code,
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
