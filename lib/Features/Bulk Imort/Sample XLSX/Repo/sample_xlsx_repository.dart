import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/sample_xlsx_model.dart';

class SampleXlsxRepository {
  const SampleXlsxRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Download XLSX Template
  // ============================================================

  Future<SampleXlsxModel> downloadSampleXlsx() async {
    final response = await _dioClient.get<List<int>>(
      ApiUrls.downloadSampleXlsx,
      options: Options(responseType: ResponseType.bytes),
    );

    final data = response.data;

    if (data == null || data.isEmpty) {
      throw const ApiException(
        message: 'Invalid or empty XLSX template received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = SampleXlsxModel.fromResponse(data);

    if (!result.isNotEmpty) {
      throw const ApiException(
        message: 'XLSX template file is empty.',
        code: 'EMPTY_SAMPLE_XLSX',
      );
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== SAMPLE XLSX RESULT ==========');
      debugPrint('XLSX AVAILABLE: ${result.isNotEmpty}');
      debugPrint('XLSX SIZE: ${result.sizeInBytes} bytes');
      debugPrint('XLSX SIZE KB: ${result.sizeInKb.toStringAsFixed(2)} KB');
      debugPrint('========================================');
      debugPrint('');
    }

    return result;
  }
}
