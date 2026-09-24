import 'add_product_attribute_group_value_model.dart';

class AddProductAttributeGroupModel {
  const AddProductAttributeGroupModel({
    this.attributeId,
    this.name,
    this.values = const [],
  });

  final int? attributeId;
  final String? name;

  final List<AddProductAttributeGroupValueModel> values;

  factory AddProductAttributeGroupModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddProductAttributeGroupModel();
    }

    return AddProductAttributeGroupModel(
      attributeId: _parseInt(json['attribute_id']),
      name: _parseString(json['name']),
      values: _parseList(
        json['values'],
        AddProductAttributeGroupValueModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'name': name,
      'values': values.map((e) => e.toJson()).toList(),
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

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
