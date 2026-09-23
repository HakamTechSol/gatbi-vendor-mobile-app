class MyProductAttributeValueModel {
  const MyProductAttributeValueModel({
    this.attributeValueId,
    this.value,
    this.priceModifier,
  });

  final int? attributeValueId;
  final String? value;
  final double? priceModifier;

  factory MyProductAttributeValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductAttributeValueModel();
    }

    return MyProductAttributeValueModel(
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: _parseString(json['value']),
      priceModifier: _parseDouble(json['price_modifier']),
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
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
