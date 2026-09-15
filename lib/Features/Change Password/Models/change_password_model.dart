class ChangePasswordModel {
  const ChangePasswordModel({
    this.success = false,
    this.message,
  });

  final bool success;
  final String? message;

  factory ChangePasswordModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ChangePasswordModel();
    }

    return ChangePasswordModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  // ============================================================
  // Safe Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}