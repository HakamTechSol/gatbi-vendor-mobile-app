class ForgotPasswordModel {
  const ForgotPasswordModel({this.success, this.message});

  final bool? success;
  final String? message;

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
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
}
