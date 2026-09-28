class QuestionProductModel {
  const QuestionProductModel({this.id, this.name, this.slug});

  // ============================================================
  // Product Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? slug;

  // ============================================================
  // From JSON
  // ============================================================

  factory QuestionProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuestionProductModel();
    }

    return QuestionProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }

  // ============================================================
  // Parse Int
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

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
