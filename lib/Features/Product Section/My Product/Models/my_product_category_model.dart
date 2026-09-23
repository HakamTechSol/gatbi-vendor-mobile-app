class MyProductCategoryModel {
  const MyProductCategoryModel({this.id, this.name});

  final int? id;
  final String? name;

  factory MyProductCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductCategoryModel();
    }

    return MyProductCategoryModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
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
