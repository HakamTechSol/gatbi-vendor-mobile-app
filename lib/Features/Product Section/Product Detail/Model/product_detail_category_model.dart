class ProductDetailCategoryModel {
  const ProductDetailCategoryModel({this.id, this.name});

  final int? id;
  final String? name;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailCategoryModel();
    }

    return ProductDetailCategoryModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  // ============================================================
  // Helpers
  // ============================================================

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
}
