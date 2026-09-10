class AuthValidator {
  AuthValidator._();

  // ============================================================
  // Business Name
  // ============================================================

  static String? businessName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Business name is required.';
    }

    if (text.length < 2) {
      return 'Business name must be at least 2 characters.';
    }

    return null;
  }

  // ============================================================
  // Email
  // ============================================================

  static String? email(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(
      r'^[\w.!#$%&’*+/=?^`{|}~-]+@[\w-]+(?:\.[\w-]+)+$',
    );

    if (!emailRegex.hasMatch(text)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  // ============================================================
  // Password
  // ============================================================

  static String? password(String? value) {
    final text = value ?? '';

    if (text.isEmpty) {
      return 'Password is required.';
    }

    if (text.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  // ============================================================
  // Confirm Password
  // ============================================================

  static String? confirmPassword(String? value, {required String password}) {
    final text = value ?? '';

    if (text.isEmpty) {
      return 'Please confirm your password.';
    }

    if (text != password) {
      return 'Passwords do not match.';
    }

    return null;
  }

  // ============================================================
  // Phone - Optional
  // ============================================================

  static String? phone(String? value) {
    final text = value?.trim() ?? '';

    // Phone is optional according to registration API.
    if (text.isEmpty) {
      return null;
    }

    if (text.length < 7) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }

  // ============================================================
  // Required Field
  // ============================================================

  static String? required(String? value, {required String fieldName}) {
    if (value?.trim().isEmpty ?? true) {
      return '$fieldName is required.';
    }

    return null;
  }

  // ============================================================
  // OTP
  // ============================================================

  static String? otp(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'OTP is required.';
    }

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'OTP must contain numbers only.';
    }

    return null;
  }
}
