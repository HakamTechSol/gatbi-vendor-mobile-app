import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/import_process_model.dart';

class ImportProcessRepository {
  const ImportProcessRepository(this._dioClient);

  final DioClient _dioClient;

  Future<ImportProcessModel> processImport({required String jobId}) async {
    final trimmedJobId = jobId.trim();

    if (trimmedJobId.isEmpty) {
      throw const ApiException(
        message: 'Import job ID is required.',
        code: 'INVALID_JOB_ID',
      );
    }

    final response = await _dioClient.post<dynamic>(
      ApiUrls.processProductImport,
      data: <String, dynamic>{'job_id': trimmedJobId},
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    if (data is! Map) {
      throw const ApiException(
        message: 'Invalid import process response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final json = Map<String, dynamic>.from(data);

    final result = ImportProcessModel.fromJson(json);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== IMPORT PROCESS RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message}');
      debugPrint('JOB ID: ${result.jobId}');
      debugPrint('OFFSET: ${result.offset}');
      debugPrint('TOTAL: ${result.total}');
      debugPrint('CREATED: ${result.created}');
      debugPrint('SKIPPED: ${result.skipped}');
      debugPrint('DONE: ${result.done}');
      debugPrint('ERROR COUNT: ${result.errors.length}');
      debugPrint('ERRORS: ${result.errors}');
      debugPrint('===========================================');
      debugPrint('');
    }

    return result;
  }
}
