class DashboardProductAccessModel {
  const DashboardProductAccessModel({
    this.kycStatus,
    this.kycLimit = 0,
    this.kycLimitReached = false,
    this.remainingSlots,
  });

  final String? kycStatus;
  final int kycLimit;
  final bool kycLimitReached;

  /// API currently returns null.
  ///
  /// Kept nullable because the backend can return
  /// an integer in the future.
  final int? remainingSlots;

  factory DashboardProductAccessModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardProductAccessModel();
    }

    return DashboardProductAccessModel(
      kycStatus: _parseString(json['kyc_status']),
      kycLimit: _parseInt(json['kyc_limit']) ?? 0,
      kycLimitReached: _parseBool(json['kyc_limit_reached']),
      remainingSlots: _parseInt(json['remaining_slots']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kyc_status': kycStatus,
      'kyc_limit': kycLimit,
      'kyc_limit_reached': kycLimitReached,
      'remaining_slots': remainingSlots,
    };
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) return value;

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) return value.toInt();

    if (value is String) return int.tryParse(value);

    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}
