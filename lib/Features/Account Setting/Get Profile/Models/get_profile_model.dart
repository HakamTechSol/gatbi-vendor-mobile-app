class VendorSettingsModel {
  const VendorSettingsModel({
    this.success = false,
    this.merchant,
    this.user,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final VendorSettingsMerchantModel? merchant;
  final VendorSettingsUserModel? user;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorSettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorSettingsModel();
    }

    return VendorSettingsModel(
      success: _parseBool(json['success']),
      merchant: json['merchant'] is Map
          ? VendorSettingsMerchantModel.fromJson(
              Map<String, dynamic>.from(json['merchant'] as Map),
            )
          : null,
      user: json['user'] is Map
          ? VendorSettingsUserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
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
      'merchant': merchant?.toJson(),
      'user': user?.toJson(),
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
}

// ============================================================
// Merchant Model
// ============================================================

class VendorSettingsMerchantModel {
  const VendorSettingsMerchantModel({
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

  factory VendorSettingsMerchantModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorSettingsMerchantModel();
    }

    return VendorSettingsMerchantModel(
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
      tradeLicenseNumber: _parseString(
        json['trade_license_number'],
      ),
      bankAccountName: _parseString(
        json['bank_account_name'],
      ),
      bankAccountNumber: _parseString(
        json['bank_account_number'],
      ),
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

// ============================================================
// User Model
// ============================================================

class VendorSettingsUserModel {
  const VendorSettingsUserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.emailNotifications = false,
    this.smsNotifications = false,
    this.marketingEmails = false,
    this.language,
    this.currency,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool marketingEmails;
  final String? language;
  final String? currency;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorSettingsUserModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorSettingsUserModel();
    }

    return VendorSettingsUserModel(
      id: _parseInt(json['id']),
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      emailNotifications: _parseBool(
        json['email_notifications'],
      ),
      smsNotifications: _parseBool(
        json['sms_notifications'],
      ),
      marketingEmails: _parseBool(
        json['marketing_emails'],
      ),
      language: _parseString(json['language']),
      currency: _parseString(json['currency']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'marketing_emails': marketingEmails,
      'language': language,
      'currency': currency,
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
}