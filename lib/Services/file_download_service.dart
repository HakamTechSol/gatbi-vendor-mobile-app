import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadService {
  const FileDownloadService();

  static const String channelName = 'com.gatbi.gatbivender/file_download';

  static const MethodChannel _channel = MethodChannel(channelName);

  // ============================================================
  // Save Text File
  // ============================================================

  Future<File> saveTextFile({
    required String content,
    required String fileName,
  }) async {
    _validateFileName(fileName);

    if (Platform.isAndroid) {
      final savedPath = await _saveTextFileOnAndroid(
        content: content,
        fileName: fileName,
      );

      return File(savedPath);
    }

    return _saveTextFileLocally(content: content, fileName: fileName);
  }

  // ============================================================
  // Save Bytes File
  // ============================================================

  Future<File> saveBytesFile({
    required List<int> bytes,
    required String fileName,
    String? mimeType,
  }) async {
    _validateFileName(fileName);

    if (bytes.isEmpty) {
      throw const FileSystemException('Cannot save an empty file.');
    }

    final resolvedMimeType = mimeType ?? _getMimeType(fileName);

    if (Platform.isAndroid) {
      final savedPath = await _saveBytesFileOnAndroid(
        bytes: bytes,
        fileName: fileName,
        mimeType: resolvedMimeType,
      );

      return File(savedPath);
    }

    return _saveBytesFileLocally(bytes: bytes, fileName: fileName);
  }

  // ============================================================
  // Android - Save Text
  // ============================================================

  Future<String> _saveTextFileOnAndroid({
    required String content,
    required String fileName,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'saveTextFile',
        <String, dynamic>{
          'content': content,
          'fileName': fileName,
          'mimeType': _getMimeType(fileName),
        },
      );

      if (result == null || result.trim().isEmpty) {
        throw const FileSystemException('Unable to save file to Downloads.');
      }

      return result.trim();
    } on PlatformException catch (error) {
      throw FileSystemException(
        error.message?.trim().isNotEmpty == true
            ? error.message!
            : 'Unable to save file to Downloads.',
        fileName,
      );
    } on MissingPluginException {
      throw FileSystemException(
        'File download service is not registered in Android.',
        fileName,
      );
    }
  }

  // ============================================================
  // Android - Save Bytes
  // ============================================================

  Future<String> _saveBytesFileOnAndroid({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final base64Data = base64Encode(bytes);

      final result = await _channel.invokeMethod<String>(
        'saveBytesFile',
        <String, dynamic>{
          'bytes': base64Data,
          'fileName': fileName,
          'mimeType': mimeType,
        },
      );

      if (result == null || result.trim().isEmpty) {
        throw const FileSystemException('Unable to save file to Downloads.');
      }

      return result.trim();
    } on PlatformException catch (error) {
      throw FileSystemException(
        error.message?.trim().isNotEmpty == true
            ? error.message!
            : 'Unable to save file to Downloads.',
        fileName,
      );
    } on MissingPluginException {
      throw FileSystemException(
        'File download service is not registered in Android.',
        fileName,
      );
    }
  }

  // ============================================================
  // Local - Save Text
  // ============================================================

  Future<File> _saveTextFileLocally({
    required String content,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    return file.writeAsString(content, flush: true);
  }

  // ============================================================
  // Local - Save Bytes
  // ============================================================

  Future<File> _saveBytesFileLocally({
    required List<int> bytes,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    return file.writeAsBytes(bytes, flush: true);
  }

  // ============================================================
  // MIME Type
  // ============================================================

  String _getMimeType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    switch (extension) {
      case 'csv':
        return 'text/csv';

      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

      case 'xls':
        return 'application/vnd.ms-excel';

      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'pdf':
        return 'application/pdf';

      case 'txt':
        return 'text/plain';

      case 'json':
        return 'application/json';

      default:
        return 'application/octet-stream';
    }
  }

  // ============================================================
  // File Name Validation
  // ============================================================

  void _validateFileName(String fileName) {
    final trimmedFileName = fileName.trim();

    if (trimmedFileName.isEmpty) {
      throw const FileSystemException('File name cannot be empty.');
    }

    if (trimmedFileName.contains('/') || trimmedFileName.contains('\\')) {
      throw const FileSystemException('Invalid file name.');
    }
  }
}
