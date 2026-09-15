import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/sample_xlsx_model.dart';
import '../Repo/sample_xlsx_repository.dart';

final sampleXlsxControllerProvider = Provider<SampleXlsxController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return SampleXlsxController(dioClient: dioClient);
});

class SampleXlsxController {
  SampleXlsxController({required DioClient dioClient})
    : _repository = SampleXlsxRepository(dioClient);

  final SampleXlsxRepository _repository;

  // ============================================================
  // Download XLSX Template
  // ============================================================

  Future<SampleXlsxModel> downloadSampleXlsx() async {
    try {
      final result = await _repository.downloadSampleXlsx();

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Unable to download XLSX template. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
