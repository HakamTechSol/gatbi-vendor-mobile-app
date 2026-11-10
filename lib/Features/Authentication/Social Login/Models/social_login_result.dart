import '../../Login/Models/login_model.dart';

class SocialLoginResult {
  const SocialLoginResult({
    required this.success,
    this.message,
    this.reason,
    this.token,
    this.vendor,
    this.requiresOtp = false,
    this.merchantId,
    this.expiresInMinutes,
    this.vendorNotFound = false,
    this.email,
    this.firstName,
    this.lastName,
    this.name,
    this.avatar,
    this.errorCode,
    this.statusCode,
  });

  final bool success;
  final String? message;
  final String? reason;
  final String? token;
  final VendorAuthModel? vendor;
  final bool requiresOtp;
  final int? merchantId;
  final int? expiresInMinutes;
  final bool vendorNotFound;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? avatar;
  final String? errorCode;
  final int? statusCode;

  bool get hasToken => token != null && token!.isNotEmpty;

  SocialLoginResult copyWith({
    bool? success,
    String? message,
    String? reason,
    String? token,
    VendorAuthModel? vendor,
    bool? requiresOtp,
    int? merchantId,
    int? expiresInMinutes,
    bool? vendorNotFound,
    String? email,
    String? firstName,
    String? lastName,
    String? name,
    String? avatar,
    String? errorCode,
    int? statusCode,
  }) {
    return SocialLoginResult(
      success: success ?? this.success,
      message: message ?? this.message,
      reason: reason ?? this.reason,
      token: token ?? this.token,
      vendor: vendor ?? this.vendor,
      requiresOtp: requiresOtp ?? this.requiresOtp,
      merchantId: merchantId ?? this.merchantId,
      expiresInMinutes: expiresInMinutes ?? this.expiresInMinutes,
      vendorNotFound: vendorNotFound ?? this.vendorNotFound,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      errorCode: errorCode ?? this.errorCode,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  factory SocialLoginResult.fail({
    required String message,
    String? reason,
    String? errorCode,
    int? statusCode,
  }) {
    return SocialLoginResult(
      success: false,
      message: message,
      reason: reason,
      errorCode: errorCode,
      statusCode: statusCode,
    );
  }

  factory SocialLoginResult.cancelled() {
    return const SocialLoginResult(
      success: false,
      message: 'Sign-in was cancelled.',
      errorCode: 'CANCELLED',
    );
  }

  factory SocialLoginResult.fromResponse(
    int? statusCode,
    Map<String, dynamic>? responseData,
  ) {
    final root = responseData ?? const <String, dynamic>{};
    final nested = root['data'] is Map
        ? Map<String, dynamic>.from(root['data'] as Map)
        : const <String, dynamic>{};

    Object? value(String key) {
      final nestedValue = nested[key];
      if (nestedValue != null) return nestedValue;
      return root[key];
    }

    final token = _string(value('token')) ?? _string(value('access_token'));
    final errorCode = _errorCode(root, nested);
    final explicitSuccess = _bool(root['success']) ?? _bool(nested['success']);
    final requiresOtp = _bool(value('requires_otp')) ?? false;

    final vendorNotFound =
        statusCode == 404 ||
        errorCode == 'VENDOR_NOT_FOUND' ||
        (_bool(value('vendor_not_found')) ?? false);

    final success =
        requiresOtp ||
        vendorNotFound ||
        (token != null &&
            (explicitSuccess ??
                (statusCode != null &&
                    statusCode >= 200 &&
                    statusCode < 300)));

    final vendorJson = value('vendor');
    final vendor = vendorJson is Map
        ? VendorAuthModel.fromJson(Map<String, dynamic>.from(vendorJson))
        : null;

    final vendorData = nested.isNotEmpty ? nested : root;

    return SocialLoginResult(
      success: success,
      message: _string(value('message')),
      reason: _string(value('reason')),
      token: token,
      vendor: vendor,
      requiresOtp: requiresOtp,
      merchantId: _int(value('merchant_id')),
      expiresInMinutes:
          _int(value('expires_in_minutes')) ?? _int(value('expires_in')),
      vendorNotFound: vendorNotFound,
      email: _string(value('email')) ?? _string(vendorData['email']),
      firstName:
          _string(value('first_name')) ?? _string(vendorData['first_name']),
      lastName:
          _string(value('last_name')) ?? _string(vendorData['last_name']),
      name:
          _string(value('name')) ??
          _string(value('full_name')) ??
          _string(vendorData['name']),
      avatar:
          _string(value('avatar')) ??
          _string(value('logo')) ??
          _string(vendorData['logo']),
      errorCode: errorCode,
      statusCode: statusCode,
    );
  }

  static String? _errorCode(
    Map<String, dynamic> root,
    Map<String, dynamic> nested,
  ) {
    for (final source in <Map<String, dynamic>>[root, nested]) {
      final error = source['error'];

      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }

      if (error is Map) {
        final code = _string(error['code']);
        if (code != null) return code;
      }

      final code = _string(source['code']);
      if (code != null) return code;
    }

    return null;
  }

  static String? _string(Object? value) {
    if (value is String) {
      final result = value.trim();
      if (result.isNotEmpty) return result;
    }
    return null;
  }

  static bool? _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  static int? _int(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}
