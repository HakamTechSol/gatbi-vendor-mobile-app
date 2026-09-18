import 'package:flutter/foundation.dart';

import '../../../../../../Services/api_exception.dart';
import '../../../../../../Services/api_url.dart';
import '../../../../../../Services/dio_client.dart';
import '../Model/reject_response_model.dart';

class PaymentProofRejectRepository {
  const PaymentProofRejectRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Reject Payment Proof
  // ============================================================

  Future<PaymentProofRejectResponseModel> rejectPaymentProof({
    required int orderId,
    required String reason,
    String? notes,
  }) async {
    // ----------------------------------------------------------
    // Validate Order ID
    // ----------------------------------------------------------

    if (orderId <= 0) {
      throw const ApiException(
        message: 'Invalid order ID.',
        code: 'INVALID_ORDER_ID',
      );
    }

    // ----------------------------------------------------------
    // Validate Reason
    // ----------------------------------------------------------

    final trimmedReason = reason.trim();

    if (trimmedReason.isEmpty) {
      throw const ApiException(
        message: 'Rejection reason is required.',
        code: 'INVALID_REASON',
      );
    }

    // ----------------------------------------------------------
    // Endpoint
    // ----------------------------------------------------------

    final endpoint = ApiUrls.rejectPaymentProof(orderId);

    // ----------------------------------------------------------
    // Request Body
    // ----------------------------------------------------------

    final Map<String, dynamic> body = {'reason': trimmedReason};

    final trimmedNotes = notes?.trim();

    if (trimmedNotes != null && trimmedNotes.isNotEmpty) {
      body['notes'] = trimmedNotes;
    }

    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('REJECT PAYMENT PROOF API');
      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('ORDER ID: $orderId');
      debugPrint('REQUEST BODY: $body');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Call
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      endpoint,
      data: body,
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = PaymentProofRejectResponseModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Response
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('REJECT PAYMENT PROOF RESULT');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      debugPrint('ORDER ID: $orderId');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('');
    }

    return result;
  }
}
