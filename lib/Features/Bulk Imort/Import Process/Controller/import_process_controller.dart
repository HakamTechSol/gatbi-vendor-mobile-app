import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/import_process_model.dart';
import '../Repo/import_process_repository.dart';

final importProcessControllerProvider = Provider<ImportProcessController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return ImportProcessController(dioClient: dioClient);
});

class ImportProcessController {
  ImportProcessController({required DioClient dioClient})
    : _repository = ImportProcessRepository(dioClient);

  final ImportProcessRepository _repository;

  Future<ImportProcessModel> processImport({required String jobId}) async {
    try {
      final result = await _repository.processImport(jobId: jobId);

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Unable to process product import. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
