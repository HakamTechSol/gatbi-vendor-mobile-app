class VendorKycFieldReviewModel {
  const VendorKycFieldReviewModel({this.field, this.status, this.comment});

  final String? field;
  final String? status;
  final String? comment;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorKycFieldReviewModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorKycFieldReviewModel();
    }

    return VendorKycFieldReviewModel(
      field: _parseString(json['field']),
      status: _parseString(json['status']),
      comment: _parseString(json['comment']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'field': field, 'status': status, 'comment': comment};
  }

  // ============================================================
  // Helper
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}
