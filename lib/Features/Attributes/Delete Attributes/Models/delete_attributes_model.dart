class DeleteAttributesModel {
  const DeleteAttributesModel({this.success = false, this.message});

  final bool success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory DeleteAttributesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeleteAttributesModel();
    }

    return DeleteAttributesModel(
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
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    if (result.isEmpty) {
      return null;
    }

    return result;
  }
}
