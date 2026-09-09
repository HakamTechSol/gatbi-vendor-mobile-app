import 'package:dio/dio.dart';
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

        return handler.next(options);
      },

      // ==========================================================
      // RESPONSE
      // ==========================================================
      onResponse: (response, handler) {
        return handler.next(response);
      },

      // ==========================================================
      // ERROR
      // ==========================================================
      onError: (DioException error, handler) async {
        print('============== DIO ERROR ==============');

        print('TYPE: ${error.type}');

        print('MESSAGE: ${error.message}');

        print('ERROR: ${error.error}');

        print('STATUS: ${error.response?.statusCode}');

        print('PATH: ${error.requestOptions.path}');

        print('=======================================');

        final apiException = ErrorHandler.handle(error);

        final statusCode = apiException.statusCode;

        final requestPath = error.requestOptions.path;

        final hasToken = error.requestOptions.headers.containsKey(
          'Authorization',
        );

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
        ];

        // ========================================================
        // Session Expired
        // ========================================================

        if (statusCode == 401 &&
            hasToken &&
            !publicPaths.contains(requestPath)) {
          await SessionManager.handleSessionExpired();
        }

        // ========================================================
        // Reject with ApiException
        // ========================================================

        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: apiException,
            response: error.response,
            type: error.type,
          ),
        );
      },
    ),
  );

  return DioClient(dio);
}
