import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../Routes/app_route.dart';
import '../../../Services/api_exception.dart';
import '../../../Theme/app_colors.dart';

import 'Controller/dashboard_controller.dart';
import 'Models/dashboard_model.dart';
import 'Reuse Widgets/dashboard_header.dart';
import 'Reuse Widgets/dashboard_stats_section.dart';
import 'Reuse Widgets/kyc_banner.dart';
import 'Reuse Widgets/need_help_card.dart';
import 'Reuse Widgets/order_status_section.dart';
import 'Reuse Widgets/products_preview_section.dart';
import 'Reuse Widgets/recent_orders_section.dart';
import 'Reuse Widgets/shop_summary_card.dart';
import 'Reuse Widgets/store_status_banner.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DashboardModel? _dashboard;

  bool _isLoading = true;
  bool _isRefreshing = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  // ============================================================
  // LOAD DASHBOARD
  // ============================================================

  Future<void> _loadDashboard() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final controller = ref.read(dashboardControllerProvider);

      final result = await controller.getDashboard();

      if (!mounted) return;

      setState(() {
        _dashboard = result;
        _isLoading = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // REFRESH DASHBOARD
  // ============================================================

  Future<void> _refreshDashboard() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final controller = ref.read(dashboardControllerProvider);

      final result = await controller.getDashboard();

      if (!mounted) return;

      setState(() {
        _dashboard = result;
        _errorMessage = null;
        _isRefreshing = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.message;
        _isRefreshing = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isRefreshing = false;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalPadding = screenWidth < 360 ? 14.0 : 18.0;

    if (_isLoading && _dashboard == null) {
      return _buildLoadingState(horizontalPadding);
    }

    if (_dashboard == null) {
      return _buildErrorState(horizontalPadding);
    }

    return _buildDashboard(context, horizontalPadding, _dashboard!);
  }

  // ============================================================
  // DASHBOARD CONTENT
  // ============================================================

  Widget _buildDashboard(
    BuildContext context,
    double horizontalPadding,
    DashboardModel dashboard,
  ) {
    final merchant = dashboard.merchant;
    final stats = dashboard.stats;

    final totalProducts = stats?.totalProducts ?? 0;
    final activeProducts = stats?.activeProducts ?? 0;

    final totalOrders = stats?.totalOrders ?? 0;
    final pendingOrders = stats?.pendingOrders ?? 0;

    final totalRevenue = stats?.totalRevenue ?? 0;
    final monthlyRevenue = stats?.monthlyRevenue ?? 0;

    final ordersToday = stats?.ordersToday ?? 0;
    final lowStock = stats?.lowStock ?? 0;
    final outOfStock = stats?.outOfStock ?? 0;

    final storeStatus = merchant?.status ?? '';
    final kycStatus = merchant?.kycStatus ?? '';

    final isStoreApproved = storeStatus.trim().toLowerCase() == 'approved';

    final isKycPending = kycStatus.trim().toLowerCase() == 'pending';

    final orderStatuses = dashboard.ordersByStatus;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDashboard,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),

            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              16,
              horizontalPadding,
              30,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================================
                // REFRESHING INDICATOR
                // ==========================================================
                if (_isRefreshing)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),

                // ==========================================================
                // ERROR MESSAGE
                // ==========================================================
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildInlineError(),
                  ),

                // ==========================================================
                // HEADER
                // ==========================================================
                DashboardHeader(
                  vendorName: _displayValue(
                    merchant?.name,
                    fallback: 'My Store',
                  ),

                  isStoreApproved: isStoreApproved,

                  onViewOrders: () {
                    context.push(AppRoutes.orders);
                  },

                  onShopSettings: () {
                    debugPrint('Shop Settings');
                  },
                ),

                const SizedBox(height: 16),

                // ==========================================================
                // STORE STATUS
                // ==========================================================
                StoreStatusBanner(isStoreApproved: isStoreApproved),

                if (!isStoreApproved) const SizedBox(height: 16),

                // ==========================================================
                // KYC STATUS
                // ==========================================================
                KycBanner(
                  isPending: isKycPending,
                  onView: () {
                    debugPrint('Open KYC');
                  },
                ),

                if (isKycPending) const SizedBox(height: 16),

                // ==========================================================
                // EARNINGS
                //
                // Dashboard API does not provide complete earnings
                // breakdown, so we don't send fake values here.
                // ==========================================================

                // NOTE:
                // EarningsSummarySection intentionally skipped for now.
                //
                // Reason:
                // gross / commission / net payable aggregate values
                // are not available in dashboard API.

                // ==========================================================
                // AFFILIATE
                //
                // Dashboard API does not provide affiliate-ready count.
                // ==========================================================

                // NOTE:
                // AffiliateSection intentionally skipped for now.
                //
                // We will connect it when affiliate dashboard API fields
                // are available.

                // ==========================================================
                // DASHBOARD STATS
                // ==========================================================
                DashboardStatsSection(
                  totalProducts: totalProducts,
                  activeProducts: activeProducts,

                  totalOrders: totalOrders,
                  pendingOrders: pendingOrders,

                  totalRevenue: totalRevenue,
                  thisMonthRevenue: monthlyRevenue,

                  ordersToday: ordersToday,
                  lowStockCount: lowStock,
                  outOfStockCount: outOfStock,
                ),

                const SizedBox(height: 20),

                // ==========================================================
                // RECENT ORDERS
                // ==========================================================
                RecentOrdersSection(
                  orders: _mapRecentOrders(dashboard.recentOrders),

                  onViewAll: () {
                    context.push(AppRoutes.orders);
                  },

                  onOrderTap: (order) {
                    debugPrint('Selected order: ${order.orderId}');
                  },
                ),

                const SizedBox(height: 20),

                // ==========================================================
                // ORDER STATUS
                // ==========================================================
                OrderStatusSection(
                  pending: orderStatuses['pending'] ?? 0,
                  processing: orderStatuses['processing'] ?? 0,
                  shipped: orderStatuses['shipped'] ?? 0,
                  delivered: orderStatuses['delivered'] ?? 0,
                  cancelled:
                      orderStatuses['cancelled'] ??
                      orderStatuses['canceled'] ??
                      0,

                  onStatusTap: (status) {
                    debugPrint('Selected order status: $status');

                    context.push(AppRoutes.orders);
                  },
                ),

                const SizedBox(height: 20),

                // ==========================================================
                // PRODUCTS PREVIEW
                // ==========================================================
                ProductsPreviewSection(
                  products: dashboard.recentProducts,

                  onAddProduct: isStoreApproved
                      ? () {
                          context.push(AppRoutes.addProduct);
                        }
                      : null,

                  onManageProducts: () {
                    debugPrint('Manage products');

                    // Products route available ho to:
                    // context.push(AppRoutes.products);
                  },

                  onProductTap: (product) {
                    debugPrint(
                      'Product tapped: ${product.id} - ${product.name}',
                    );

                    // Product detail/edit route baad mein yahan connect kar sakte hain.
                  },
                ),

                const SizedBox(height: 20),

                // ==========================================================
                // SHOP SUMMARY
                // ==========================================================
                ShopSummaryCard(
                  status: _formatStatus(storeStatus),

                  kycStatus: _formatStatus(kycStatus),

                  businessType: _formatStatus(merchant?.businessType),

                  primaryCategory: merchant?.primaryCategoryId != null
                      ? 'Category #${merchant!.primaryCategoryId}'
                      : '—',

                  supportEmail: _displayValue(merchant?.email),

                  warehouseAddress: _displayValue(merchant?.warehouseAddress),
                ),

                const SizedBox(height: 20),

                // ==========================================================
                // NEED HELP
                // ==========================================================
                NeedHelpCard(
                  onEmailSupport: () {
                    debugPrint('Email Support');
                  },

                  onCallSupport: () {
                    debugPrint('Call Support');
                  },

                  onCreateTicket: () {
                    debugPrint('Create Support Ticket');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RECENT ORDERS MAPPER
  // ============================================================

  List<RecentOrderItem> _mapRecentOrders(List<dynamic> orders) {
    return orders.map((order) {
      final orderNumber = order.orderNumber?.toString();

      final customerEmail = order.userEmail?.toString();

      final amount = order.total ?? 0;

      final currency = order.currency?.toString() ?? 'AED';

      final status = order.orderStatus?.toString() ?? 'Unknown';

      final date = order.createdAt?.toString();

      return RecentOrderItem(
        orderId: orderNumber?.isNotEmpty == true
            ? orderNumber!
            : '#${order.id ?? ''}',

        customerName: customerEmail?.isNotEmpty == true
            ? customerEmail!
            : 'Customer',

        amount: '$currency ${amount.toStringAsFixed(2)}',

        status: _formatStatus(status),

        date: _formatDate(date),
      );
    }).toList();
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String? _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      final date = DateTime.parse(value.replaceFirst(' ', 'T'));

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      return '$day/$month/$year';
    } catch (_) {
      return value;
    }
  }

  // ============================================================
  // STRING VALUE
  // ============================================================

  String _displayValue(String? value, {String fallback = '—'}) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }

    return value.trim();
  }

  // ============================================================
  // STATUS FORMAT
  // ============================================================

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    final normalized = value.trim().replaceAll('_', ' ');

    return normalized
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;

          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  // ============================================================
  // INLINE ERROR
  // ============================================================

  Widget _buildInlineError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              _errorMessage ?? 'Something went wrong.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOADING STATE
  // ============================================================

  Widget _buildLoadingState(double horizontalPadding) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),

                const SizedBox(height: 14),

                Text(
                  'Loading dashboard...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(double horizontalPadding) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.cloud_off_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  'Unable to load dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _errorMessage ??
                      'Please check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: _loadDashboard,
                    child: const Text('Try Again'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
