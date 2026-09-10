class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.errors,
    this.originalError,
  });

  /// User-friendly backend/API message.
  final String message;

  /// HTTP status code.
  final int? statusCode;

  /// Backend error code.
  ///
  /// Examples:
  /// VALIDATION_ERROR
  /// UNAUTHORIZED
  /// AUTH_TOKEN_INVALID
  /// PRODUCT_NOT_FOUND
  final String? code;

  /// Backend validation errors.
  ///
  /// Example:
  /// {
  ///   "email": ["The email field is required."],
  ///   "password": ["The password field is required."]
  /// }
  final Map<String, dynamic>? errors;

  /// Original Dio / network error.
  final Object? originalError;

  // ============================================================
  // HTTP STATUS HELPERS
  // ============================================================

  bool get isBadRequest => statusCode == 400;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isValidationError => statusCode == 422;

  bool get isTooManyRequests => statusCode == 429;

  bool get isServerError => statusCode != null && statusCode! >= 500;

  // ============================================================
  // BACKEND CODE HELPERS
  // ============================================================

  bool get isAuthTokenInvalid => code == 'AUTH_TOKEN_INVALID';

  bool get isAuthTokenRevoked => code == 'AUTH_TOKEN_REVOKED';

  bool get isInvalidCredentials => code == 'INVALID_CREDENTIALS';

  bool get isEmailVerificationRequired => code == 'EMAIL_VERIFICATION_REQUIRED';

  bool get isAccountDisabled => code == 'ACCOUNT_DISABLED';

  bool get isAccountLocked => code == 'ACCOUNT_LOCKED';

  bool get isMerchantNotApproved => code == 'MERCHANT_NOT_APPROVED';

  bool get isKycProductLimitReached => code == 'KYC_PRODUCT_LIMIT_REACHED';

  bool get isChangesLocked => code == 'CHANGES_LOCKED';

  bool get isWeakPassword => code == 'WEAK_PASSWORD';

  bool get isInvalidPhoneFormat => code == 'INVALID_PHONE_FORMAT';

  bool get isEmailAlreadyInUse => code == 'EMAIL_ALREADY_IN_USE';

  bool get isNoEligiblePayout => code == 'NO_ELIGIBLE_PAYOUT';

  bool get isProductNotFound => code == 'PRODUCT_NOT_FOUND';

  bool get isOrderNotFound => code == 'ORDER_NOT_FOUND';

  bool get isConversationNotFound => code == 'CONVERSATION_NOT_FOUND';

  bool get isUnauthorizedError =>
      code == 'UNAUTHORIZED' ||
      code == 'AUTH_TOKEN_INVALID' ||
      code == 'AUTH_TOKEN_REVOKED';

  bool get isServerErrorCode => code == 'SERVER_ERROR';

  @override
  String toString() {
    return 'ApiException('
        'statusCode: $statusCode, '
        'code: $code, '
        'message: $message, '
        'errors: $errors'
        ')';
  }
}
