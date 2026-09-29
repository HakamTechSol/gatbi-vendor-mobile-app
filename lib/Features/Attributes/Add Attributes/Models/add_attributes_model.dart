class AddAttributesModel {
  const AddAttributesModel({
    this.success = false,
    this.message,
    this.attribute,
  });

  final bool success;
  final String? message;
  final AddAttributeModel? attribute;

  // ============================================================
  // From JSON
  // ============================================================

  factory AddAttributesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddAttributesModel();
    }

    return AddAttributesModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      attribute: json['attribute'] is Map
          ? AddAttributeModel.fromJson(
              Map<String, dynamic>.from(json['attribute'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'attribute': attribute?.toJson(),
    };
  }

  // ============================================================
  // Parsers
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }
}

// ============================================================
// Created Attribute Model
// ============================================================

class AddAttributeModel {
  const AddAttributeModel({
    this.id,
    this.name,
    this.adminLabel,
    this.slug,
    this.inputType,
    this.merchantId,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? adminLabel;
  final String? slug;
  final String? inputType;
  final int? merchantId;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory AddAttributeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddAttributeModel();
    }

    return AddAttributeModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      adminLabel: _parseString(json['admin_label']),
      slug: _parseString(json['slug']),
      inputType: _parseString(json['input_type']),
      merchantId: _parseInt(json['merchant_id']),
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
      'name': name,
      'admin_label': adminLabel,
      'slug': slug,
      'input_type': inputType,
      'merchant_id': merchantId,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // Parsers
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }
}
