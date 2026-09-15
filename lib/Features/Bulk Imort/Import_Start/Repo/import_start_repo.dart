import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/import_start_model.dart';

class ImportStartRepository {
  const ImportStartRepository(this._dioClient);

  final DioClient _dioClient;

  Future<ImportStartModel> startImport({
    required PlatformFile csvFile,
    required bool translateAr,
  }) async {
    // ============================================================
    // VALIDATE FILE PATH
    // ============================================================

    final filePath = csvFile.path?.trim();

    if (filePath == null || filePath.isEmpty) {
      throw const ApiException(
        message:
            'Unable to access the selected CSV file. '
            'Please select the file again.',
        code: 'CSV_FILE_PATH_MISSING',
      );
    }

    // ============================================================
    // CREATE MULTIPART FILE
    // ============================================================

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: csvFile.name,
      contentType: MediaType('text', 'csv'),
    );

    // ============================================================
    // CREATE FORM DATA
    // ============================================================

    final formData = FormData.fromMap({
      'csv_file': multipartFile,
      'translate_ar': translateAr ? '1' : '0',
    });

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== IMPORT START MULTIPART ==========');
      debugPrint('FILE NAME: ${csvFile.name}');
      debugPrint('FILE PATH: $filePath');
      debugPrint('TRANSLATE AR: ${translateAr ? '1' : '0'}');
      debugPrint('CONTENT TYPE: text/csv');
      debugPrint('============================================');
      debugPrint('');
    }

    // ============================================================
    // API REQUEST
    // ============================================================

    final response = await _dioClient.post<dynamic>(
      ApiUrls.startProductImports,
      data: formData,
    );

    // ============================================================
    // RESPONSE VALIDATION
    // ============================================================

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    if (data is! Map) {
      throw const ApiException(
        message: 'Invalid import response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final json = Map<String, dynamic>.from(data);

    final result = ImportStartModel.fromJson(json);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== IMPORT START RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('JOB ID: ${result.jobId}');
      debugPrint('JOB STARTED: ${result.isStarted}');
      debugPrint('=========================================');
      debugPrint('');
    }

    return result;
  }
}
