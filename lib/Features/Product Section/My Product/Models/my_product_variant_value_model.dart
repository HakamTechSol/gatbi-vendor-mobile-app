class MyProductVariantValueModel {
  const MyProductVariantValueModel({
    this.id,
    this.name,
    this.value,
    this.attributeId,
    this.attributeValueId,
    this.priceModifier,
  });

  final int? id;
  final String? name;
  final String? value;
  final int? attributeId;
  final int? attributeValueId;
  final double? priceModifier;

  factory MyProductVariantValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductVariantValueModel();
    }

    return MyProductVariantValueModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      value: _parseString(json['value']),
      attributeId: _parseInt(json['attribute_id']),
      attributeValueId: _parseInt(json['attribute_value_id']),
      priceModifier: _parseDouble(json['price_modifier']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'attribute_id': attributeId,
      'attribute_value_id': attributeValueId,
      'price_modifier': priceModifier,
    };
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
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
