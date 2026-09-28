import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/payout_request_model.dart';

class PayoutRequestRepository {
  const PayoutRequestRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Request Payout
  // ============================================================

  Future<PayoutRequestModel> requestPayout({
    required String startDate,
    required String endDate,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.requestPayout,
      data: {'start_date': startDate, 'end_date': endDate},
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

    final result = PayoutRequestModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== PAYOUT REQUEST RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Request Period
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST PERIOD ----------');
      debugPrint('START DATE: $startDate');
      debugPrint('END DATE: $endDate');

      // --------------------------------------------------------
      // Payout
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAYOUT ----------');
      debugPrint('PAYOUT ID: ${result.payoutId ?? 'N/A'}');
      debugPrint('AMOUNT: ${result.amount ?? 0}');
      debugPrint('CURRENCY: ${result.currency ?? 'N/A'}');
      debugPrint(
        'CURRENCY SYMBOL: '
        '${result.currencySymbol ?? 'N/A'}',
      );
      debugPrint(
        'ORDERS INCLUDED: '
        '${result.ordersIncluded ?? 0}',
      );
      debugPrint('STATUS: ${result.status ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('');
    }

    return result;
  }
}
