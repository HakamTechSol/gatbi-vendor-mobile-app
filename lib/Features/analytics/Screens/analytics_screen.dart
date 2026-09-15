import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Controller/analytics_controller.dart';
import '../Models/analytics_model.dart';
import '../Reuse Widgets/analytics_action_buttons.dart';
import '../Reuse Widgets/analytics_empty_state.dart';
import '../Reuse Widgets/analytics_filter.dart';
import '../Reuse Widgets/analytics_header.dart';
import '../Reuse Widgets/analytics_loading.dart';
import '../Reuse Widgets/analytics_stats_grid.dart';
import '../Reuse Widgets/quick_insights_section.dart';
import '../Reuse Widgets/top_products_section.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({
    super.key,
    this.onOrdersTap,
    this.onProductsTap,
    this.onProductTap,
    this.onViewAllProductsTap,
  });

  final VoidCallback? onOrdersTap;
  final VoidCallback? onProductsTap;

  final ValueChanged<AnalyticsTopProductModel>? onProductTap;
  final VoidCallback? onViewAllProductsTap;

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  AnalyticsModel? _analytics;

  // ============================================================
  // Current Selected Filter
  // ============================================================

  DateTime? _startDate;
  DateTime? _endDate;

  // ============================================================
  // Allowed Calendar Range
  //
  // Ye API ki ORIGINAL/default date range hai.
  // Filter lagne ke baad ye values change nahi hongi.
  // ============================================================

  DateTime? _minDate;
  DateTime? _maxDate;

  // ============================================================
  // Default Filter Range
  //
  // Clear Filter par isi range par wapas jayenge.
  // ============================================================

  DateTime? _defaultStartDate;
  DateTime? _defaultEndDate;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalytics();
    });
  }

  // ============================================================
  // Load Analytics
  // ============================================================

  Future<void> _loadAnalytics({DateTime? startDate, DateTime? endDate}) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final controller = ref.read(analyticsControllerProvider);

      final result = await controller.getAnalytics(
        start: _formatApiDate(startDate),
        end: _formatApiDate(endDate),
      );

      if (!mounted) {
        return;
      }

      final apiStart = _parseApiDate(result.dateRange?.start);

      final apiEnd = _parseApiDate(result.dateRange?.end);

      setState(() {
        _analytics = result;

        // ------------------------------------------------------
        // IMPORTANT:
        //
        // Default/allowed date range ONLY set on first response.
        //
        // Filtered API response ki date_range se ye overwrite
        // nahi honi chahiye.
        // ------------------------------------------------------

        if (_defaultStartDate == null && apiStart != null) {
          _defaultStartDate = apiStart;
          _minDate = apiStart;
        }

        if (_defaultEndDate == null && apiEnd != null) {
          _defaultEndDate = apiEnd;
          _maxDate = apiEnd;
        }

        // ------------------------------------------------------
        // First API response:
        // API default date range selected hoga.
        // ------------------------------------------------------

        if (_startDate == null && _defaultStartDate != null) {
          _startDate = _defaultStartDate;
        }

        if (_endDate == null && _defaultEndDate != null) {
          _endDate = _defaultEndDate;
        }

        // ------------------------------------------------------
        // Filtered API response:
        // User ki selected dates preserve hongi.
        // ------------------------------------------------------

        if (startDate != null) {
          _startDate = startDate;
        }

        if (endDate != null) {
          _endDate = endDate;
        }

        _isLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // Start Date
  // ============================================================

  void _onStartDateChanged(DateTime date) {
    setState(() {
      _startDate = date;

      // Keep date range valid.
      if (_endDate != null && date.isAfter(_endDate!)) {
        _endDate = date;
      }
    });

    _applyFilter();
  }

  // ============================================================
  // End Date
  // ============================================================

  void _onEndDateChanged(DateTime date) {
    setState(() {
      _endDate = date;
    });

    _applyFilter();
  }

  // ============================================================
  // Apply Filter
  // ============================================================

  void _applyFilter() {
    if (_startDate == null || _endDate == null) {
      return;
    }

    if (_startDate!.isAfter(_endDate!)) {
      return;
    }

    _loadAnalytics(startDate: _startDate, endDate: _endDate);
  }

  // ============================================================
  // Clear Filter
  // ============================================================

  Future<void> _clearFilter() async {
    if (_isLoading) {
      return;
    }

    // ----------------------------------------------------------
    // Restore ORIGINAL API default range.
    // ----------------------------------------------------------

    final defaultStart = _defaultStartDate;
    final defaultEnd = _defaultEndDate;

    if (defaultStart == null || defaultEnd == null) {
      return;
    }

    setState(() {
      _startDate = defaultStart;
      _endDate = defaultEnd;
      _errorMessage = null;
    });

    // ----------------------------------------------------------
    // Call API without start/end.
    //
    // Backend apna default analytics range return karega.
    // ----------------------------------------------------------

    await _loadAnalytics();
  }

  // ============================================================
  // Check Active Filter
  // ============================================================

  bool get _hasActiveFilter {
    if (_startDate == null ||
        _endDate == null ||
        _defaultStartDate == null ||
        _defaultEndDate == null) {
      return false;
    }

    return !_isSameDate(_startDate!, _defaultStartDate!) ||
        !_isSameDate(_endDate!, _defaultEndDate!);
  }

  // ============================================================
  // Compare Dates
  // ============================================================

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  // ============================================================
  // API Date Format
  // ============================================================

  String? _formatApiDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  // ============================================================
  // Parse API Date
  // ============================================================

  DateTime? _parseApiDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final parts = value.split('-');

    if (parts.length != 3) {
      return null;
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      return null;
    }

    try {
      final date = DateTime(year, month, day);

      // Prevent invalid dates such as 2026-02-31.
      if (date.year != year || date.month != month || date.day != day) {
        return null;
      }

      return date;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildBody()),
    );
  }

  // ============================================================
  // Body
  // ============================================================

  Widget _buildBody() {
    if (_isLoading && _analytics == null) {
      return const _AnalyticsScrollView(child: AnalyticsLoading());
    }

    if (_errorMessage != null && _analytics == null) {
      return _buildErrorState();
    }

    if (_analytics == null) {
      return const _AnalyticsScrollView(child: AnalyticsLoading());
    }

    return _buildContent();
  }

  // ============================================================
  // Content
  // ============================================================

  Widget _buildContent() {
    // ----------------------------------------------------------
    // Initial loading / filter loading
    // ----------------------------------------------------------

    if (_isLoading) {
      return const _AnalyticsScrollView(child: AnalyticsLoading());
    }

    // ----------------------------------------------------------
    // Error
    // ----------------------------------------------------------

    if (_errorMessage != null && _analytics == null) {
      return _buildErrorState();
    }

    // ----------------------------------------------------------
    // Safety check
    // ----------------------------------------------------------

    if (_analytics == null) {
      return const _AnalyticsScrollView(child: AnalyticsLoading());
    }

    final analytics = _analytics!;

    final stats = _buildStats(analytics.stats);

    final hasProducts = analytics.topProducts.isNotEmpty;

    final hasData = analytics.stats != null || analytics.topProducts.isNotEmpty;

    return _AnalyticsScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsHeader(),

          const SizedBox(height: 20),

          AnalyticsActionButtons(
            onOrdersTap: widget.onOrdersTap,
            onProductsTap: widget.onProductsTap,
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------
          // Date Filter
          // ----------------------------------------------------
          AnalyticsFilter(
            startDate: _startDate,
            endDate: _endDate,
            minDate: _minDate,
            maxDate: _maxDate,
            isLoading: _isLoading,
            onStartDateChanged: _onStartDateChanged,
            onEndDateChanged: _onEndDateChanged,
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------
          // Clear Filter
          // ----------------------------------------------------
          if (_hasActiveFilter)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _isLoading ? null : _clearFilter,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                label: const Text('Clear Filter'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

          const SizedBox(height: 14),

          // ----------------------------------------------------
          // Data / Empty State
          // ----------------------------------------------------
          if (!hasData)
            const AnalyticsEmptyState(buttonText: null)
          else ...[
            _buildSectionLabel(
              title: 'Overview',
              subtitle: 'Your store performance for the selected period',
            ),

            const SizedBox(height: 12),

            AnalyticsStatsGrid(stats: stats),

            if (hasProducts) ...[
              const SizedBox(height: 28),

              TopProductsSection(
                products: analytics.topProducts,
                onProductTap: widget.onProductTap,
                onViewAllTap: widget.onViewAllProductsTap,
              ),
            ],

            // ----------------------------------------------------
            // Pending Orders Insight Card (Image jaisa)
            // ----------------------------------------------------
            if (analytics.stats != null &&
                analytics.stats!.pendingOrders > 0) ...[
              const SizedBox(height: 20),
              PendingOrdersInsightCard(
                pendingOrders: analytics.stats!.pendingOrders,
                onReviewPressed:
                    null, // Abhi disabled hai, baad mein function denge
              ),
            ],
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ============================================================
  // Stats
  // ============================================================

  List<AnalyticsStatData> _buildStats(AnalyticsStatsModel? stats) {
    final data = stats ?? const AnalyticsStatsModel();

    return [

      AnalyticsStatData(
        title: 'Commission',
        value: _formatAmount(data.commissionTotal),
        subtitle: 'Gross : ${data.netSales}',
        icon: Icons.percent_rounded,
        iconColor: AppColors.warning,
        iconBackgroundColor: AppColors.warningLight,
      ),

      AnalyticsStatData(
        title: 'Net Sales',
        value: _formatAmount(data.netSales),
        subtitle: 'After commission',
        icon: Icons.account_balance_wallet_outlined,
        iconColor: AppColors.success,
        iconBackgroundColor: AppColors.successLight,
      ),

      AnalyticsStatData(
        title: 'Total Orders',
        value: data.totalOrders.toString(),
        subtitle: '${data.paidOrders} paid',
        icon: Icons.shopping_bag_outlined,
        iconColor: AppColors.info,
        iconBackgroundColor: AppColors.infoLight,
      ),

      AnalyticsStatData(
        title: 'Products',
        value: data.totalProducts.toString(),
        subtitle: '${data.activeProducts} active',
        icon: Icons.inventory_2_outlined,
        iconColor: AppColors.purple,
        iconBackgroundColor: AppColors.purpleLight,
      ),

      AnalyticsStatData(
        title: 'Orders Today',
        value: data.ordersToday.toString(),
        subtitle: 'Selected period',
        icon: Icons.today_outlined,
        iconColor: AppColors.primary,
        iconBackgroundColor: AppColors.primaryLight,
      ),
    ];
  }

  // ============================================================
  // Format Amount
  // ============================================================

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  // ============================================================
  // Section Label
  // ============================================================

  Widget _buildSectionLabel({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleLarge),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  // ============================================================
  // Error
  // ============================================================

  Widget _buildErrorState() {
    return _AnalyticsScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalyticsHeader(),

          const SizedBox(height: 20),

          AnalyticsActionButtons(
            onOrdersTap: widget.onOrdersTap,
            onProductsTap: widget.onProductsTap,
          ),

          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.errorBorder),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 30,
                    color: AppColors.error,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Unable to load analytics',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.emptyStateTitle,
                ),

                const SizedBox(height: 8),

                Text(
                  _errorMessage ?? 'Something went wrong. Please try again.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.emptyStateDescription,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _loadAnalytics(),
                    child: const Text('Try Again'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Scroll View
// ============================================================

class _AnalyticsScrollView extends StatelessWidget {
  const _AnalyticsScrollView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = _getHorizontalPadding(constraints.maxWidth);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: child,
          ),
        );
      },
    );
  }

  double _getHorizontalPadding(double width) {
    if (width >= 900) {
      return 32;
    }

    if (width >= 600) {
      return 24;
    }

    return 16;
  }
}
