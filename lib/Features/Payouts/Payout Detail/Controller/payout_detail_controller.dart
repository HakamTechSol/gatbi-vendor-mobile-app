import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/payout_detail_model.dart';
import '../Repo/payout_detail_repository.dart';

// ============================================================
// Payout Detail Provider
// ============================================================

final payoutDetailControllerProvider = Provider<PayoutDetailController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return PayoutDetailController(dioClient: dioClient);
});

// ============================================================
// Payout Detail Controller
// ============================================================

class PayoutDetailController {
  PayoutDetailController({required DioClient dioClient})
    : _repository = PayoutDetailRepository(dioClient);

  final PayoutDetailRepository _repository;

  // ============================================================
  // Get Payout Detail
  // ============================================================

  Future<PayoutDetailModel> getPayoutDetail({required int payoutId}) async {
    try {
      final result = await _repository.getPayoutDetail(payoutId: payoutId);

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      // Is se statusCode, code aur error details preserve
      // rehti hain.
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
