class ReviewReplyModel {
  const ReviewReplyModel({this.success, this.message});

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool? success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewReplyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewReplyModel();
    }

    return ReviewReplyModel(
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
      return value.toLowerCase() == 'true' || value == '1';
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
