import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Data/dummy_analytics_data.dart';
import '../Models/analytics_insight_model.dart';
import '../Models/analytics_model.dart';
import '../Models/top_product_model.dart';
import '../Reuse Widgets/analytics_action_buttons.dart';
import '../Reuse Widgets/analytics_empty_state.dart';
import '../Reuse Widgets/analytics_header.dart';
import '../Reuse Widgets/analytics_loading.dart';
import '../Reuse Widgets/quick_insights_section.dart';
import '../Reuse Widgets/top_products_section.dart';
import '../Reuse Widgets/analytics_stats_grid.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    super.key,
    this.analytics,
    this.isLoading = false,
    this.onOrdersTap,
    this.onProductsTap,
    this.onProductTap,
    this.onViewAllProductsTap,
    this.onInsightAction,
  });

  /// Optional API-ready analytics data.
  ///
  /// For now, if no data is provided, dummy data is used.
  final AnalyticsModel? analytics;

  /// Used later when API integration is connected.
  final bool isLoading;

  final VoidCallback? onOrdersTap;
  final VoidCallback? onProductsTap;

  final ValueChanged<TopProductModel>? onProductTap;
  final VoidCallback? onViewAllProductsTap;

  final ValueChanged<AnalyticsInsightModel>? onInsightAction;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late AnalyticsModel _analytics;

  @override
  void initState() {
    super.initState();

    _analytics = widget.analytics ?? DummyAnalyticsData.populated;
  }

  @override
  void didUpdateWidget(covariant AnalyticsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.analytics != oldWidget.analytics &&
        widget.analytics != null) {
      _analytics = widget.analytics!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.isLoading) {
      return const _AnalyticsScrollView(
        child: AnalyticsLoading(),
      );
    }

    if (_analytics.isEmpty) {
      return _buildEmptyState();
    }

    return _buildContent();
  }

  Widget _buildContent() {
    final stats = _analytics.stats.isNotEmpty
        ? _analytics.stats
        : DummyAnalyticsData.emptyStats;

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

          const SizedBox(height: 24),

          _buildSectionLabel(
            title: 'Overview',
            subtitle: 'Your store performance at a glance',
          ),

          const SizedBox(height: 12),

          AnalyticsStatsGrid(
            stats: stats,
          ),

          if (_analytics.hasTopProducts) ...[
            const SizedBox(height: 28),

            TopProductsSection(
              products: _analytics.topProducts,
              onProductTap: widget.onProductTap,
              onViewAllTap: widget.onViewAllProductsTap,
            ),
          ],

          if (_analytics.hasInsights) ...[
            const SizedBox(height: 28),

            QuickInsightsSection(
              insights: _analytics.insights,
              onInsightButtonPressed: widget.onInsightAction,
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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

          const AnalyticsEmptyState(
            buttonText: null,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionLabel({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge,
        ),
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
}

class _AnalyticsScrollView extends StatelessWidget {
  const _AnalyticsScrollView({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = _getHorizontalPadding(
          constraints.maxWidth,
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
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