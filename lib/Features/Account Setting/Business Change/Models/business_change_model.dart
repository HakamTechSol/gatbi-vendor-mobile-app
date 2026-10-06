class BusinessChangeModel {
  const BusinessChangeModel({
    this.success = false,
    this.message,
    this.request,
  });

  final bool success;
  final String? message;
  final BusinessChangeRequestModel? request;

  // ============================================================
  // From JSON
  // ============================================================

  factory BusinessChangeModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const BusinessChangeModel();
    }

    return BusinessChangeModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      request: json['request'] is Map
          ? BusinessChangeRequestModel.fromJson(
              Map<String, dynamic>.from(
                json['request'] as Map,
              ),
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
      'request': request?.toJson(),
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

    return result.isEmpty ? null : result;
  }
}

// ============================================================
// Business Change Request Model
// ============================================================

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

  // ============================================================
  // From JSON
  // ============================================================

  factory BusinessChangeRequestModel.fromJson(
    Map<String, dynamic>? json,
  ) {
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

  // ============================================================
  // To JSON
  // ============================================================

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

    return result.isEmpty ? null : result;
  }
}
