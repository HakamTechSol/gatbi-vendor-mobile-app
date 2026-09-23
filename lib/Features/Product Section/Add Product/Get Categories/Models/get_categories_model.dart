class GetCategoriesModel {
  const GetCategoriesModel({
    this.success = false,
    this.categories = const [],
  });

  final bool success;
  final List<GetCategoryModel> categories;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetCategoriesModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetCategoriesModel();
    }

    return GetCategoriesModel(
      success: _parseBool(json['success']),
      categories: _parseList(
        json['categories'],
        GetCategoryModel.fromJson,
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}


// ============================================================
// Get Category Model
// ============================================================

class GetCategoryModel {
  const GetCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.parentId,
    this.children = const [],
  });

  final int? id;
  final String? name;
  final String? slug;
  final int? parentId;
  final List<GetCategoryModel> children;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetCategoryModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetCategoryModel();
    }

    return GetCategoryModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      parentId: _parseInt(json['parent_id']),
      children: _parseList(
        json['children'],
        GetCategoryModel.fromJson,
      ),
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
      'parent_id': parentId,
      'children': children.map((e) => e.toJson()).toList(),
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}