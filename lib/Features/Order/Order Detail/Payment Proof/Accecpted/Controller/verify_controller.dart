import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../Services/api_exception.dart';
import '../../../../../../Services/dio.dart';
import '../../../../../../Services/dio_client.dart';
import '../Models/verify_response_model.dart';
import '../Repo/verify_repository.dart';

// ============================================================
// Payment Proof Verify Provider
// ============================================================

final paymentProofVerifyControllerProvider =
    Provider<PaymentProofVerifyController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return PaymentProofVerifyController(dioClient: dioClient);
    });

// ============================================================
// Payment Proof Verify Controller
// ============================================================

class PaymentProofVerifyController {
  PaymentProofVerifyController({required DioClient dioClient})
    : _repository = PaymentProofVerifyRepository(dioClient);

  final PaymentProofVerifyRepository _repository;

  // ==========================================================
  // Verify Payment Proof
  // ==========================================================

  Future<PaymentProofVerifyResponseModel> verifyPaymentProof({
    required int orderId,
  }) async {
    try {
      final result = await _repository.verifyPaymentProof(orderId: orderId);

      return result;
    } on ApiException {
      // --------------------------------------------------------
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur error details preserve
      // rehti hain.
      // --------------------------------------------------------

      rethrow;
    } catch (error) {
      // --------------------------------------------------------
      // Unexpected errors ko standard ApiException mein convert
      // kar rahe hain.
      // --------------------------------------------------------

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
