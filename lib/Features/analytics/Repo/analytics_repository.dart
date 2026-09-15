import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/analytics_model.dart';

class AnalyticsRepository {
  const AnalyticsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Analytics
  // ============================================================

  Future<AnalyticsModel> getAnalytics({String? start, String? end}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.analytics,
      queryParameters: {
        if (start != null && start.trim().isNotEmpty) 'start': start,
        if (end != null && end.trim().isNotEmpty) 'end': end,
      },
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
    // Convert API Response -> Analytics Model
    // ----------------------------------------------------------

    final result = AnalyticsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final merchant = result.merchant;
      final dateRange = result.dateRange;
      final stats = result.stats;

      debugPrint('');
      debugPrint('========== ANALYTICS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Merchant
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- MERCHANT ----------');
      debugPrint('MERCHANT ID: ${merchant?.id ?? 'N/A'}');
      debugPrint('MERCHANT NAME: ${merchant?.name ?? 'N/A'}');
      debugPrint('MERCHANT STATUS: ${merchant?.status ?? 'N/A'}');

      // --------------------------------------------------------
      // Date Range
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- DATE RANGE ----------');
      debugPrint('START: ${dateRange?.start ?? 'N/A'}');
      debugPrint('END: ${dateRange?.end ?? 'N/A'}');

      // --------------------------------------------------------
      // Stats
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ANALYTICS STATS ----------');

      debugPrint('TOTAL PRODUCTS: ${stats?.totalProducts ?? 0}');

      debugPrint('ACTIVE PRODUCTS: ${stats?.activeProducts ?? 0}');

      debugPrint('TOTAL ORDERS: ${stats?.totalOrders ?? 0}');

      debugPrint('PAID ORDERS: ${stats?.paidOrders ?? 0}');

      debugPrint('GROSS SALES: ${stats?.grossSales ?? 0}');

      debugPrint('COMMISSION TOTAL: ${stats?.commissionTotal ?? 0}');

      debugPrint('NET SALES: ${stats?.netSales ?? 0}');

      debugPrint('ORDERS TODAY: ${stats?.ordersToday ?? 0}');

      debugPrint('PENDING ORDERS: ${stats?.pendingOrders ?? 0}');

      // --------------------------------------------------------
      // Top Products
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- TOP PRODUCTS ----------');

      debugPrint('TOP PRODUCTS COUNT: ${result.topProducts.length}');

      if (result.topProducts.isNotEmpty) {
        for (final product in result.topProducts) {
          debugPrint(
            'PRODUCT: '
            '${product.name ?? 'N/A'} | '
            'ID: ${product.id ?? 'N/A'} | '
            'SLUG: ${product.slug ?? 'N/A'} | '
            'UNITS: ${product.units} | '
            'REVENUE: ${product.revenue}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=====================================');
      debugPrint('');
    }

    return result;
  }
}
