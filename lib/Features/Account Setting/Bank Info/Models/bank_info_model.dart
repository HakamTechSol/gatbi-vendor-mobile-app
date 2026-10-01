class BankInfoModel {
  const BankInfoModel({this.success = false, this.message, this.merchant});

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final String? message;
  final BankInfoMerchantModel? merchant;

  // ============================================================
  // From JSON
  // ============================================================

  factory BankInfoModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BankInfoModel();
    }

    return BankInfoModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      merchant: json['merchant'] is Map
          ? BankInfoMerchantModel.fromJson(
              Map<String, dynamic>.from(json['merchant'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'merchant': merchant?.toJson(),
    };
  }

  // ============================================================
  // Bool Parser
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  // ============================================================
  // String Parser
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

// ============================================================
// Merchant Model
// ============================================================

class BankInfoMerchantModel {
  const BankInfoMerchantModel({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.phone,
    this.logo,
    this.about,
    this.status,
    this.kycStatus,
    this.primaryCategoryId,
    this.warehouseAddress,
    this.businessType,
    this.tradeLicenseNumber,
    this.bankAccountName,
    this.bankAccountNumber,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? slug;
  final String? email;
  final String? phone;
  final String? logo;
  final String? about;
  final String? status;
  final String? kycStatus;
  final int? primaryCategoryId;
  final String? warehouseAddress;
  final String? businessType;
  final String? tradeLicenseNumber;
  final String? bankAccountName;
  final String? bankAccountNumber;

  // ============================================================
  // From JSON
  // ============================================================

  factory BankInfoMerchantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BankInfoMerchantModel();
    }

    return BankInfoMerchantModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      logo: _parseString(json['logo']),
      about: _parseString(json['about']),
      status: _parseString(json['status']),
      kycStatus: _parseString(json['kyc_status']),
      primaryCategoryId: _parseInt(json['primary_category_id']),
      warehouseAddress: _parseString(json['warehouse_address']),
      businessType: _parseString(json['business_type']),
      tradeLicenseNumber: _parseString(json['trade_license_number']),
      bankAccountName: _parseString(json['bank_account_name']),
      bankAccountNumber: _parseString(json['bank_account_number']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'email': email,
      'phone': phone,
      'logo': logo,
      'about': about,
      'status': status,
      'kyc_status': kycStatus,
      'primary_category_id': primaryCategoryId,
      'warehouse_address': warehouseAddress,
      'business_type': businessType,
      'trade_license_number': tradeLicenseNumber,
      'bank_account_name': bankAccountName,
      'bank_account_number': bankAccountNumber,
    };
  }

  // ============================================================
  // Parsers
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

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
