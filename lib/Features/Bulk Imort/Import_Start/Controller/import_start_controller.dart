import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/import_start_model.dart';
import '../Repo/import_start_repo.dart';

final importStartControllerProvider = Provider<ImportStartController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return ImportStartController(dioClient: dioClient);
});

class ImportStartController {
  ImportStartController({required DioClient dioClient})
    : _repository = ImportStartRepository(dioClient);

  final ImportStartRepository _repository;

  Future<ImportStartModel> startImport({
    required PlatformFile csvFile,
    required bool translateAr,
  }) async {
    try {
      final result = await _repository.startImport(
        csvFile: csvFile,
        translateAr: translateAr,
      );

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Unable to start product import. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
