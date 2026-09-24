class ProductOptionBrandModel {
  const ProductOptionBrandModel({this.id, this.name});

  final int? id;
  final String? name;

  factory ProductOptionBrandModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductOptionBrandModel();
    }

    return ProductOptionBrandModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
