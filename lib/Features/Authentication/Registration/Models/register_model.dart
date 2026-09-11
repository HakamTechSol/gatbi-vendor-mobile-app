class RegisterModel {
  const RegisterModel({
    this.storeName,
    this.businessType,
    this.email,
    this.phoneFull,
    this.phoneCountry,
    this.address,
    this.categoryId,
    this.about,
    this.tradeLicenseNumber,
    this.password,
    this.passwordConfirmation,
    this.termsAgreed,

    // Response fields
    this.success,
    this.message,
    this.data,
  });

  // ============================================================
  // REQUEST FIELDS
  // ============================================================

  final String? storeName;
  final String? businessType;
  final String? email;
  final String? phoneFull;
  final String? phoneCountry;
  final String? address;
  final int? categoryId;
  final String? about;
  final String? tradeLicenseNumber;
  final String? password;
  final String? passwordConfirmation;
  final String? termsAgreed;

  // ============================================================
  // RESPONSE FIELDS
  // ============================================================

  final bool? success;
  final String? message;
  final RegisterResponseData? data;

  // ============================================================
  // REQUEST -> JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'business_type': businessType,
      'email': email,
      'phone_full': phoneFull,
      'phone_country': phoneCountry,
      'address': address,
      'category_id': categoryId,
      'about': about,
      'trade_license_number': tradeLicenseNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'terms_agreed': termsAgreed,
    };
  }

  // ============================================================
  // RESPONSE JSON -> MODEL
  // ============================================================

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return RegisterModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      data: rawData is Map<String, dynamic>
          ? RegisterResponseData.fromJson(rawData)
          : rawData is Map
          ? RegisterResponseData.fromJson(Map<String, dynamic>.from(rawData))
          : null,
    );
  }

  // ============================================================
  // SAFE PARSERS
  // ============================================================

  static String? _parseString(Object? value) {
    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return null;
  }

  static bool? _parseBool(Object? value) {
    if (value is bool) {
      return value;
    }

    return null;
  }
}

// ================================================================
// REGISTER RESPONSE DATA
// ================================================================

class RegisterResponseData {
  const RegisterResponseData({this.merchantId, this.email, this.status});

  final int? merchantId;
  final String? email;
  final String? status;

  // ============================================================
  // RESPONSE JSON -> MODEL
  // ============================================================

  factory RegisterResponseData.fromJson(Map<String, dynamic> json) {
    return RegisterResponseData(
      merchantId: _parseInt(json['merchant_id']),
      email: _parseString(json['email']),
      status: _parseString(json['status']),
    );
  }

  // ============================================================
  // SAFE PARSERS
  // ============================================================

  static String? _parseString(Object? value) {
    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return null;
  }

  static int? _parseInt(Object? value) {
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
