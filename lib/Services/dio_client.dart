import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'error_handler.dart';

class DioClient {
  DioClient(this._dio);

  final Dio _dio;

  Dio get dio => _dio;

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
    dynamic data,
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
