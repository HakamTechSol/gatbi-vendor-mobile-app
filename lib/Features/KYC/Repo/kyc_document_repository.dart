import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio_client.dart';
import '../Models/kyc_document_download_result.dart';

class KycDocumentDownloadRepository {
  const KycDocumentDownloadRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Download KYC Document
  // ============================================================

  Future<KycDocumentDownloadResult> downloadDocument({
    required String endpoint,
    required String fallbackFileName,
    String? mimeType,
  }) async {
    if (endpoint.trim().isEmpty) {
      throw const ApiException(
        message: 'Document URL is not available.',
        code: 'MISSING_DOCUMENT_URL',
      );
    }

    try {
      // ==========================================================
      // IMPORTANT:
      //
      // Dio baseUrl:
      // https://gatbi.ae/api/mobile/
      //
      // API file_url:
      // /api/mobile/vendor/kyc/document/11
      //
      // We must remove /api/mobile/ from the endpoint before
      // passing it to Dio.
      // ==========================================================

      final normalizedEndpoint = _normalizeEndpoint(endpoint);

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('       KYC DOCUMENT ENDPOINT              ');
        debugPrint('==========================================');
        debugPrint('ORIGINAL ENDPOINT   : $endpoint');
        debugPrint('NORMALIZED ENDPOINT : $normalizedEndpoint');
        debugPrint('==========================================');
        debugPrint('');
      }

      // ==========================================================
      // API Request
      // ==========================================================

      final response = await _dioClient.get<List<int>>(
        normalizedEndpoint,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 60),
          headers: <String, String>{'Accept': '*/*'},
        ),
      );

      // ==========================================================
      // Validate Response
      // ==========================================================

      final data = response.data;

      if (data == null || data.isEmpty) {
        throw const ApiException(
          message: 'Downloaded document is empty.',
          code: 'EMPTY_DOCUMENT',
        );
      }

      final bytes = Uint8List.fromList(data);

      // ==========================================================
      // Resolve MIME Type
      // ==========================================================

      final responseMimeType = response.headers.value(
        Headers.contentTypeHeader,
      );

      final detectedMimeType = _detectMimeType(bytes);

      final resolvedMimeType =
          _normalizeMimeType(responseMimeType) ??
          detectedMimeType ??
          _normalizeMimeType(mimeType) ??
          'application/octet-stream';

      // ==========================================================
      // Resolve File Name
      // ==========================================================

      final serverFileName = _extractFileNameFromHeaders(response);

      final resolvedFileName = _buildFileName(
        serverFileName: serverFileName,
        fallbackFileName: fallbackFileName,
        mimeType: resolvedMimeType,
      );

      // ==========================================================
      // Debug
      // ==========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('       KYC DOCUMENT DOWNLOAD SUCCESS      ');
        debugPrint('==========================================');
        debugPrint('REQUEST URL    : ${response.requestOptions.uri}');
        debugPrint('STATUS CODE    : ${response.statusCode}');
        debugPrint('SERVER MIME    : ${responseMimeType ?? 'N/A'}');
        debugPrint('DETECTED MIME  : ${detectedMimeType ?? 'N/A'}');
        debugPrint('RESOLVED MIME  : $resolvedMimeType');
        debugPrint('FILE NAME      : $resolvedFileName');
        debugPrint('BYTES RECEIVED : ${bytes.length}');
        debugPrint('==========================================');
        debugPrint('');
      }

      return KycDocumentDownloadResult(
        bytes: bytes,
        mimeType: resolvedMimeType,
        fileName: resolvedFileName,
      );
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('       KYC DOCUMENT API ERROR             ');
        debugPrint('==========================================');
        debugPrint('STATUS   : ${error.response?.statusCode}');
        debugPrint('URL      : ${error.requestOptions.uri}');
        debugPrint('MESSAGE  : ${error.message}');
        debugPrint('RESPONSE : ${error.response?.data}');
        debugPrint('==========================================');
        debugPrint('');
      }

      throw ApiException(
        message: _getDioErrorMessage(error),
        code: 'DOCUMENT_DOWNLOAD_FAILED',
        statusCode: error.response?.statusCode,
        originalError: error,
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('==========================================');
        debugPrint('       KYC DOCUMENT UNKNOWN ERROR         ');
        debugPrint('==========================================');
        debugPrint('ERROR: $error');
        debugPrint('STACK TRACE:');
        debugPrint('$stackTrace');
        debugPrint('==========================================');
        debugPrint('');
      }

      throw ApiException(
        message: 'Unable to download document. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }

  // ============================================================
  // Normalize Endpoint
  // ============================================================

  String _normalizeEndpoint(String endpoint) {
    var value = endpoint.trim();

    if (value.isEmpty) {
      return value;
    }

    // ----------------------------------------------------------
    // Absolute URL
    //
    // Example:
    // https://gatbi.ae/api/mobile/vendor/kyc/document/11
    // ----------------------------------------------------------

    if (value.startsWith('http://') || value.startsWith('https://')) {
      final uri = Uri.tryParse(value);

      if (uri != null) {
        value = uri.path;

        if (uri.hasQuery) {
          value = '$value?${uri.query}';
        }
      }
    }

    // ----------------------------------------------------------
    // Remove leading slash
    // ----------------------------------------------------------

    value = value.replaceFirst(RegExp(r'^/+'), '');

    // ----------------------------------------------------------
    // Remove duplicated API base path
    //
    // api/mobile/vendor/...
    //          ↓
    // vendor/...
    // ----------------------------------------------------------

    const apiPrefix = 'api/mobile/';

    if (value.toLowerCase().startsWith(apiPrefix)) {
      value = value.substring(apiPrefix.length);
    }

    // ----------------------------------------------------------
    // Final cleanup
    // ----------------------------------------------------------

    value = value.replaceFirst(RegExp(r'^/+'), '');

    return value;
  }

  // ============================================================
  // Normalize MIME Type
  // ============================================================

  String? _normalizeMimeType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final mime = value.split(';').first.trim().toLowerCase();

    if (mime.isEmpty ||
        mime == 'application/octet-stream' ||
        mime == 'binary/octet-stream') {
      return null;
    }

    return mime;
  }

  // ============================================================
  // Detect MIME Type From Bytes
  // ============================================================

  String? _detectMimeType(Uint8List bytes) {
    if (bytes.length < 4) {
      return null;
    }

    // ----------------------------------------------------------
    // JPEG
    // FF D8 FF
    // ----------------------------------------------------------

    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'image/jpeg';
    }

    // ----------------------------------------------------------
    // PNG
    // ----------------------------------------------------------

    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return 'image/png';
    }

    // ----------------------------------------------------------
    // GIF
    // ----------------------------------------------------------

    if (bytes.length >= 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x38) {
      return 'image/gif';
    }

    // ----------------------------------------------------------
    // WEBP
    // RIFF....WEBP
    // ----------------------------------------------------------

    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'image/webp';
    }

    // ----------------------------------------------------------
    // PDF
    // %PDF
    // ----------------------------------------------------------

    if (bytes.length >= 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return 'application/pdf';
    }

    return null;
  }

  // ============================================================
  // Extract File Name
  // ============================================================

  String? _extractFileNameFromHeaders(Response<List<int>> response) {
    final contentDisposition = response.headers.value('content-disposition');

    if (contentDisposition == null || contentDisposition.trim().isEmpty) {
      return null;
    }

    // filename="trade_license.jpg"
    final quotedMatch = RegExp(
      r'filename="([^"]+)"',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    if (quotedMatch != null) {
      final fileName = quotedMatch.group(1)?.trim();

      if (fileName != null && fileName.isNotEmpty) {
        return fileName;
      }
    }

    // filename=trade_license.jpg
    final normalMatch = RegExp(
      r'filename=([^;]+)',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    if (normalMatch != null) {
      final fileName = normalMatch.group(1)?.trim();

      if (fileName != null && fileName.isNotEmpty) {
        return fileName.replaceAll('"', '');
      }
    }

    return null;
  }

  // ============================================================
  // Build File Name
  // ============================================================

  String _buildFileName({
    required String? serverFileName,
    required String fallbackFileName,
    required String mimeType,
  }) {
    if (serverFileName != null && serverFileName.trim().isNotEmpty) {
      return _sanitizeFileName(serverFileName);
    }

    final fallback = _sanitizeFileName(fallbackFileName);

    if (_hasExtension(fallback)) {
      return fallback;
    }

    return '$fallback${_extensionFromMimeType(mimeType)}';
  }

  // ============================================================
  // MIME -> Extension
  // ============================================================

  String _extensionFromMimeType(String mimeType) {
    switch (mimeType.toLowerCase()) {
      case 'image/jpeg':
      case 'image/jpg':
        return '.jpg';

      case 'image/png':
        return '.png';

      case 'image/webp':
        return '.webp';

      case 'image/gif':
        return '.gif';

      case 'application/pdf':
        return '.pdf';

      case 'text/plain':
        return '.txt';

      case 'application/json':
        return '.json';

      default:
        return '.bin';
    }
  }

  // ============================================================
  // Check Extension
  // ============================================================

  bool _hasExtension(String fileName) {
    final lastPart = fileName.split('/').last;

    return lastPart.contains('.') && !lastPart.endsWith('.');
  }

  // ============================================================
  // Sanitize File Name
  // ============================================================

  String _sanitizeFileName(String fileName) {
    final cleaned = fileName.trim().replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_');

    return cleaned.isEmpty ? 'kyc_document' : cleaned;
  }

  // ============================================================
  // Dio Error Message
  // ============================================================

  String _getDioErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return 'Your session has expired. Please login again.';
    }

    if (statusCode == 403) {
      return 'You do not have permission to access this document.';
    }

    if (statusCode == 404) {
      return 'KYC document was not found.';
    }

    if (statusCode == 500) {
      return 'Server error while downloading the document.';
    }

    return 'Unable to download document. Please try again.';
  }
}
