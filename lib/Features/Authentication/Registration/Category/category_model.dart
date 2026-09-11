class CategoryModel {
  const CategoryModel({this.success, this.categories = const []});

  // ============================================================
  // Response Fields
  // ============================================================

  final bool? success;
  final List<CategoryItemModel> categories;

  // ============================================================
  // From JSON
  // ============================================================

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      success: json['success'] as bool?,
      categories: _parseCategories(json['categories']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }

  // ============================================================
  // Safe Categories Parsing
  // ============================================================

  static List<CategoryItemModel> _parseCategories(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => CategoryItemModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}

// ============================================================
// Category Item Model
// ============================================================

class CategoryItemModel {
  const CategoryItemModel({
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

  // ============================================================
  // Fields
  // ============================================================

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

  // ============================================================
  // From JSON
  // ============================================================

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: _parseInt(json['id']),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      parentId: _parseInt(json['parent_id']),
      productCount: _parseInt(json['product_count']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

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

  // ============================================================
  // Safe Integer Parsing
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
