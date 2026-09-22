import 'package:flutter/services.dart';

class PhoneDialCodeFormatter extends TextInputFormatter {
  PhoneDialCodeFormatter({
    required this.dialCode,
  });

  final String dialCode;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalizedDialCode = _normalizeDialCode(dialCode);

    if (normalizedDialCode.isEmpty) {
      return newValue;
    }

    final _ = oldValue.text;
    final newText = newValue.text;

    // ============================================================
    // EMPTY INPUT
    // ============================================================

    if (newText.trim().isEmpty) {
      return _buildValue(
        text: '$normalizedDialCode ',
      );
    }

    // ============================================================
    // EXTRACT LOCAL DIGITS
    // ============================================================

    final localDigits = _extractLocalDigits(
      text: newText,
      dialCode: normalizedDialCode,
    );

    // ============================================================
    // BUILD FINAL TEXT
    // ============================================================

    final formattedText = localDigits.isEmpty
        ? '$normalizedDialCode '
        : '$normalizedDialCode $localDigits';

    // ============================================================
    // CURSOR
    // ============================================================

    int cursorPosition;

    if (newValue.selection.baseOffset <= normalizedDialCode.length) {
      cursorPosition = formattedText.length;
    } else {
      final typedDigitsBeforeCursor = _countLocalDigitsBeforeCursor(
        text: newText,
        cursor: newValue.selection.baseOffset,
        dialCode: normalizedDialCode,
      );

      cursorPosition =
          normalizedDialCode.length +
          1 +
          typedDigitsBeforeCursor;

      if (cursorPosition > formattedText.length) {
        cursorPosition = formattedText.length;
      }
    }

    // ============================================================
    // RETURN
    // ============================================================

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: cursorPosition,
      ),
      composing: TextRange.empty,
    );
  }

  // ==============================================================
  // NORMALIZE DIAL CODE
  // ==============================================================

  String _normalizeDialCode(String value) {
    var code = value.trim();

    if (code.isEmpty) {
      return '';
    }

    if (!code.startsWith('+')) {
      code = '+$code';
    }

    final digits = code.substring(1).replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (digits.isEmpty) {
      return '';
    }

    return '+$digits';
  }

  // ==============================================================
  // EXTRACT LOCAL DIGITS
  // ==============================================================

  String _extractLocalDigits({
    required String text,
    required String dialCode,
  }) {
    var value = text.trim();

    if (value.isEmpty) {
      return '';
    }

    final dialDigits = dialCode.substring(1);

    // ------------------------------------------------------------
    // Case 1:
    // User has entered the full dial code.
    //
    // Example:
    // +92
    // +923
    // +92 3
    // +92 3212345678
    // ------------------------------------------------------------

    if (value.startsWith(dialCode)) {
      value = value.substring(dialCode.length);
    } else if (value.startsWith('+')) {
      // ----------------------------------------------------------
      // User pasted another +number.
      //
      // Example:
      // +923212345678
      //
      // Remove only the selected country dial code.
      // ----------------------------------------------------------

      final allDigits = value.substring(1).replaceAll(
        RegExp(r'\D'),
        '',
      );

      if (allDigits.startsWith(dialDigits)) {
        value = allDigits.substring(dialDigits.length);
      } else {
        value = allDigits;
      }
    }

    // ------------------------------------------------------------
    // Keep digits only for local number.
    // ------------------------------------------------------------

    var localDigits = value.replaceAll(
      RegExp(r'\D'),
      '',
    );

    // ------------------------------------------------------------
    // If user accidentally enters local number with leading 0,
    // remove it because KYC API expects international format.
    //
    // Example:
    // +92 03212345678
    // becomes
    // +92 3212345678
    // ------------------------------------------------------------

    localDigits = localDigits.replaceFirst(
      RegExp(r'^0+'),
      '',
    );

    return localDigits;
  }

  // ==============================================================
  // COUNT LOCAL DIGITS BEFORE CURSOR
  // ==============================================================

  int _countLocalDigitsBeforeCursor({
    required String text,
    required int cursor,
    required String dialCode,
  }) {
    if (cursor <= 0) {
      return 0;
    }

    final safeCursor = cursor > text.length
        ? text.length
        : cursor;

    final beforeCursor = text.substring(0, safeCursor);

    final dialDigits = dialCode.substring(1);

    String localPart;

    if (beforeCursor.startsWith(dialCode)) {
      localPart = beforeCursor.substring(dialCode.length);
    } else if (beforeCursor.startsWith('+')) {
      final digits = beforeCursor
          .substring(1)
          .replaceAll(RegExp(r'\D'), '');

      if (digits.startsWith(dialDigits)) {
        localPart = digits.substring(dialDigits.length);
      } else {
        localPart = digits;
      }
    } else {
      localPart = beforeCursor;
    }

    localPart = localPart.replaceAll(
      RegExp(r'\D'),
      '',
    );

    localPart = localPart.replaceFirst(
      RegExp(r'^0+'),
      '',
    );

    return localPart.length;
  }

  // ==============================================================
  // BUILD TEXT EDITING VALUE
  // ==============================================================

  TextEditingValue _buildValue({
    required String text,
  }) {
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
      composing: TextRange.empty,
    );
  }
}