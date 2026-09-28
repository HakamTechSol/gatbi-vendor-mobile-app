import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/payout_request_model.dart';
import '../Repo/payout_request_repository.dart';

// ============================================================
// Payout Request Provider
// ============================================================

final payoutRequestControllerProvider = Provider<PayoutRequestController>((
  ref,
) {
  final dioClient = ref.watch(dioProvider);

  return PayoutRequestController(dioClient: dioClient);
});

// ============================================================
// Payout Request Controller
// ============================================================

class PayoutRequestController {
  PayoutRequestController({required DioClient dioClient})
    : _repository = PayoutRequestRepository(dioClient);

  final PayoutRequestRepository _repository;

  // ==========================================================
  // Request Payout
  // ==========================================================

  Future<PayoutRequestModel> requestPayout({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final result = await _repository.requestPayout(
        startDate: startDate,
        endDate: endDate,
      );

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
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
