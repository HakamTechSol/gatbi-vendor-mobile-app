class DeleteProductModel {
  const DeleteProductModel({
    this.success = false,
    this.message,
  });

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory DeleteProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DeleteProductModel();
    }

    return DeleteProductModel(
      success: _parseBool(json['success']),
      message: json['message']?.toString(),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  // ============================================================
  // Boolean Parser
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
}