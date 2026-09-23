import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import 'my_product_export_model.dart';


class MyProductExportRepository {
  const MyProductExportRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Export Products CSV
  // ============================================================

  Future<MyProductExportModel> exportProductsCsv() async {
    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('MY PRODUCTS CSV EXPORT REQUEST');
      debugPrint(
        '============================================================',
      );
      debugPrint('METHOD: GET');
      debugPrint('URL: ${ApiUrls.exportProductsCsv}');
      debugPrint('RESPONSE TYPE: PLAIN TEXT');
      debugPrint(
        '============================================================',
      );
    }

    final response = await _dioClient.get<String>(
      ApiUrls.exportProductsCsv,
      options: Options(responseType: ResponseType.plain),
    );

    final csvContent = response.data;

    if (csvContent == null || csvContent.trim().isEmpty) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint(
          '============================================================',
        );
        debugPrint('CSV EXPORT ERROR');
        debugPrint(
          '============================================================',
        );
        debugPrint('Response is empty.');
        debugPrint(
          '============================================================',
        );
      }

      throw const ApiException(
        message: 'No CSV data was received from the server.',
        code: 'EMPTY_CSV_RESPONSE',
      );
    }

    final result = MyProductExportModel.fromResponse(csvContent);

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('MY PRODUCTS CSV EXPORT RESPONSE');
      debugPrint(
        '============================================================',
      );
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('CSV LENGTH: ${result.csvContent.length}');
      debugPrint('CSV EMPTY: ${result.isEmpty}');
      debugPrint('CSV PREVIEW:');
      debugPrint(
        result.csvContent.length > 500
            ? '${result.csvContent.substring(0, 500)}...'
            : result.csvContent,
      );
      debugPrint(
        '============================================================',
      );
    }

    return result;
  }
}
