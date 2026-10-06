import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Model/cancel_business_change_model.dart';
import '../Repo/cancel_business_change_repository.dart';

// ============================================================
// Cancel Business Change Provider
// ============================================================

final cancelBusinessChangeControllerProvider =
    Provider<CancelBusinessChangeController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CancelBusinessChangeController(
    dioClient: dioClient,
  );
});

// ============================================================
// Cancel Business Change Controller
// ============================================================

class CancelBusinessChangeController {
  CancelBusinessChangeController({
    required DioClient dioClient,
  }) : _repository =
          CancelBusinessChangeRepository(dioClient);

  final CancelBusinessChangeRepository _repository;

  // ==========================================================
  // Cancel Business Change
  // ==========================================================

  Future<CancelBusinessChangeModel> cancelBusinessChange(
    int requestId,
  ) async {
    try {
      final result =
          await _repository.cancelBusinessChange(
        requestId,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.
      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}