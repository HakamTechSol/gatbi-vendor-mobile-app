import 'package:flutter/foundation.dart';

import '../../../../../../Services/api_exception.dart';
import '../../../../../../Services/api_url.dart';
import '../../../../../../Services/dio_client.dart';
import '../Models/verify_response_model.dart';

class PaymentProofVerifyRepository {
  const PaymentProofVerifyRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Verify Payment Proof
  // ============================================================

  Future<PaymentProofVerifyResponseModel> verifyPaymentProof({
    required int orderId,
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
    // Endpoint
    // ----------------------------------------------------------

    final endpoint = ApiUrls.verifyPaymentProof(orderId);

    // ----------------------------------------------------------
    // Debug Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('VERIFY PAYMENT PROOF API');
      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: $endpoint');
      debugPrint('ORDER ID: $orderId');
      debugPrint('REQUEST BODY: NONE');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('');
    }

    // ----------------------------------------------------------
    // API Call
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(endpoint);

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

    final result = PaymentProofVerifyResponseModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Result
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('VERIFY PAYMENT PROOF RESULT');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Message
      // --------------------------------------------------------

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Order
      // --------------------------------------------------------

      debugPrint('ORDER ID: $orderId');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('');
    }

    return result;
  }
}
