class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.originalError,
  });

  final String message;
  final int? statusCode;

  /// Backend validation errors.
  ///
  /// Example:
  /// {
  ///   "email": ["The email field is required."]
  /// }
  final Map<String, dynamic>? errors;

  final Object? originalError;

  bool get isUnauthorized => statusCode == 401;

  bool get isValidationError => statusCode == 422;

  bool get isServerError => statusCode != null && statusCode! >= 500;

  @override
  String toString() {
    return 'ApiException('
        'statusCode: $statusCode, '
        'message: $message, '
        'errors: $errors'
        ')';
  }
}
