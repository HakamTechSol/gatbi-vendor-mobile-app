import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/dashboard_model.dart';

class DashboardRepository {
  const DashboardRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Dashboard
  // ============================================================

  Future<DashboardModel> getDashboard() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.dashboard,
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
    // Convert API Response -> Dashboard Model
    // ----------------------------------------------------------

    final result = DashboardModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final merchant = result.merchant;
      final stats = result.stats;
      final productAccess = result.productAccess;

      debugPrint('');
      debugPrint('========== DASHBOARD RESULT ==========');

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
      debugPrint('MERCHANT EMAIL: ${merchant?.email ?? 'N/A'}');
      debugPrint('MERCHANT PHONE: ${merchant?.phone ?? 'N/A'}');
      debugPrint('MERCHANT STATUS: ${merchant?.status ?? 'N/A'}');
      debugPrint('KYC STATUS: ${merchant?.kycStatus ?? 'N/A'}');
      debugPrint('BUSINESS TYPE: ${merchant?.businessType ?? 'N/A'}');

      // --------------------------------------------------------
      // Basic Stats
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- BASIC STATS ----------');
      debugPrint('TOTAL PRODUCTS: ${stats?.totalProducts ?? 0}');
      debugPrint('ACTIVE PRODUCTS: ${stats?.activeProducts ?? 0}');
      debugPrint('TOTAL ORDERS: ${stats?.totalOrders ?? 0}');
      debugPrint('PENDING ORDERS: ${stats?.pendingOrders ?? 0}');
      debugPrint('LOW STOCK: ${stats?.lowStock ?? 0}');
      debugPrint('OUT OF STOCK: ${stats?.outOfStock ?? 0}');
      debugPrint('ORDERS TODAY: ${stats?.ordersToday ?? 0}');

      // --------------------------------------------------------
      // Vendor Revenue
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- VENDOR REVENUE ----------');
      debugPrint('VENDOR GROSS: ${stats?.vendorGross ?? 0}');
      debugPrint(
        'VENDOR SHIPPING TOTAL: '
        '${stats?.vendorShippingTotal ?? 0}',
      );
      debugPrint('VENDOR COMMISSION: ${stats?.vendorCommission ?? 0}');
      debugPrint('VENDOR NET: ${stats?.vendorNet ?? 0}');
      debugPrint('TOTAL REVENUE: ${stats?.totalRevenue ?? 0}');

      // --------------------------------------------------------
      // Commission
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- COMMISSION ----------');
      debugPrint(
        'COMMISSION RATE DISPLAY: '
        '${stats?.commissionRateDisplay ?? 0}',
      );
      debugPrint(
        'COMMISSION RATE: '
        '${stats?.commissionRate ?? 0}',
      );
      debugPrint(
        'AFFILIATE COMMISSION RATE DISPLAY: '
        '${stats?.affiliateCommissionRateDisplay ?? 0}',
      );
      debugPrint(
        'AFFILIATE ALLOWED: '
        '${stats?.affiliateAllowed ?? 0}',
      );
      debugPrint(
        'AFFILIATE BLOCKED: '
        '${stats?.affiliateBlocked ?? 0}',
      );

      // --------------------------------------------------------
      // Monthly Revenue
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- MONTHLY REVENUE ----------');
      debugPrint(
        'MONTHLY REVENUE PRODUCTS: '
        '${stats?.monthlyRevenueProducts ?? 0}',
      );
      debugPrint(
        'MONTHLY REVENUE COMMISSION: '
        '${stats?.monthlyRevenueCommission ?? 0}',
      );
      debugPrint(
        'MONTHLY REVENUE: '
        '${stats?.monthlyRevenue ?? 0}',
      );

      // --------------------------------------------------------
      // Orders By Status
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ORDERS BY STATUS ----------');
      debugPrint('ORDERS BY STATUS: ${result.ordersByStatus}');

      // --------------------------------------------------------
      // Recent Orders
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RECENT ORDERS ----------');
      debugPrint(
        'RECENT ORDERS COUNT: '
        '${result.recentOrders.length}',
      );

      if (result.recentOrders.isNotEmpty) {
        for (final order in result.recentOrders) {
          debugPrint(
            'ORDER: '
            '${order.orderNumber ?? 'N/A'} | '
            'STATUS: ${order.orderStatus ?? 'N/A'} | '
            'PAYMENT: ${order.paymentStatus ?? 'N/A'} | '
            'TOTAL: ${order.total ?? 0} '
            '${order.currency ?? ''} | '
            'TRANSACTION: '
            '${order.transactionId ?? 'N/A'} | '
            'STOCK RESTORED: ${order.stockRestored}',
          );
        }
      }

      // --------------------------------------------------------
      // Recent Products
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RECENT PRODUCTS ----------');
      debugPrint(
        'RECENT PRODUCTS COUNT: '
        '${result.recentProducts.length}',
      );

      if (result.recentProducts.isNotEmpty) {
        for (final product in result.recentProducts) {
          debugPrint(
            'PRODUCT: '
            '${product.name ?? 'N/A'} | '
            'ID: ${product.id ?? 'N/A'} | '
            'PRICE: ${product.price ?? 0} '
            '${product.currency ?? ''} | '
            'STOCK: ${product.stockQuantity ?? 0} | '
            'STATUS: ${product.stockStatus ?? 'N/A'} | '
            'VARIANTS: ${product.variants.length}',
          );
        }
      }

      // --------------------------------------------------------
      // Product Access / KYC Limit
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRODUCT ACCESS ----------');
      debugPrint(
        'KYC STATUS: '
        '${productAccess?.kycStatus ?? 'N/A'}',
      );
      debugPrint(
        'KYC PRODUCT LIMIT: '
        '${productAccess?.kycLimit ?? 0}',
      );
      debugPrint(
        'KYC LIMIT REACHED: '
        '${productAccess?.kycLimitReached ?? false}',
      );
      debugPrint(
        'REMAINING SLOTS: '
        '${productAccess?.remainingSlots ?? 'N/A'}',
      );

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
