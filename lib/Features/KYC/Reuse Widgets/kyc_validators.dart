import 'package:flutter/services.dart';

class KycValidators {
  // ============================================================
  // REQUIRED
  // ============================================================

  static String? requiredField(
    String? value, {
    String fieldName = 'This field',
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  // ============================================================
  // STORE NAME
  // ============================================================

  static String? storeName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Store name is required.';
    }

    if (text.length < 2) {
      return 'Store name must be at least 2 characters.';
    }

    if (text.length > 100) {
      return 'Store name must not exceed 100 characters.';
    }

    return null;
  }

  // ============================================================
  // STORE EMAIL
  // ============================================================

  static String? storeEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Store email is required.';
    }

    return email(text);
  }

  // ============================================================
  // OWNER NAME
  // ============================================================

  static String? ownerName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Owner full name is required.';
    }

    if (text.length < 2) {
      return 'Owner name must be at least 2 characters.';
    }

    if (text.length > 100) {
      return 'Owner name must not exceed 100 characters.';
    }

    return null;
  }

  // ============================================================
  // OWNER EMAIL
  // ============================================================

  static String? ownerEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    return email(text);
  }

  // ============================================================
  // EMAIL
  // ============================================================

  static String? email(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9.!#$%&*+/=?^_`{|}~-]+@'
      r'[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?'
      r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$',
    );

    if (!emailRegex.hasMatch(text)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  // ============================================================
  // DESIGNATION
  // ============================================================

  static String? designation(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    if (text.length > 100) {
      return 'Designation must not exceed 100 characters.';
    }

    return null;
  }

  // ============================================================
  // PHONE
  // ============================================================
  //
  // IMPORTANT:
  //
  // KYC phone field mein full number hota hai:
  //
  // +971501234567
  //
  // Lekin validation ke liye screen dial code remove karke
  // local number pass karegi:
  //
  // 501234567
  //
  // Is validator mein:
  //
  // - Phone Rules API nahi hai
  // - Country-wise min/max nahi hai
  // - Sirf required
  // - Digits only
  // - Leading zero allowed nahi
  //
  // ============================================================

  static String? phone(String? value) {
    final text = value?.trim() ?? '';

    // ------------------------------------------------------------
    // REQUIRED
    // ------------------------------------------------------------

    if (text.isEmpty) {
      return 'Owner phone number is required.';
    }

    // ------------------------------------------------------------
    // DIGITS ONLY
    // ------------------------------------------------------------

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'Phone number must contain digits only.';
    }

    // ------------------------------------------------------------
    // NO LEADING ZERO
    // ------------------------------------------------------------

    if (text.startsWith('0')) {
      return 'Enter the phone number without the leading 0.';
    }

    return null;
  }

  // ============================================================
  // TRADE LICENSE
  // ============================================================

  static String? tradeLicense(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Trade license number is required.';
    }

    if (text.length < 3) {
      return 'Trade license number is too short.';
    }

    if (text.length > 100) {
      return 'Trade license number must not exceed 100 characters.';
    }

    return null;
  }

  // ============================================================
  // TRADE LICENSE EXPIRY
  // ============================================================

  static String? tradeLicenseExpiry(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Trade license expiry date is required.';
    }

    final match = RegExp(r'^(\d{4})/(\d{2})/(\d{2})$').firstMatch(text);

    if (match == null) {
      return 'Use date format YYYY/MM/DD.';
    }

    // YYYY/MM/DD
    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);

    if (year == null || month == null || day == null) {
      return 'Please enter a valid expiry date.';
    }

    if (year < 2000) {
      return 'Please enter a valid expiry year.';
    }

    if (month < 1 || month > 12) {
      return 'Please enter a valid expiry month.';
    }

    if (day < 1 || day > 31) {
      return 'Please enter a valid expiry day.';
    }

    final date = DateTime(year, month, day);

    // Prevent DateTime from accepting invalid dates
    // such as 2027/02/30.
    if (date.year != year || date.month != month || date.day != day) {
      return 'Please enter a valid expiry date.';
    }

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    if (!date.isAfter(today)) {
      return 'Trade license expiry date must be a future date.';
    }

    return null;
  }
  // ============================================================
  // TRN
  // ============================================================

  static String? trn(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'TRN must contain digits only.';
    }

    if (text.length != 15) {
      return 'TRN must be exactly 15 digits.';
    }

    return null;
  }

  // ============================================================
  // WEBSITE
  // ============================================================

  static String? website(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(
      text.startsWith('http://') || text.startsWith('https://')
          ? text
          : 'https://$text',
    );

    if (uri == null || uri.host.isEmpty || !uri.host.contains('.')) {
      return 'Please enter a valid website URL.';
    }

    return null;
  }

  // ============================================================
  // BUSINESS ADDRESS
  // ============================================================

  static String? businessAddress(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Business address is required.';
    }

    if (text.length < 10) {
      return 'Please enter a complete business address.';
    }

    if (text.length > 500) {
      return 'Business address must not exceed 500 characters.';
    }

    return null;
  }

  // ============================================================
  // NOTES
  // ============================================================

  static String? notes(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    if (text.length > 1000) {
      return 'Notes must not exceed 1000 characters.';
    }

    return null;
  }

  // ============================================================
  // PHONE FORMATTERS
  // ============================================================

  static List<TextInputFormatter> get phoneFormatters {
    return [FilteringTextInputFormatter.digitsOnly];
  }

  // ============================================================
  // TRN FORMATTERS
  // ============================================================

  static List<TextInputFormatter> get trnFormatters {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(15),
    ];
  }
}
