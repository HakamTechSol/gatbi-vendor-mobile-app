class CancelBusinessChangeModel {
  const CancelBusinessChangeModel({
    this.success = false,
    this.message,
  });

  final bool success;
  final String? message;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory CancelBusinessChangeModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const CancelBusinessChangeModel();
    }

    return CancelBusinessChangeModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  // ============================================================
  // PARSE BOOL
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

  // ============================================================
  // PARSE STRING
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