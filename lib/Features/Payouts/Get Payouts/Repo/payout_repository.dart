import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/get_payout_model.dart';

class PayoutRepository {
  const PayoutRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Payouts
  // ============================================================

  Future<GetPayoutModel> getPayouts({
    int page = 1,
    int limit = 100,
    String? status,
  }) async {
    final queryParameters = <String, dynamic>{'page': page, 'limit': limit};

    // ----------------------------------------------------------
    // Status Filter
    // ----------------------------------------------------------

    if (status != null && status.trim().isNotEmpty) {
      queryParameters['status'] = status.trim().toLowerCase();
    }

    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.payouts,
      queryParameters: queryParameters,
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

    final result = GetPayoutModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final pagination = result.pagination;

      debugPrint('');
      debugPrint('========== GET PAYOUTS RESULT ==========');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- REQUEST ----------');
      debugPrint('PAGE: $page');
      debugPrint('LIMIT: $limit');
      debugPrint(
        'STATUS: '
        '${status?.trim().isNotEmpty == true ? status : 'ALL'}',
      );

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- GENERAL ----------');
      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Payouts
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAYOUTS ----------');
      debugPrint('PAYOUTS COUNT: ${result.payouts.length}');

      if (result.payouts.isNotEmpty) {
        for (final payout in result.payouts) {
          debugPrint(
            'PAYOUT: '
            '${payout.payoutNumber ?? 'N/A'} | '
            'ID: ${payout.id ?? 'N/A'} | '
            'AMOUNT: ${payout.amount ?? 0} '
            '${payout.currency ?? ''} | '
            'STATUS: ${payout.status ?? 'N/A'} | '
            'METHOD: '
            '${payout.paymentMethod ?? 'N/A'} | '
            'REFERENCE: '
            '${payout.paymentReference ?? 'N/A'}',
          );

          debugPrint(
            'PERIOD: '
            '${payout.periodStart ?? 'N/A'} '
            '-> '
            '${payout.periodEnd ?? 'N/A'}',
          );

          debugPrint(
            'CREATED AT: '
            '${payout.createdAt ?? 'N/A'}',
          );

          debugPrint(
            'PROCESSED AT: '
            '${payout.processedAt ?? 'N/A'}',
          );

          debugPrint(
            'PAID AT: '
            '${payout.paidAt ?? 'N/A'}',
          );

          debugPrint(
            'NOTES: '
            '${payout.notes ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // Pagination
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAGINATION ----------');
      debugPrint(
        'CURRENT PAGE: '
        '${pagination?.currentPage ?? 0}',
      );
      debugPrint(
        'TOTAL PAGES: '
        '${pagination?.totalPages ?? 0}',
      );
      debugPrint(
        'TOTAL ITEMS: '
        '${pagination?.totalItems ?? 0}',
      );
      debugPrint(
        'LIMIT: '
        '${pagination?.limit ?? 0}',
      );
      debugPrint(
        'HAS NEXT PAGE: '
        '${pagination?.hasNextPage ?? false}',
      );
      debugPrint(
        'NEXT PAGE: '
        '${pagination?.nextPage ?? 'N/A'}',
      );
      debugPrint(
        'HAS PREVIOUS PAGE: '
        '${pagination?.hasPreviousPage ?? false}',
      );
      debugPrint(
        'PREVIOUS PAGE: '
        '${pagination?.previousPage ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('========================================');
      debugPrint('');
    }

    return result;
  }
}
