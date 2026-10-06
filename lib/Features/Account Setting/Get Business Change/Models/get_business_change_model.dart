class GetBusinessChangeModel {
  const GetBusinessChangeModel({
    this.success = false,
    this.lockedFields = const {},
    this.changeableFields = const [],
    this.allowedFileTypes = const [],
    this.maxFileSize,
    this.requests = const [],
  });

  final bool success;
  final Map<String, BusinessChangeLockedFieldModel> lockedFields;
  final List<String> changeableFields;
  final List<String> allowedFileTypes;
  final int? maxFileSize;
  final List<BusinessChangeRequestModel> requests;

  factory GetBusinessChangeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetBusinessChangeModel();
    }

    return GetBusinessChangeModel(
      success: _parseBool(json['success']),
      lockedFields: _parseLockedFields(json['locked_fields']),
      changeableFields: _parseStringList(json['changeable_fields']),
      allowedFileTypes: _parseStringList(json['allowed_file_types']),
      maxFileSize: _parseInt(json['max_file_size']),
      requests: _parseList(
        json['requests'],
        BusinessChangeRequestModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'locked_fields': lockedFields.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'changeable_fields': changeableFields,
      'allowed_file_types': allowedFileTypes,
      'max_file_size': maxFileSize,
      'requests': requests.map((e) => e.toJson()).toList(),
    };
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
  // Parse String List
  // ============================================================

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => item?.toString().trim())
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // ============================================================
  // Parse Locked Fields
  // ============================================================

  static Map<String, BusinessChangeLockedFieldModel> _parseLockedFields(
    dynamic value,
  ) {
    if (value is! Map) {
      return const {};
    }

    final result = <String, BusinessChangeLockedFieldModel>{};

    value.forEach((key, value) {
      if (key == null || value is! Map) {
        return;
      }

      result[key.toString()] = BusinessChangeLockedFieldModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    });

    return result;
  }

  // ============================================================
  // Parse List
  // ============================================================

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

// ============================================================================
// Locked Field Model
// ============================================================================

class BusinessChangeLockedFieldModel {
  const BusinessChangeLockedFieldModel({
    this.label,
    this.currentValue,
    this.options = const [],
    this.documentRequired = false,
  });

  final String? label;
  final String? currentValue;
  final List<String> options;
  final bool documentRequired;

  factory BusinessChangeLockedFieldModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BusinessChangeLockedFieldModel();
    }

    return BusinessChangeLockedFieldModel(
      label: _parseString(json['label']),
      currentValue: _parseString(json['current_value']),
      options: _parseStringList(json['options']),
      documentRequired: _parseBool(json['document_required']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'current_value': currentValue,
      'options': options,
      'document_required': documentRequired,
    };
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

    return result.isEmpty ? null : result;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => item?.toString().trim())
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

// ============================================================================
// Business Change Request Model
// ============================================================================

class BusinessChangeRequestModel {
  const BusinessChangeRequestModel({
    this.id,
    this.fieldName,
    this.fieldLabel,
    this.currentValue,
    this.requestedValue,
    this.reason,
    this.status,
    this.adminNote,
    this.hasDocument = false,
    this.createdAt,
    this.reviewedAt,
  });

  final int? id;
  final String? fieldName;
  final String? fieldLabel;
  final String? currentValue;
  final String? requestedValue;
  final String? reason;
  final String? status;
  final String? adminNote;
  final bool hasDocument;
  final String? createdAt;
  final String? reviewedAt;

  factory BusinessChangeRequestModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BusinessChangeRequestModel();
    }

    return BusinessChangeRequestModel(
      id: _parseInt(json['id']),
      fieldName: _parseString(json['field_name']),
      fieldLabel: _parseString(json['field_label']),
      currentValue: _parseString(json['current_value']),
      requestedValue: _parseString(json['requested_value']),
      reason: _parseString(json['reason']),
      status: _parseString(json['status']),
      adminNote: _parseString(json['admin_note']),
      hasDocument: _parseBool(json['has_document']),
      createdAt: _parseString(json['created_at']),
      reviewedAt: _parseString(json['reviewed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_name': fieldName,
      'field_label': fieldLabel,
      'current_value': currentValue,
      'requested_value': requestedValue,
      'reason': reason,
      'status': status,
      'admin_note': adminNote,
      'has_document': hasDocument,
      'created_at': createdAt,
      'reviewed_at': reviewedAt,
    };
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

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
