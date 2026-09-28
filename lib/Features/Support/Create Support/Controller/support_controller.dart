import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/support_model.dart';
import '../Repo/support_repository.dart';

// ============================================================
// Support Provider
// ============================================================

final supportControllerProvider = Provider<SupportController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return SupportController(dioClient: dioClient);
});

// ============================================================
// Support Controller
// ============================================================

class SupportController {
  SupportController({required DioClient dioClient})
    : _repository = SupportRepository(dioClient);

  final SupportRepository _repository;

  // ==========================================================
  // Create Support Request
  // ==========================================================

  Future<SupportModel> createSupportRequest({
    required String subject,
    required String category,
    required String priority,
    required String message,
  }) async {
    try {
      final result = await _repository.createSupportRequest(
        subject: subject,
        category: category,
        priority: priority,
        message: message,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
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
