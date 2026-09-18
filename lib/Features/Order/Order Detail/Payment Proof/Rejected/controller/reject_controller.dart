import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../Services/api_exception.dart';
import '../../../../../../Services/dio.dart';
import '../../../../../../Services/dio_client.dart';

import '../Model/reject_response_model.dart';
import '../Repo/reject_repository.dart';

// ============================================================
// Payment Proof Reject Provider
// ============================================================

final paymentProofRejectControllerProvider =
    Provider<PaymentProofRejectController>((ref) {
      final dioClient = ref.watch(dioProvider);

      return PaymentProofRejectController(dioClient: dioClient);
    });

// ============================================================
// Payment Proof Reject Controller
// ============================================================

class PaymentProofRejectController {
  PaymentProofRejectController({required DioClient dioClient})
    : _repository = PaymentProofRejectRepository(dioClient);

  final PaymentProofRejectRepository _repository;

  // ==========================================================
  // Reject Payment Proof
  // ==========================================================

  Future<PaymentProofRejectResponseModel> rejectPaymentProof({
    required int orderId,
    required String reason,
    String? notes,
  }) async {
    try {
      final result = await _repository.rejectPaymentProof(
        orderId: orderId,
        reason: reason,
        notes: notes,
      );

      return result;
    } on ApiException {
      // Existing ApiException ko as-is UI tak jane dein.
      //
      // Is se original API error ka:
      // - message
      // - code
      // - status information
      // preserve rahega.
      rethrow;
    } catch (error) {
      // Unexpected error ko standard ApiException
      // mein convert kar rahe hain.

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
