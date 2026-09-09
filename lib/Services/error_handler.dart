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
      final statusCode = response.statusCode;
      final data = response.data;

      String message = 'Something went wrong.';

      Map<String, dynamic>? errors;

      if (data is Map) {
        final apiMessage = data['message'];

        if (apiMessage is String && apiMessage.trim().isNotEmpty) {
          message = apiMessage;
        }

        final apiErrors = data['errors'];

        if (apiErrors is Map) {
          errors = Map<String, dynamic>.from(apiErrors);
        }
      }

      switch (statusCode) {
        // --------------------------------------------------------
        // 400
        // --------------------------------------------------------

        case 400:
          return ApiException(
            message: message,
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );

        // --------------------------------------------------------
        // 401
        // --------------------------------------------------------

        case 401:
          return ApiException(
            message: message.trim().isNotEmpty
                ? message
                : 'Session expired. Please login again.',
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );

        // --------------------------------------------------------
        // 403
        // --------------------------------------------------------

        case 403:
          return ApiException(
            message: message.trim().isNotEmpty
                ? message
                : 'You are not allowed to perform this action.',
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );

        // --------------------------------------------------------
        // 404
        // --------------------------------------------------------

        case 404:
          return ApiException(
            message: message.trim().isNotEmpty
                ? message
                : 'Requested resource was not found.',
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );

        // --------------------------------------------------------
        // 422
        // --------------------------------------------------------

        case 422:
          return ApiException(
            message: message.trim().isNotEmpty
                ? message
                : 'Please check the entered information.',
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );

        // --------------------------------------------------------
        // 429
        // --------------------------------------------------------

        case 429:
          return ApiException(
            message: 'Too many requests. Please try again later.',
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );

        // --------------------------------------------------------
        // 500+
        // --------------------------------------------------------

        default:
          if (statusCode != null && statusCode >= 500) {
            return ApiException(
              message: 'Server error. Please try again later.',
              statusCode: statusCode,
              errors: errors,
              originalError: error,
            );
          }

          return ApiException(
            message: message,
            statusCode: statusCode,
            errors: errors,
            originalError: error,
          );
      }
    }

    // ============================================================
    // NETWORK / DIO ERRORS
    // ============================================================

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
          originalError: error,
        );

      // ----------------------------------------------------------
      // CONNECTION ERROR
      // ----------------------------------------------------------

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return ApiException(
            message: 'No internet connection.',
            originalError: error,
          );
        }

        return ApiException(
          message: 'Unable to connect to the server.',
          originalError: error,
        );

      // ----------------------------------------------------------
      // CANCELLED
      // ----------------------------------------------------------

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled.',
          originalError: error,
        );

      // ----------------------------------------------------------
      // BAD CERTIFICATE
      // ----------------------------------------------------------

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Secure connection could not be established.',
          originalError: error,
        );

      // ----------------------------------------------------------
      // BAD RESPONSE
      // ----------------------------------------------------------

      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Invalid server response.',
          originalError: error,
        );

      // ----------------------------------------------------------
      // UNKNOWN
      // ----------------------------------------------------------

      case DioExceptionType.unknown:
        return ApiException(
          message: 'Something went wrong. Please try again.',
          originalError: error,
        );
    }
  }
}
