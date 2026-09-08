import 'package:flutter/material.dart';

import '../Models/analytics_insight_model.dart';
import '../Models/analytics_model.dart';
import '../Models/analytics_stat_model.dart';
import '../Models/top_product_model.dart';

class DummyAnalyticsData {
  DummyAnalyticsData._();

  // ---------------------------------------------------------------------------
  // EMPTY ANALYTICS
  // ---------------------------------------------------------------------------

  static const AnalyticsModel emptyAnalytics = AnalyticsModel(
    totalOrders: 0,
    todayOrders: 0,
    netSales: 0,
    paidOrders: 0,
    pendingOrders: 0,
    commission: 0,
    grossSales: 0,
    totalProducts: 0,
    activeProducts: 0,
    topProducts: [],
    insights: [
      AnalyticsInsightModel(
        title: 'Pending orders',
        message: 'You currently have 0 pending order(s).',
        buttonText: 'Review pending',
        icon: Icons.pending_actions_outlined,
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // EMPTY / DEFAULT STATS
  // ---------------------------------------------------------------------------

  static const List<AnalyticsStatModel> stats = [
    AnalyticsStatModel(
      title: 'Total Orders',
      value: '0',
      subtitle: 'Today: 0',
      icon: Icons.shopping_bag_outlined,
    ),
    AnalyticsStatModel(
      title: 'Net Sales',
      value: '0.00 AED',
      subtitle: 'Paid orders: 0',
      icon: Icons.payments_outlined,
    ),
    AnalyticsStatModel(
      title: 'Commission',
      value: '0.00 AED',
      subtitle: 'Gross: 0.00 AED',
      icon: Icons.account_balance_wallet_outlined,
    ),
    AnalyticsStatModel(
      title: 'Products',
      value: '0',
      subtitle: 'Active: 0',
      icon: Icons.inventory_2_outlined,
    ),
  ];

  // Alias used by AnalyticsScreen.
  static List<AnalyticsStatModel> get emptyStats => stats;

  // ---------------------------------------------------------------------------
  // EMPTY TOP PRODUCTS
  // ---------------------------------------------------------------------------

  static const List<TopProductModel> topProducts = [];

  // ---------------------------------------------------------------------------
  // EMPTY INSIGHTS
  // ---------------------------------------------------------------------------

  static const List<AnalyticsInsightModel> insights = [
    AnalyticsInsightModel(
      title: 'Pending orders',
      message: 'You currently have 0 pending order(s).',
      buttonText: 'Review pending',
      icon: Icons.pending_actions_outlined,
    ),
  ];

  // ---------------------------------------------------------------------------
  // POPULATED TOP PRODUCTS
  // ---------------------------------------------------------------------------

  static const List<TopProductModel> populatedTopProducts = [
    TopProductModel(
      id: 1,
      name: 'Premium Wireless Headphones',
      imageUrl: null,
      paidOrders: 24,
      revenue: 5976,
      currency: 'AED',
    ),
    TopProductModel(
      id: 2,
      name: 'Smart Watch Pro',
      imageUrl: null,
      paidOrders: 18,
      revenue: 4320,
      currency: 'AED',
    ),
    TopProductModel(
      id: 3,
      name: 'Bluetooth Speaker',
      imageUrl: null,
      paidOrders: 12,
      revenue: 2160,
      currency: 'AED',
    ),
  ];

  // ---------------------------------------------------------------------------
  // POPULATED STATS
  // ---------------------------------------------------------------------------

  static const List<AnalyticsStatModel> populatedStats = [
    AnalyticsStatModel(
      title: 'Total Orders',
      value: '54',
      subtitle: 'Today: 6',
      icon: Icons.shopping_bag_outlined,
    ),
    AnalyticsStatModel(
      title: 'Net Sales',
      value: '12,456.00 AED',
      subtitle: 'Paid orders: 48',
      icon: Icons.payments_outlined,
    ),
    AnalyticsStatModel(
      title: 'Commission',
      value: '622.80 AED',
      subtitle: 'Gross: 13,078.80 AED',
      icon: Icons.account_balance_wallet_outlined,
    ),
    AnalyticsStatModel(
      title: 'Products',
      value: '28',
      subtitle: 'Active: 24',
      icon: Icons.inventory_2_outlined,
    ),
  ];

  // ---------------------------------------------------------------------------
  // POPULATED INSIGHTS
  // ---------------------------------------------------------------------------

  static const List<AnalyticsInsightModel> populatedInsights = [
    AnalyticsInsightModel(
      title: 'Pending orders',
      message: 'You currently have 3 pending order(s).',
      buttonText: 'Review pending',
      type: AnalyticsInsightType.warning,
      icon: Icons.pending_actions_outlined,
    ),
    AnalyticsInsightModel(
      title: 'Sales are growing',
      message:
          'Your store generated 12,456.00 AED in net sales from paid orders.',
      buttonText: 'View orders',
      type: AnalyticsInsightType.success,
      icon: Icons.trending_up_rounded,
    ),
  ];

  // ---------------------------------------------------------------------------
  // POPULATED ANALYTICS
  // ---------------------------------------------------------------------------

  static const AnalyticsModel populatedAnalytics = AnalyticsModel(
    totalOrders: 54,
    todayOrders: 6,
    netSales: 12456,
    paidOrders: 48,
    pendingOrders: 3,
    commission: 622.80,
    grossSales: 13078.80,
    totalProducts: 28,
    activeProducts: 24,
    currency: 'AED',
    stats: populatedStats,
    topProducts: populatedTopProducts,
    insights: populatedInsights,
  );

  // Alias used by AnalyticsScreen.
  static AnalyticsModel get populated => populatedAnalytics;
}
