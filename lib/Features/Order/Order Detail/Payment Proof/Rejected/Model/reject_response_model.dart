class PaymentProofRejectResponseModel {
  const PaymentProofRejectResponseModel({this.success = false, this.message});

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory PaymentProofRejectResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PaymentProofRejectResponseModel();
    }

    return PaymentProofRejectResponseModel(
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
  // Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}
