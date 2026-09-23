class ProductArabicTranslatorModel {
  const ProductArabicTranslatorModel({
    this.success = false,
    this.message,
    this.translation,
  });

  final bool success;
  final String? message;
  final ProductArabicTranslationModel? translation;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProductArabicTranslatorModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductArabicTranslatorModel();
    }

    return ProductArabicTranslatorModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      translation: json['translation'] is Map
          ? ProductArabicTranslationModel.fromJson(
              Map<String, dynamic>.from(json['translation'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'translation': translation?.toJson(),
    };
  }

  // ============================================================
  // PARSERS
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString();

    if (text.trim().isEmpty) {
      return null;
    }

    return text;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TRANSLATION
// ═══════════════════════════════════════════════════════════════════════════

class ProductArabicTranslationModel {
  const ProductArabicTranslationModel({
    this.productId,
    this.sourceLocale,
    this.targetLocale,
    this.translated,
  });

  final int? productId;
  final String? sourceLocale;
  final String? targetLocale;
  final ProductArabicTranslatedModel? translated;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProductArabicTranslationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductArabicTranslationModel();
    }

    return ProductArabicTranslationModel(
      productId: _parseInt(json['product_id']),
      sourceLocale: _parseString(json['source_locale']),
      targetLocale: _parseString(json['target_locale']),
      translated: json['translated'] is Map
          ? ProductArabicTranslatedModel.fromJson(
              Map<String, dynamic>.from(json['translated'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'source_locale': sourceLocale,
      'target_locale': targetLocale,
      'translated': translated?.toJson(),
    };
  }

  // ============================================================
  // PARSERS
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString();

    if (text.trim().isEmpty) {
      return null;
    }

    return text;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TRANSLATED FIELDS
// ═══════════════════════════════════════════════════════════════════════════

class ProductArabicTranslatedModel {
  const ProductArabicTranslatedModel({
    this.name,
    this.shortDescription,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
  });

  final String? name;
  final String? shortDescription;
  final String? description;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProductArabicTranslatedModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductArabicTranslatedModel();
    }

    return ProductArabicTranslatedModel(
      name: _parseString(json['name']),
      shortDescription: _parseString(json['short_description']),
      description: _parseString(json['description']),
      metaTitle: _parseString(json['meta_title']),
      metaDescription: _parseString(json['meta_description']),
      metaKeywords: _parseString(json['meta_keywords']),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'short_description': shortDescription,
      'description': description,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,
    };
  }

  // ============================================================
  // PARSER
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString();

    if (text.trim().isEmpty) {
      return null;
    }

    return text;
  }
}
