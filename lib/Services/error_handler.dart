import 'dart:io';

import 'package:dio/dio.dart';

import 'api_exception.dart';

class ErrorHandler {
  ErrorHandler._();

  static ApiException handle(DioException error) {
    final response = error.response;

    // ============================================================
    // SERVER RESPONSE ERROR
    // ============================================================

    if (response != null) {
      return _handleResponseError(error);
    }

    // ============================================================
    // NETWORK / DIO ERRORS
    // ============================================================

    return _handleNetworkError(error);
  }

  // ============================================================
  // RESPONSE ERROR
  // ============================================================

  static ApiException _handleResponseError(DioException error) {
    final response = error.response;

    final statusCode = response?.statusCode;
    final data = response?.data;

    String message = 'Something went wrong.';

    String? code;

    Map<String, dynamic>? errors;

    // ============================================================
    // PARSE BACKEND RESPONSE
    // ============================================================

    if (data is Map) {
      // ----------------------------------------------------------
      // Error code
      // ----------------------------------------------------------

      final apiCode = data['code'];

      if (apiCode is String && apiCode.trim().isNotEmpty) {
        code = apiCode.trim();
      }

      // ----------------------------------------------------------
      // Message
      // ----------------------------------------------------------

      final apiMessage = data['message'];

      if (apiMessage is String && apiMessage.trim().isNotEmpty) {
        message = apiMessage.trim();
      }

      // ----------------------------------------------------------
      // Validation errors
      // ----------------------------------------------------------

      final apiErrors = data['errors'];

      if (apiErrors is Map) {
        errors = Map<String, dynamic>.from(apiErrors);
      }
    }

    // ============================================================
    // STATUS BASED FALLBACK
    // ============================================================

    switch (statusCode) {
      // ----------------------------------------------------------
      // 400
      // ----------------------------------------------------------

      case 400:
        return ApiException(
          message: message,
          statusCode: statusCode,
          code: code,
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 401
      // ----------------------------------------------------------

      case 401:
        return ApiException(
          message: message != 'Something went wrong.'
              ? message
              : 'Session expired. Please login again.',
          statusCode: statusCode,
          code: code ?? 'UNAUTHORIZED',
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 403
      // ----------------------------------------------------------

      case 403:
        return ApiException(
          message: message != 'Something went wrong.'
              ? message
              : 'You are not allowed to perform this action.',
          statusCode: statusCode,
          code: code,
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 404
      // ----------------------------------------------------------

      case 404:
        return ApiException(
          message: message != 'Something went wrong.'
              ? message
              : 'Requested resource was not found.',
          statusCode: statusCode,
          code: code,
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 422
      // ----------------------------------------------------------

      case 422:
        return ApiException(
          message: message != 'Something went wrong.'
              ? message
              : 'Please check the entered information.',
          statusCode: statusCode,
          code: code ?? 'VALIDATION_ERROR',
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 423
      // ----------------------------------------------------------

      case 423:
        return ApiException(
          message: message != 'Something went wrong.'
              ? message
              : 'Your account is temporarily locked. Please try again later.',
          statusCode: statusCode,
          code: code ?? 'ACCOUNT_LOCKED',
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 429
      // ----------------------------------------------------------

      case 429:
        return ApiException(
          message: message != 'Something went wrong.'
              ? message
              : 'Too many requests. Please try again later.',
          statusCode: statusCode,
          code: code,
          errors: errors,
          originalError: error,
        );

      // ----------------------------------------------------------
      // 500+
      // ----------------------------------------------------------

      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiException(
            message: 'Server error. Please try again later.',
            statusCode: statusCode,
            code: code ?? 'SERVER_ERROR',
            errors: errors,
            originalError: error,
          );
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          code: code,
          errors: errors,
          originalError: error,
        );
    }
  }

  // ============================================================
  // NETWORK ERRORS
  // ============================================================

  static ApiException _handleNetworkError(DioException error) {
    switch (error.type) {
      // ----------------------------------------------------------
      // TIMEOUT
      // ----------------------------------------------------------

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiException(
          message: 'Connection timed out. Please try again.',
          code: 'TIMEOUT',
          originalError: error,
        );

      // ----------------------------------------------------------
      // CONNECTION ERROR
      // ----------------------------------------------------------

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return ApiException(
            message: 'No internet connection.',
            code: 'NO_INTERNET',
            originalError: error,
          );
        }

        return ApiException(
          message: 'Unable to connect to the server.',
          code: 'CONNECTION_ERROR',
          originalError: error,
        );

      // ----------------------------------------------------------
      // CANCELLED
      // ----------------------------------------------------------

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled.',
          code: 'REQUEST_CANCELLED',
          originalError: error,
        );

      // ----------------------------------------------------------
      // BAD CERTIFICATE
      // ----------------------------------------------------------

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Secure connection could not be established.',
          code: 'BAD_CERTIFICATE',
          originalError: error,
        );

      // ----------------------------------------------------------
      // BAD RESPONSE
      // ----------------------------------------------------------

      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Invalid server response.',
          code: 'BAD_RESPONSE',
          originalError: error,
        );

      // ----------------------------------------------------------
      // UNKNOWN
      // ----------------------------------------------------------

      case DioExceptionType.unknown:
        return ApiException(
          message: 'Something went wrong. Please try again.',
          code: 'UNKNOWN_ERROR',
          originalError: error,
        );
    }
  }
}
