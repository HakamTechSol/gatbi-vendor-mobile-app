import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import 'my_product_export_model.dart';
import 'my_product_export_repository.dart';

// ============================================================
// Provider
// ============================================================

final myProductExportControllerProvider = Provider<MyProductExportController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return MyProductExportController(dioClient: dioClient);
});

// ============================================================
// Controller
// ============================================================

class MyProductExportController {
  MyProductExportController({required DioClient dioClient})
    : _repository = MyProductExportRepository(dioClient);

  final MyProductExportRepository _repository;

  // ============================================================
  // Export Products CSV
  // ============================================================

  Future<MyProductExportModel> exportProductsCsv() async {
    try {
      final result = await _repository.exportProductsCsv();

      return result;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Unable to export products. Please try again.',
        code: 'EXPORT_CSV_ERROR',
        originalError: error,
      );
    }
  }
}
