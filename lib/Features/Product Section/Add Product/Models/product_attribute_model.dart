class ProductAttributeModel {
  const ProductAttributeModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.values = const [],
  });

  final int id;
  final String name;
  final String? nameAr;
  final List<String> values;

  ProductAttributeModel copyWith({
    int? id,
    String? name,
    String? nameAr,
    List<String>? values,
  }) {
    return ProductAttributeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      values: values ?? this.values,
    );
  }

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      nameAr: json['name_ar']?.toString(),
      values: _parseStringList(json['values']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      'values': values,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const [];

    return value
        .map((item) => item?.toString() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
