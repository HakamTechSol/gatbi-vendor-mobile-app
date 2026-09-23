import 'my_product_attribute_value_model.dart';

class MyProductAttributeGroupModel {
  const MyProductAttributeGroupModel({
    this.attributeId,
    this.name,
    this.values = const [],
  });

  final int? attributeId;
  final String? name;
  final List<MyProductAttributeValueModel> values;

  factory MyProductAttributeGroupModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductAttributeGroupModel();
    }

    return MyProductAttributeGroupModel(
      attributeId: _parseInt(json['attribute_id']),
      name: _parseString(json['name']),
      values: _parseList(json['values'], MyProductAttributeValueModel.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'name': name,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }

  static List<MyProductAttributeValueModel> _parseList(
    dynamic value,
    MyProductAttributeValueModel Function(Map<String, dynamic>) fromJson,
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}
