import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/dashboard_model.dart';

class DashboardRepository {
  const DashboardRepository(this._dioClient);

  final DioClient _dioClient;

  Future<DashboardModel> getDashboard() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.dashboard,
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = DashboardModel.fromJson(data);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== DASHBOARD RESULT ==========');
      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MERCHANT: ${result.merchant?.name ?? 'N/A'}');

      debugPrint('MERCHANT ID: ${result.merchant?.id ?? 'N/A'}');

      debugPrint('KYC STATUS: ${result.merchant?.kycStatus ?? 'N/A'}');

      debugPrint('TOTAL PRODUCTS: ${result.stats?.totalProducts ?? 0}');

      debugPrint('ACTIVE PRODUCTS: ${result.stats?.activeProducts ?? 0}');

      debugPrint('TOTAL ORDERS: ${result.stats?.totalOrders ?? 0}');

      debugPrint('TOTAL REVENUE: ${result.stats?.totalRevenue ?? 0}');

      debugPrint('PENDING ORDERS: ${result.stats?.pendingOrders ?? 0}');

      debugPrint('LOW STOCK: ${result.stats?.lowStock ?? 0}');

      debugPrint('OUT OF STOCK: ${result.stats?.outOfStock ?? 0}');

      debugPrint('MONTHLY REVENUE: ${result.stats?.monthlyRevenue ?? 0}');

      debugPrint('ORDERS TODAY: ${result.stats?.ordersToday ?? 0}');

      debugPrint('ORDERS BY STATUS: ${result.ordersByStatus}');

      debugPrint('RECENT ORDERS: ${result.recentOrders.length}');

      debugPrint('RECENT PRODUCTS: ${result.recentProducts.length}');

      debugPrint(
        'KYC PRODUCT LIMIT: '
        '${result.productAccess?.kycLimit ?? 0}',
      );

      debugPrint(
        'KYC LIMIT REACHED: '
        '${result.productAccess?.kycLimitReached ?? false}',
      );

      debugPrint('=====================================');
      debugPrint('');
    }

    return result;
  }
}
