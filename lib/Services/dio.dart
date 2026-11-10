import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_url.dart';
import 'dio_client.dart';
import 'error_handler.dart';
import 'session_manager.dart';
import 'token_storage.dart';

part 'dio.g.dart';

@riverpod
DioClient dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,

      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),

      // Important:
      // Dio should treat HTTP errors as errors so that
      // ErrorHandler can process them.
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      // ==========================================================
      // REQUEST
      // ==========================================================
      onRequest: (options, handler) async {
        final token = await SecureStorageService.instance.getToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // --------------------------------------------------------
        // Debug logging (never log bodies, query values or tokens)
        // --------------------------------------------------------

        if (kDebugMode) {
          debugPrint('[API] ${options.method} ${options.uri}');
        }

        handler.next(options);
      },

      // ==========================================================
      // RESPONSE
      // ==========================================================
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint(
            '[API] ${response.statusCode} ${response.requestOptions.uri}',
          );
        }

        handler.next(response);
      },

      // ==========================================================
      // ERROR
      // ==========================================================
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (kDebugMode) {
          debugPrint(
            '[API] ${error.type} ${error.response?.statusCode ?? '-'} '
            '${error.requestOptions.uri}',
          );
        }

        final apiException = ErrorHandler.handle(error);

        final statusCode = apiException.statusCode;

        final requestPath = error.requestOptions.path;

        final hasToken = error.requestOptions.headers['Authorization'] != null;

        // ========================================================
        // Public endpoints
        // ========================================================

        final publicPaths = <String>[
          ApiUrls.login,
          ApiUrls.register,
          ApiUrls.verifyOtp,
          ApiUrls.forgotPassword,
          ApiUrls.resetPassword,
          ApiUrls.resendOtp,
          ApiUrls.socialProviders,
          ApiUrls.appleLogin,
        ];

        final isPublicSocial =
            requestPath == ApiUrls.socialProviders ||
            requestPath.startsWith('vendor/auth/social/');

        // ========================================================
        // Session Expired
        // ========================================================

        final isSessionError =
            statusCode == 401 &&
            hasToken &&
            !publicPaths.contains(requestPath) &&
            !isPublicSocial;

        if (isSessionError) {
          await SessionManager.handleSessionExpired();
        }

        // ========================================================
        // Reject with ApiException
        // ========================================================

        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: apiException,
          ),
        );
      },
    ),
  );

  return DioClient(dio);
}
