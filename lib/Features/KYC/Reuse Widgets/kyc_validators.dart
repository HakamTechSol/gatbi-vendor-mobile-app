import 'package:flutter/services.dart';

class KycValidators {
  KycValidators._();

  // ═══════════════════════════════════════════════════════════════════════════
  // REQUIRED
  // ═══════════════════════════════════════════════════════════════════════════

  static String? requiredField(String? value, {required String fieldName}) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STORE
  // ═══════════════════════════════════════════════════════════════════════════

  static String? storeName(String? value) {
    final required = requiredField(value, fieldName: 'Store name');

    if (required != null) return required;

    final text = value!.trim();

    if (text.length < 2) {
      return 'Store name must be at least 2 characters.';
    }

    if (text.length > 100) {
      return 'Store name cannot exceed 100 characters.';
    }

    return null;
  }

  static String? storeEmail(String? value) {
    return email(value, fieldName: 'Store email', required: true);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OWNER
  // ═══════════════════════════════════════════════════════════════════════════

  static String? ownerName(String? value) {
    final required = requiredField(value, fieldName: 'Owner full name');

    if (required != null) return required;

    final text = value!.trim();

    if (text.length < 2) {
      return 'Owner name must be at least 2 characters.';
    }

    if (text.length > 100) {
      return 'Owner name cannot exceed 100 characters.';
    }

    final nameRegex = RegExp(r"^[A-Za-zÀ-ÿ\s.'-]+$");

    if (!nameRegex.hasMatch(text)) {
      return 'Owner name contains invalid characters.';
    }

    return null;
  }

  static String? ownerEmail(String? value) {
    return email(value, fieldName: 'Owner email', required: false);
  }

  static String? email(
    String? value, {
    required String fieldName,
    bool required = false,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return required ? '$fieldName is required.' : null;
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9.!#$%&*+/=?^_`{|}~-]+@'
      r'[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}'
      r'[A-Za-z0-9])?(?:\.[A-Za-z0-9]'
      r'(?:[A-Za-z0-9-]{0,61}'
      r'[A-Za-z0-9])?)+$',
    );

    if (!emailRegex.hasMatch(text)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  static String? designation(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    if (text.length < 2) {
      return 'Designation must be at least 2 characters.';
    }

    if (text.length > 100) {
      return 'Designation cannot exceed 100 characters.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE
  // ═══════════════════════════════════════════════════════════════════════════

  static String? phone(String? value, {required String countryCode}) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Owner phone is required.';
    }

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'Phone number can contain digits only.';
    }

    final expectedLength = _phoneLength(countryCode);

    if (expectedLength != null && text.length != expectedLength) {
      return 'Enter a valid $countryCode phone number '
          '($expectedLength digits).';
    }

    if (text.startsWith('0')) {
      return 'Enter the number without the leading 0.';
    }

    return null;
  }

  static int? _phoneLength(String countryCode) {
    switch (countryCode) {
      case '+971':
        return 9;

      case '+92':
        return 10;

      case '+91':
        return 10;

      case '+966':
        return 9;

      default:
        return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRADE LICENSE
  // ═══════════════════════════════════════════════════════════════════════════

  static String? tradeLicense(String? value) {
    final required = requiredField(value, fieldName: 'Trade license number');

    if (required != null) return required;

    final text = value!.trim();

    if (text.length < 3) {
      return 'Trade license number is too short.';
    }

    if (text.length > 50) {
      return 'Trade license number cannot exceed 50 characters.';
    }

    return null;
  }

  static String? tradeLicenseExpiry(String? value) {
    final required = requiredField(
      value,
      fieldName: 'Trade license expiry date',
    );

    if (required != null) return required;

    final text = value!.trim();

    try {
      final parts = text.split('/');

      if (parts.length != 3) {
        return 'Enter a valid expiry date.';
      }

      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      if (date.month != month || date.day != day || date.year != year) {
        return 'Enter a valid expiry date.';
      }

      final now = DateTime.now();

      final today = DateTime(now.year, now.month, now.day);

      if (!date.isAfter(today)) {
        return 'Trade license must not be expired.';
      }
    } catch (_) {
      return 'Enter a valid expiry date.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRN
  // ═══════════════════════════════════════════════════════════════════════════

  static String? trn(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'TRN can contain digits only.';
    }

    if (text.length != 15) {
      return 'TRN must contain 15 digits.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WEBSITE
  // ═══════════════════════════════════════════════════════════════════════════

  static String? website(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    final normalized = text.startsWith('http://') || text.startsWith('https://')
        ? text
        : 'https://$text';

    final uri = Uri.tryParse(normalized);

    if (uri == null || uri.host.isEmpty || !uri.host.contains('.')) {
      return 'Enter a valid website URL.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ADDRESS
  // ═══════════════════════════════════════════════════════════════════════════

  static String? businessAddress(String? value) {
    final required = requiredField(
      value,
      fieldName: 'Registered business address',
    );

    if (required != null) return required;

    final text = value!.trim();

    if (text.length < 10) {
      return 'Please enter a complete business address.';
    }

    if (text.length > 500) {
      return 'Business address cannot exceed 500 characters.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTES
  // ═══════════════════════════════════════════════════════════════════════════

  static String? notes(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return null;

    if (text.length > 1000) {
      return 'Notes cannot exceed 1000 characters.';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT FORMATTERS
  // ═══════════════════════════════════════════════════════════════════════════

  static final phoneFormatters = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(15),
  ];

  static final trnFormatters = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(15),
  ];
}
