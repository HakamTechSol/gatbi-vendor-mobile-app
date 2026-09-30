class AddVariantModel {
  const AddVariantModel({this.success = false, this.message, this.value});

  final bool success;
  final String? message;
  final AddVariantValueModel? value;

  // ============================================================
  // From JSON
  // ============================================================

  factory AddVariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddVariantModel();
    }

    return AddVariantModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      value: json['value'] is Map
          ? AddVariantValueModel.fromJson(
              Map<String, dynamic>.from(json['value'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'value': value?.toJson()};
  }

  // ============================================================
  // Parse Bool
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

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }
}

// ============================================================
// Add Variant Value Model
// ============================================================

class AddVariantValueModel {
  const AddVariantValueModel({
    this.id,
    this.attributeId,
    this.value,
    this.code,
    this.sortOrder,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? attributeId;
  final String? value;
  final String? code;
  final int? sortOrder;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory AddVariantValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddVariantValueModel();
    }

    return AddVariantValueModel(
      id: _parseInt(json['id']),
      attributeId: _parseInt(json['attribute_id']),
      value: _parseString(json['value']),
      code: _parseString(json['code']),
      sortOrder: _parseInt(json['sort_order']),
      isActive: _parseBool(json['is_active']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_id': attributeId,
      'value': value,
      'code': code,
      'sort_order': sortOrder,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // Parse Int
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

  // ============================================================
  // Parse Bool
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

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }
}
