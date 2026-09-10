class LoginModel {
  const LoginModel({
    this.success,
    this.message,
    this.requiresOtp,
    this.merchantId,
    this.expiresInMinutes,
  });

  final bool? success;
  final String? message;
  final bool? requiresOtp;
  final int? merchantId;
  final int? expiresInMinutes;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      requiresOtp: _parseBool(json['requires_otp']),
      merchantId: _parseInt(json['merchant_id']),
      expiresInMinutes: _parseInt(json['expires_in_minutes']),
    );
  }

  static String? _parseString(Object? value) {
    if (value is String) {
      final result = value.trim();

      if (result.isEmpty) {
        return null;
      }

      return result;
    }

    return null;
  }

  static bool? _parseBool(Object? value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      if (normalized == 'true') {
        return true;
      }

      if (normalized == 'false') {
        return false;
      }
    }

    if (value is num) {
      if (value == 1) {
        return true;
      }

      if (value == 0) {
        return false;
      }
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
      return int.tryParse(value.trim());
    }

    return null;
  }
}
