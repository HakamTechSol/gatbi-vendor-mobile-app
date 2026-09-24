class ProductOptionCategoryModel {
  const ProductOptionCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.icon,
    this.image,
    this.parentId,
    this.productCount,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? icon;
  final String? image;
  final int? parentId;
  final int? productCount;
  final String? createdAt;
  final String? updatedAt;

  factory ProductOptionCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductOptionCategoryModel();
    }

    return ProductOptionCategoryModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      description: _parseString(json['description']),
      icon: _parseString(json['icon']),
      image: _parseString(json['image']),
      parentId: _parseInt(json['parent_id']),
      productCount: _parseInt(json['product_count']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'image': image,
      'parent_id': parentId,
      'product_count': productCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
