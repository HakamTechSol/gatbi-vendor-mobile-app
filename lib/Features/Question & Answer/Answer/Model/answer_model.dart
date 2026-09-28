class AnswerModel {
  const AnswerModel({this.success, this.message});

  // ============================================================
  // Response Fields
  // ============================================================

  final bool? success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory AnswerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AnswerModel();
    }

    return AnswerModel(
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

  static bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase();

      if (normalized == 'true' || normalized == '1') {
        return true;
      }

      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    if (value is num) {
      return value != 0;
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
