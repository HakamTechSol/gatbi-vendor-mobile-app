import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/payout_detail_model.dart';

class PayoutDetailRepository {
  const PayoutDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Payout Detail
  // ============================================================

  Future<PayoutDetailModel> getPayoutDetail({
    required int payoutId,
  }) async {
    final response =
        await _dioClient.get<Map<String, dynamic>>(
      '${ApiUrls.payouts}/$payoutId',
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
    // Convert API Response -> Payout Detail Model
    // ----------------------------------------------------------

    final result = PayoutDetailModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final payout = result.payout;

      debugPrint('');
      debugPrint(
        '========== PAYOUT DETAIL RESULT ==========',
      );

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Payout
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAYOUT ----------');

      debugPrint(
        'PAYOUT ID: ${payout?.id ?? 'N/A'}',
      );

      debugPrint(
        'PAYOUT NUMBER: '
        '${payout?.payoutNumber ?? 'N/A'}',
      );

      debugPrint(
        'AMOUNT: '
        '${payout?.amount ?? 0} '
        '${payout?.currency ?? ''}',
      );

      debugPrint(
        'CURRENCY SYMBOL: '
        '${payout?.currencySymbol ?? 'N/A'}',
      );

      debugPrint(
        'STATUS: '
        '${payout?.status ?? 'N/A'}',
      );

      debugPrint(
        'PAYMENT METHOD: '
        '${payout?.paymentMethod ?? 'N/A'}',
      );

      debugPrint(
        'PAYMENT REFERENCE: '
        '${payout?.paymentReference ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Period
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PERIOD ----------');

      debugPrint(
        'PERIOD START: '
        '${payout?.periodStart ?? 'N/A'}',
      );

      debugPrint(
        'PERIOD END: '
        '${payout?.periodEnd ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Notes
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- NOTES ----------');

      debugPrint(
        'NOTES: '
        '${payout?.notes ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Processing Dates
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PROCESSING ----------');

      debugPrint(
        'PROCESSED AT: '
        '${payout?.processedAt ?? 'N/A'}',
      );

      debugPrint(
        'PAID AT: '
        '${payout?.paidAt ?? 'N/A'}',
      );

      debugPrint(
        'CREATED AT: '
        '${payout?.createdAt ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Items
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAYOUT ITEMS ----------');

      debugPrint(
        'ITEMS COUNT: '
        '${payout?.items.length ?? 0}',
      );

      if (payout?.items.isNotEmpty ?? false) {
        for (final item in payout!.items) {
          debugPrint(
            'ITEM: '
            '${item.id ?? 'N/A'} | '
            'ORDER: ${item.orderNumber ?? 'N/A'} | '
            'ORDER TOTAL: ${item.orderTotal ?? 0} | '
            'COMMISSION RATE: '
            '${item.commissionRate ?? 0}% | '
            'COMMISSION: '
            '${item.commissionAmount ?? 0} | '
            'VENDOR AMOUNT: '
            '${item.vendorAmount ?? 0}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint(
        '===========================================',
      );
      debugPrint('');
    }

    return result;
  }
}