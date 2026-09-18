class PaymentProofVerifyResponseModel {
  const PaymentProofVerifyResponseModel({this.success = false, this.message});

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;
  final String? message;

  // ============================================================
  // From JSON
  // ============================================================

  factory PaymentProofVerifyResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PaymentProofVerifyResponseModel();
    }

    return PaymentProofVerifyResponseModel(
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
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
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
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}
