class VendorKycDetailModel {
  const VendorKycDetailModel({
    this.id,
    this.merchantId,
    this.ownerName,
    this.ownerEmail,
    this.ownerPhone,
    this.authorizedPersonDesignation,
    this.tradeLicenseNumber,
    this.tradeLicenseExpiry,
    this.taxRegistrationNumber,
    this.businessAddress,
    this.website,
    this.notes,
    this.submissionCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? merchantId;

  final String? ownerName;
  final String? ownerEmail;
  final String? ownerPhone;
  final String? authorizedPersonDesignation;

  final String? tradeLicenseNumber;
  final String? tradeLicenseExpiry;
  final String? taxRegistrationNumber;

  final String? businessAddress;
  final String? website;
  final String? notes;

  final int submissionCount;

  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorKycDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorKycDetailModel();
    }

    return VendorKycDetailModel(
      id: _parseInt(json['id']),
      merchantId: _parseInt(json['merchant_id']),

      ownerName: _parseString(json['owner_name']),
      ownerEmail: _parseString(json['owner_email']),
      ownerPhone: _parseString(json['owner_phone']),

      authorizedPersonDesignation: _parseString(
        json['authorized_person_designation'],
      ),

      tradeLicenseNumber: _parseString(json['trade_license_number']),

      tradeLicenseExpiry: _parseString(json['trade_license_expiry']),

      taxRegistrationNumber: _parseString(json['tax_registration_number']),

      businessAddress: _parseString(json['business_address']),

      website: _parseString(json['website']),

      notes: _parseString(json['notes']),

      submissionCount: _parseInt(json['submission_count']) ?? 0,

      createdAt: _parseString(json['created_at']),

      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchant_id': merchantId,
      'owner_name': ownerName,
      'owner_email': ownerEmail,
      'owner_phone': ownerPhone,
      'authorized_person_designation': authorizedPersonDesignation,
      'trade_license_number': tradeLicenseNumber,
      'trade_license_expiry': tradeLicenseExpiry,
      'tax_registration_number': taxRegistrationNumber,
      'business_address': businessAddress,
      'website': website,
      'notes': notes,
      'submission_count': submissionCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
