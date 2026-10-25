// ============================================================
// Login Model
// ============================================================

class LoginModel {
  const LoginModel({
    this.success,
    this.message,
    this.requiresOtp,
    this.merchantId,
    this.expiresInMinutes,
    this.token,
    this.vendor,
  });

  final bool? success;
  final String? message;
  final bool? requiresOtp;
  final int? merchantId;
  final int? expiresInMinutes;

  // NEW: Direct login (without OTP) fields
  final String? token;
  final VendorAuthModel? vendor;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      requiresOtp: _parseBool(json['requires_otp']),
      merchantId: _parseInt(json['merchant_id']),
      expiresInMinutes: _parseInt(json['expires_in_minutes']),
      token: _parseString(json['token']),
      vendor: json['vendor'] is Map
          ? VendorAuthModel.fromJson(
              Map<String, dynamic>.from(json['vendor'] as Map),
            )
          : null,
    );
  }

  static String? _parseString(Object? value) {
    if (value is String) {
      final result = value.trim();
      if (result.isEmpty) return null;
      return result;
    }
    return null;
  }

  static bool? _parseBool(Object? value) {
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    return null;
  }

  static int? _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}

// ============================================================
// Vendor Auth Model (for direct login response)
// ============================================================

class VendorAuthModel {
  const VendorAuthModel({
    this.merchantId,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.status,
    this.kycStatus,
    this.logo,
  });

  final int? merchantId;
  final int? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? status;
  final String? kycStatus;
  final String? logo;

  factory VendorAuthModel.fromJson(Map<String, dynamic> json) {
    return VendorAuthModel(
      merchantId: _parseInt(json['merchant_id']),
      userId: _parseInt(json['user_id']),
      name: _parseString(json['name']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      status: _parseString(json['status']),
      kycStatus: _parseString(json['kyc_status']),
      logo: _parseString(json['logo']),
    );
  }

  static String? _parseString(Object? value) {
    if (value is String) {
      final result = value.trim();
      if (result.isEmpty) return null;
      return result;
    }
    return null;
  }

  static int? _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}
