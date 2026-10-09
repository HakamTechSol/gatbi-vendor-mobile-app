import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../Routes/app_route.dart';
import '../../../Services/api_exception.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../../Core/Bottom Naigation Bar/bottom_bar_screen.dart';
import '../../Routes/route_observer.dart';
import '../Settings/settings_controller.dart';
import '../Settings/settings_model.dart';
import 'Controller/dashboard_controller.dart';
import 'Models/dashboard_model.dart';
import 'Reuse Widgets/affiliate_section.dart';
import 'Reuse Widgets/dashboard_header.dart';
import 'Reuse Widgets/dashboard_shimmer.dart';
import 'Reuse Widgets/dashboard_stats_section.dart';
import 'Reuse Widgets/earnings_summary_section.dart';
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

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with RouteAware {
  DashboardModel? _dashboard;
  SettingsModel? _settings;

  bool _isLoading = true;
  bool _isRefreshing = false;

  String? _errorMessage;

  bool _isRouteSubscribed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isRouteSubscribed) {
      final route = ModalRoute.of(context);

      if (route is PageRoute) {
        routeObserver.subscribe(this, route);
        _isRouteSubscribed = true;
      }
    }
  }

  @override
  void dispose() {
    if (_isRouteSubscribed) {
      routeObserver.unsubscribe(this);
    }

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE AWARE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void didPushNext() {}

  @override
  void didPopNext() {
    if (!mounted) return;

    Future.microtask(_refreshDashboard);
  }

  @override
  void didPush() {}

  @override
  void didPop() {}

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD DASHBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadDashboard() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final dashboardController = ref.read(dashboardControllerProvider);

      final settingsController = ref.read(settingsControllerProvider);

      final dashboardResult = await dashboardController.getDashboard();

      final settingsResult = await settingsController.getSettings();

      if (!mounted) return;

      setState(() {
        _dashboard = dashboardResult;
        _settings = settingsResult;
        _isLoading = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REFRESH DASHBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _refreshDashboard() async {
    if (_isRefreshing) return;

    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });
    }

    try {
      final dashboardController = ref.read(dashboardControllerProvider);

      final settingsController = ref.read(settingsControllerProvider);

      final dashboardResult = await dashboardController.getDashboard();

      final settingsResult = await settingsController.getSettings();

      if (!mounted) return;

      setState(() {
        _dashboard = dashboardResult;
        _settings = settingsResult;
        _errorMessage = null;
        _isRefreshing = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.message;
        _isRefreshing = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isRefreshing = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalPadding = _getHorizontalPadding(screenWidth);

    if (_isLoading && _dashboard == null) {
      return _buildLoadingState(horizontalPadding);
    }

    if (_dashboard == null) {
      return _buildErrorState(horizontalPadding);
    }

    return _buildDashboard(context, horizontalPadding, _dashboard!);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE PADDING
  // ═══════════════════════════════════════════════════════════════════════════

  double _getHorizontalPadding(double width) {
    if (width < 360) {
      return 14;
    }

    if (width < 600) {
      return 16;
    }

    if (width < 1000) {
      return 24;
    }

    return 32;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DASHBOARD CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

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

    final vendorGross = stats?.vendorGross ?? 0;
    final vendorShippingTotal = stats?.vendorShippingTotal ?? 0;
    final vendorCommission = stats?.vendorCommission ?? 0;
    final vendorNet = stats?.vendorNet ?? 0;

    final commissionRate = stats?.commissionRateDisplay ?? 0;

    final affiliateReadyProducts = stats?.affiliateAllowed ?? 0;

    final hiddenFromAffiliates = stats?.affiliateBlocked ?? 0;

    final affiliateCommissionRate = stats?.affiliateCommissionRateDisplay ?? 0;

    final storeStatus = merchant?.status ?? '';
    final kycStatus = merchant?.kycStatus ?? '';

    final isStoreApproved = storeStatus.trim().toLowerCase() == 'approved';

    final isKycPending = kycStatus.trim().toLowerCase() == 'pending';

    final orderStatuses = dashboard.ordersByStatus;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ══════════════════════════════════════════════════════════════════════
      // APP BAR
      // ══════════════════════════════════════════════════════════════════════
      appBar: DashboardHeader(
        vendorName: _displayValue(merchant?.name, fallback: 'My Store'),
        isStoreApproved: isStoreApproved,
        onAddProduct: isStoreApproved
            ? () {
                context.push(AppRoutes.addProduct);
              }
            : null,
        onViewOrders: () {
          context.push(AppRoutes.orders);
        },
        onShopSettings: () {
          debugPrint('Shop Settings');
        },
      ),

      // ══════════════════════════════════════════════════════════════════════
      // BODY
      // ══════════════════════════════════════════════════════════════════════
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: _refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              18,
              horizontalPadding,
              36,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ═══════════════════════════════════════════════════════
                    // REFRESHING INDICATOR
                    // ═══════════════════════════════════════════════════════
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _isRefreshing
                          ? Padding(
                              key: const ValueKey('refreshing'),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const LinearProgressIndicator(
                                  minHeight: 3,
                                ),
                              ),
                            )
                          : const SizedBox(key: ValueKey('not-refreshing')),
                    ),

                    // ═══════════════════════════════════════════════════════
                    // ERROR MESSAGE
                    // ═══════════════════════════════════════════════════════
                    if (_errorMessage != null) ...[
                      _buildInlineError(),
                      const SizedBox(height: 14),
                    ],

                    // ═══════════════════════════════════════════════════════
                    // STORE STATUS
                    // ═══════════════════════════════════════════════════════
                    StoreStatusBanner(isStoreApproved: isStoreApproved),

                    if (!isStoreApproved) const SizedBox(height: 14),

                    // ═══════════════════════════════════════════════════════
                    // KYC STATUS
                    // ═══════════════════════════════════════════════════════
                    KycBanner(
                      isPending: isKycPending,
                      onView: () {
                        context.push(AppRoutes.kyc);
                      },
                    ),

                    if (isKycPending) const SizedBox(height: 18),

                    // ═══════════════════════════════════════════════════════
                    // EARNINGS
                    // ═══════════════════════════════════════════════════════
                    EarningsSummarySection(
                      grossAmount: vendorGross,
                      shippingAmount: vendorShippingTotal,
                      commissionAmount: vendorCommission,
                      netPayable: vendorNet,
                      commissionPercentage: commissionRate,
                      currencySymbol: 'د.إ',
                    ),

                    const SizedBox(height: 18),

                    // ═══════════════════════════════════════════════════════
                    // AFFILIATE
                    // ═══════════════════════════════════════════════════════
                    AffiliateSection(
                      affiliateReadyProducts: affiliateReadyProducts,
                      hiddenFromAffiliates: hiddenFromAffiliates,
                      commissionPercentage: affiliateCommissionRate,
                    ),

                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════════
                    // DASHBOARD STATS
                    // ═══════════════════════════════════════════════════════
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

                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════════
                    // RECENT ORDERS
                    // ═══════════════════════════════════════════════════════
                    RecentOrdersSection(
                      orders: _mapRecentOrders(dashboard.recentOrders),
                      onViewAll: () async {
                        await context.push(AppRoutes.orders);

                        if (!mounted) return;

                        await _refreshDashboard();
                      },
                      onOrderTap: (order) {
                        debugPrint('Selected order: ${order.orderId}');
                      },
                    ),

                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════════
                    // ORDER STATUS
                    // ═══════════════════════════════════════════════════════
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

                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════════
                    // PRODUCTS PREVIEW
                    // ═══════════════════════════════════════════════════════
                    ProductsPreviewSection(
                      products: dashboard.recentProducts,
                      onAddProduct: isStoreApproved
                          ? () {
                              context.push(AppRoutes.addProduct);
                            }
                          : null,
                      onManageProducts: () {
                        context.push(
                          AppRoutes.bottombar,
                          extra: BottomTab.products,
                        );
                      },
                      onProductTap: (product) {
                        debugPrint(
                          'Product tapped: '
                          '${product.id} - ${product.name}',
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════════
                    // SHOP SUMMARY
                    // ═══════════════════════════════════════════════════════
                    ShopSummaryCard(
                      status: _formatStatus(storeStatus),
                      kycStatus: _formatStatus(kycStatus),
                      businessType: _formatStatus(merchant?.businessType),
                      primaryCategory: merchant?.primaryCategoryId != null
                          ? 'Category #'
                                '${merchant!.primaryCategoryId}'
                          : '—',
                      supportEmail: _displayValue(merchant?.email),
                      warehouseAddress: _displayValue(
                        merchant?.warehouseAddress,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════════
                    // NEED HELP
                    // ═══════════════════════════════════════════════════════
                    NeedHelpCard(
                      supportEmail: _settings?.data?.vendorSupport?.email ?? '',
                      supportPhone: _settings?.data?.vendorSupport?.phone ?? '',
                      onCreateTicket: () {
                        context.push(AppRoutes.createTicket);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RECENT ORDERS MAPPER
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // DATE FORMAT
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // STRING VALUE
  // ═══════════════════════════════════════════════════════════════════════════

  String _displayValue(String? value, {String fallback = '—'}) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }

    return value.trim();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS FORMAT
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // INLINE ERROR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildInlineError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.13)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage ?? 'Something went wrong.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontSize: 10.5,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.error.withValues(alpha: 0.6),
            size: 17,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoadingState(double horizontalPadding) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: DashboardShimmer(horizontalPadding: horizontalPadding),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildErrorState(double horizontalPadding) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.65),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowStrong.withValues(alpha: 0.055),
                      blurRadius: 24,
                      offset: const Offset(0, 9),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.10),
                        ),
                      ),
                      child: const Icon(
                        Icons.cloud_off_rounded,
                        color: AppColors.error,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Unable to load dashboard',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _errorMessage ??
                          'Please check your connection '
                              'and try again.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 140,
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: _loadDashboard,
                        icon: const Icon(Icons.refresh_rounded, size: 17),
                        label: Text(
                          'Try Again',
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
