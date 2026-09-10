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
        // Debug logging
        // --------------------------------------------------------

        print('');
        print('========== API REQUEST ==========');
        print('METHOD: ${options.method}');
        print('URL: ${options.uri}');
        print('QUERY: ${options.queryParameters}');
        print('BODY: ${options.data}');
        print('=================================');
        print('');

        handler.next(options);
      },

      // ==========================================================
      // RESPONSE
      // ==========================================================
      onResponse: (response, handler) {
        print('');
        print('========== API RESPONSE ==========');
        print('STATUS: ${response.statusCode}');
        print('URL: ${response.requestOptions.uri}');
        print('DATA: ${response.data}');
        print('==================================');
        print('');

        handler.next(response);
      },

      // ==========================================================
      // ERROR
      // ==========================================================
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        print('');
        print('========== API ERROR ==========');
        print('TYPE: ${error.type}');
        print('STATUS: ${error.response?.statusCode}');
        print('URL: ${error.requestOptions.uri}');
        print('MESSAGE: ${error.message}');
        print('RESPONSE: ${error.response?.data}');
        print('================================');
        print('');

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
        ];

        // ========================================================
        // Session Expired
        // ========================================================

        final isSessionError =
            statusCode == 401 && hasToken && !publicPaths.contains(requestPath);

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
