import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/sample_csv_model.dart';

class SampleCsvRepository {
  const SampleCsvRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Download Sample CSV
  // ============================================================

  Future<SampleCsvModel> downloadSampleCsv() async {
    final response = await _dioClient.get<String>(
      ApiUrls.downloadSampleCsv,
      options: Options(responseType: ResponseType.plain),
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null || data.trim().isEmpty) {
      throw const ApiException(
        message: 'Invalid or empty sample CSV received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Sample CSV Model
    // ----------------------------------------------------------

    final result = SampleCsvModel.fromResponse(data);

    // ----------------------------------------------------------
    // Validate CSV
    // ----------------------------------------------------------

    if (!result.isNotEmpty) {
      throw const ApiException(
        message: 'Sample CSV file is empty.',
        code: 'EMPTY_SAMPLE_CSV',
      );
    }

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== SAMPLE CSV RESULT ==========');
      debugPrint('CSV AVAILABLE: ${result.isNotEmpty}');
      debugPrint('CSV LINES: ${result.lineCount}');
      debugPrint('CSV LENGTH: ${result.content.length}');
      debugPrint('=======================================');
      debugPrint('');
    }

    return result;
  }
}
