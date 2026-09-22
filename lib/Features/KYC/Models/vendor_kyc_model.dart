import 'vendor_kyc_data_model.dart';

class VendorKycModel {
  const VendorKycModel({this.success = false, this.kyc});

  final bool success;
  final VendorKycDataModel? kyc;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorKycModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorKycModel();
    }

    return VendorKycModel(
      success: _parseBool(json['success']),
      kyc: json['kyc'] is Map
          ? VendorKycDataModel.fromJson(
              Map<String, dynamic>.from(json['kyc'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'kyc': kyc?.toJson()};
  }

  // ============================================================
  // Helpers
  // ============================================================

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
