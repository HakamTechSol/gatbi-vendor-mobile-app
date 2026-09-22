class KycSubmitModel {
  const KycSubmitModel({this.success = false, this.message, this.kycStatus});

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;

  final String? message;

  final String? kycStatus;

  // ============================================================
  // From JSON
  // ============================================================

  factory KycSubmitModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const KycSubmitModel();
    }

    return KycSubmitModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      kycStatus: _parseString(json['kyc_status']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'kyc_status': kycStatus};
  }

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}
