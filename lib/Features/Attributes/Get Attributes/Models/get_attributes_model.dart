class GetAttributesModel {
  const GetAttributesModel({this.success = false, this.attributes = const []});

  final bool success;
  final List<GetAttributeModel> attributes;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetAttributesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetAttributesModel();
    }

    return GetAttributesModel(
      success: _parseBool(json['success']),
      attributes: _parseList(json['attributes'], GetAttributeModel.fromJson),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'attributes': attributes.map((e) => e.toJson()).toList(),
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
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

// ============================================================
// Get Attribute Model
// ============================================================

class GetAttributeModel {
  const GetAttributeModel({
    this.id,
    this.name,
    this.adminLabel,
    this.slug,
    this.inputType,
    this.isOwn = false,
    this.values = const [],
  });

  final int? id;
  final String? name;
  final String? adminLabel;
  final String? slug;
  final String? inputType;
  final bool isOwn;
  final List<GetAttributeValueModel> values;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetAttributeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetAttributeModel();
    }

    return GetAttributeModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      adminLabel: _parseString(json['admin_label']),
      slug: _parseString(json['slug']),
      inputType: _parseString(json['input_type']),
      isOwn: _parseBool(json['is_own']),
      values: _parseList(json['values'], GetAttributeValueModel.fromJson),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'admin_label': adminLabel,
      'slug': slug,
      'input_type': inputType,
      'is_own': isOwn,
      'values': values.map((e) => e.toJson()).toList(),
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
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

// ============================================================
// Get Attribute Value Model
// ============================================================

class GetAttributeValueModel {
  const GetAttributeValueModel({
    this.id,
    this.value,
    this.code,
    this.sortOrder,
  });

  final int? id;
  final String? value;
  final String? code;
  final int? sortOrder;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetAttributeValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetAttributeValueModel();
    }

    return GetAttributeValueModel(
      id: _parseInt(json['id']),
      value: _parseString(json['value']),
      code: _parseString(json['code']),
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'id': id, 'value': value, 'code': code, 'sort_order': sortOrder};
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
}
