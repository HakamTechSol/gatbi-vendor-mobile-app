import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/sample_csv_model.dart';
import '../Repo/sample_csv_repo.dart';

// ============================================================
// Sample CSV Provider
// ============================================================

final sampleCsvControllerProvider = Provider<SampleCsvController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return SampleCsvController(dioClient: dioClient);
});

// ============================================================
// Sample CSV Controller
// ============================================================

class SampleCsvController {
  SampleCsvController({required DioClient dioClient})
    : _repository = SampleCsvRepository(dioClient);

  final SampleCsvRepository _repository;

  // ==========================================================
  // Download Sample CSV
  // ==========================================================

  Future<SampleCsvModel> downloadSampleCsv() async {
    try {
      final result = await _repository.downloadSampleCsv();

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Unable to download sample CSV. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}