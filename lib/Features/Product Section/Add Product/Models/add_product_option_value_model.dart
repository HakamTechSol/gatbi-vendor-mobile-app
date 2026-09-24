class AddProductOptionValueModel {
  const AddProductOptionValueModel({
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

  factory AddProductOptionValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddProductOptionValueModel();
    }

    return AddProductOptionValueModel(
      attributeId: _parseInt(json['attribute_id']),
      attribute: _parseString(json['attribute']),
      attributeValueId: _parseInt(json['attribute_value_id']),
      value: _parseString(json['value']),
      code: _parseString(json['code']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'attribute': attribute,
      'attribute_value_id': attributeValueId,
      'value': value,
      'code': code,
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
}
