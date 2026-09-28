import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/get_payout_model.dart';
import '../Repo/payout_repository.dart';

// ============================================================
// Payout Controller Provider
// ============================================================

final payoutControllerProvider = Provider<PayoutController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return PayoutController(dioClient: dioClient);
});

// ============================================================
// Payout Controller
// ============================================================

class PayoutController {
  PayoutController({required DioClient dioClient})
    : _repository = PayoutRepository(dioClient);

  final PayoutRepository _repository;

  // ==========================================================
  // Get Payouts
  // ==========================================================

  Future<GetPayoutModel> getPayouts({
    int page = 1,
    int limit = 100,
    String? status,
  }) async {
    try {
      final result = await _repository.getPayouts(
        page: page,
        limit: limit,
        status: status,
      );

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak
      // jane dein.
      //
      // Is se statusCode, code aur error details
      // preserve rehti hain.

      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException
      // mein convert kar rahe hain.

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
