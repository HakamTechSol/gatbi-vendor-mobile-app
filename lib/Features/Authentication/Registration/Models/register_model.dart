class RegisterModel {
  const RegisterModel({
    this.businessName,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.phone,
    this.success,
    this.message,
    this.merchantId,
    this.requiresOtp,
  });

  // ============================================================
  // Request Fields
  // ============================================================

  final String? businessName;
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final String? phone;

  // ============================================================
  // Response Fields
  // ============================================================

  final bool? success;
  final String? message;
  final int? merchantId;
  final bool? requiresOtp;

  // ============================================================
  // Request -> JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'business_name': businessName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    final normalizedPhone = phone?.trim();

    if (normalizedPhone != null && normalizedPhone.isNotEmpty) {
      json['phone'] = normalizedPhone;
    }

    return json;
  }

  // ============================================================
  // Response JSON -> Model
  // ============================================================

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      merchantId: _parseInt(json['merchant_id']),
      requiresOtp: _parseBool(json['requires_otp']),
    );
  }

  // ============================================================
  // Safe Parsers
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
