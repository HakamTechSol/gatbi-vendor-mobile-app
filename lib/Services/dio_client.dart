import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'error_handler.dart';

class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  Dio get dio => _dio;

  // ============================================================
  // AUTH TOKEN MANAGEMENT
  // ============================================================

  /// Updates the Authorization header for future requests.
  /// Called during login / OTP verify when a token is received.
  void updateAuthToken(String? token) {
    if (token != null && token.trim().isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer ${token.trim()}';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Clears the Authorization header (used during logout).
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // ============================================================
  // GET
  // ============================================================

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _convertError(error);
    }
  }

  // ============================================================
  // POST
  // ============================================================

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _convertError(error);
    }
  }

  // ============================================================
  // PUT
  // ============================================================

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _convertError(error);
    }
  }

  // ============================================================
  // PATCH
  // ============================================================

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _convertError(error);
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw _convertError(error);
    }
  }

  // ============================================================
  // ERROR CONVERTER
  // ============================================================

  Object _convertError(DioException error) {
    // ----------------------------------------------------------
    // Already converted to ApiException
    // ----------------------------------------------------------

    if (error.error is ApiException) {
      return error.error as ApiException;
    }

    // ----------------------------------------------------------
    // Normal DioException
    // ----------------------------------------------------------

    return ErrorHandler.handle(error);
  }
}
