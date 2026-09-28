class SupportModel {
  const SupportModel({this.success = false, this.message});

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory SupportModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SupportModel();
    }

    return SupportModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase();

      return normalized == 'true' || normalized == '1';
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
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
