import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class DashboardStatsSection extends StatelessWidget {
  const DashboardStatsSection({
    super.key,
    required this.totalProducts,
    required this.activeProducts,
    required this.totalOrders,
    required this.pendingOrders,
    required this.totalRevenue,
    required this.thisMonthRevenue,
    required this.ordersToday,
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  final int totalProducts;
  final int activeProducts;

  final int totalOrders;
  final int pendingOrders;

  final double totalRevenue;
  final double thisMonthRevenue;

  final int ordersToday;
  final int lowStockCount;
  final int outOfStockCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;
        final bool isVerySmall = width < 370;
        final bool isTablet = width >= 600 && width < 1000;

        final int crossAxisCount;

        if (width >= 1000) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 2;
        }

        final double horizontalGap = isMobile ? 10 : 14;
        final double verticalGap = isMobile ? 10 : 14;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatsSectionHeader(
              isMobile: isMobile,
            ),

            SizedBox(
              height: isMobile ? 14 : 18,
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: horizontalGap,
                mainAxisSpacing: verticalGap,
                mainAxisExtent: _getCardHeight(
                  width: width,
                  isVerySmall: isVerySmall,
                  isTablet: isTablet,
                ),
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _DashboardStatCard(
                      icon: Icons.inventory_2_rounded,
                      title: 'Total Products',
                      value: totalProducts.toString(),
                      description: '$activeProducts active products',
                      accentColor: AppColors.primary,
                      tone: _StatTone.primary,
                      trailing: _MiniMetric(
                        icon: Icons.check_circle_rounded,
                        label: '$activeProducts active',
                        color: AppColors.success,
                      ),
                      isCompact: isVerySmall,
                    );

                  case 1:
                    return _DashboardStatCard(
                      icon: Icons.shopping_bag_rounded,
                      title: 'Total Orders',
                      value: totalOrders.toString(),
                      description: pendingOrders > 0
                          ? '$pendingOrders orders need attention'
                          : 'No pending orders',
                      accentColor: AppColors.warning,
                      tone: pendingOrders > 0
                          ? _StatTone.warning
                          : _StatTone.success,
                      trailing: _MiniMetric(
                        icon: pendingOrders > 0
                            ? Icons.schedule_rounded
                            : Icons.check_circle_rounded,
                        label: pendingOrders > 0
                            ? '$pendingOrders pending'
                            : 'All clear',
                        color: pendingOrders > 0
                            ? AppColors.warning
                            : AppColors.success,
                      ),
                      isCompact: isVerySmall,
                    );

                  case 2:
                    return _DashboardStatCard(
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'Total Revenue',
                      value: _formatAmount(totalRevenue),
                      description:
                          '${_formatAmount(thisMonthRevenue)} generated this month',
                      accentColor: AppColors.success,
                      tone: _StatTone.success,
                      trailing: _MiniMetric(
                        icon: Icons.trending_up_rounded,
                        label: 'This month',
                        color: AppColors.success,
                      ),
                      isCompact: isVerySmall,
                    );

                  case 3:
                    final bool hasOutOfStock = outOfStockCount > 0;
                    final bool hasLowStock = lowStockCount > 0;

                    return _DashboardStatCard(
                      icon: Icons.today_rounded,
                      title: 'Orders Today',
                      value: ordersToday.toString(),
                      description: _buildInventoryDescription(
                        lowStockCount,
                        outOfStockCount,
                      ),
                      accentColor: AppColors.info,
                      tone: hasOutOfStock
                          ? _StatTone.danger
                          : hasLowStock
                              ? _StatTone.warning
                              : _StatTone.info,
                      trailing: _InventoryMetric(
                        lowStock: lowStockCount,
                        outOfStock: outOfStockCount,
                      ),
                      isCompact: isVerySmall,
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // CARD HEIGHT
  // ===========================================================================

  double _getCardHeight({
    required double width,
    required bool isVerySmall,
    required bool isTablet,
  }) {
    if (isVerySmall) {
      return 172;
    }

    if (width < 600) {
      return 180;
    }

    if (isTablet) {
      return 174;
    }

    return 168;
  }

  // ===========================================================================
  // REVENUE FORMAT
  // ===========================================================================

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return 'AED ${(amount / 1000000).toStringAsFixed(1)}M';
    }

    if (amount >= 1000) {
      return 'AED ${(amount / 1000).toStringAsFixed(1)}K';
    }

    return 'AED ${amount.toStringAsFixed(0)}';
  }

  // ===========================================================================
  // INVENTORY DESCRIPTION
  // ===========================================================================

  String _buildInventoryDescription(
    int lowStock,
    int outOfStock,
  ) {
    if (outOfStock > 0 && lowStock > 0) {
      return '$lowStock low stock • $outOfStock out of stock';
    }

    if (outOfStock > 0) {
      return '$outOfStock products out of stock';
    }

    if (lowStock > 0) {
      return '$lowStock products running low';
    }

    return 'Inventory looks healthy';
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================

class _StatsSectionHeader extends StatelessWidget {
  const _StatsSectionHeader({
    required this.isMobile,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ---------------------------------------------------------------------
        // ICON
        // ---------------------------------------------------------------------
        Container(
          width: isMobile ? 40 : 44,
          height: isMobile ? 40 : 44,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.insights_rounded,
            color: AppColors.white,
            size: isMobile ? 20 : 22,
          ),
        ),

        const SizedBox(width: 11),

        // ---------------------------------------------------------------------
        // TITLE
        // ---------------------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Store Overview',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 16 : 18,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Your store performance at a glance',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 10.5 : 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // ---------------------------------------------------------------------
        // OVERVIEW BADGE
        // ---------------------------------------------------------------------
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Overview',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// STAT TONE
// =============================================================================

enum _StatTone {
  primary,
  success,
  warning,
  danger,
  info,
}

// =============================================================================
// STAT CARD
// =============================================================================

class _DashboardStatCard extends StatelessWidget {
  const _DashboardStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    required this.accentColor,
    required this.tone,
    required this.trailing,
    required this.isCompact,
  });

  final IconData icon;
  final String title;
  final String value;
  final String description;

  final Color accentColor;
  final _StatTone tone;

  final Widget trailing;

  final bool isCompact;

  // ===========================================================================
  // TONE COLOR
  // ===========================================================================

  Color get toneColor {
    switch (tone) {
      case _StatTone.primary:
        return AppColors.primary;

      case _StatTone.success:
        return AppColors.success;

      case _StatTone.warning:
        return AppColors.warning;

      case _StatTone.danger:
        return AppColors.error;

      case _StatTone.info:
        return AppColors.info;
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.70),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // =================================================================
            // TOP ACCENT
            // =================================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.25),
                    ],
                  ),
                ),
              ),
            ),

            // =================================================================
            // DECORATIVE GLOW
            // =================================================================
            Positioned(
              top: -35,
              right: -30,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.065),
                ),
              ),
            ),

            // =================================================================
            // SECONDARY DECORATIVE CIRCLE
            // =================================================================
            Positioned(
              bottom: -45,
              left: -45,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.025),
                ),
              ),
            ),

            // =================================================================
            // CONTENT
            // =================================================================
            Padding(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 12 : 14,
                isCompact ? 13 : 15,
                isCompact ? 12 : 14,
                isCompact ? 12 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===========================================================
                  // ICON + TITLE
                  // ===========================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: isCompact ? 36 : 40,
                        height: isCompact ? 36 : 40,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: isCompact ? 18 : 20,
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isCompact ? 10 : 11,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ===========================================================
                  // MAIN VALUE
                  // ===========================================================
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 1,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: isCompact ? 24 : 27,
                        height: 1,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ===========================================================
                  // DESCRIPTION
                  // ===========================================================
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: isCompact ? 8.5 : 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // ===========================================================
                  // BOTTOM METRIC
                  // ===========================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: toneColor.withValues(alpha: 0.075),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: toneColor.withValues(alpha: 0.09),
                      ),
                    ),
                    child: trailing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MINI METRIC
// =============================================================================

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 13,
        ),

        const SizedBox(width: 5),

        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// INVENTORY METRIC
// =============================================================================

class _InventoryMetric extends StatelessWidget {
  const _InventoryMetric({
    required this.lowStock,
    required this.outOfStock,
  });

  final int lowStock;
  final int outOfStock;

  @override
  Widget build(BuildContext context) {
    final bool hasOutOfStock = outOfStock > 0;
    final bool hasLowStock = lowStock > 0;

    if (!hasOutOfStock && !hasLowStock) {
      return const _MiniMetric(
        icon: Icons.check_circle_rounded,
        label: 'Inventory healthy',
        color: AppColors.success,
      );
    }

    return Row(
      children: [
        if (hasLowStock) ...[
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 13,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$lowStock low',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warning,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],

        if (hasLowStock && hasOutOfStock)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.divider,
                shape: BoxShape.circle,
              ),
            ),
          ),

        if (hasOutOfStock) ...[
          const Icon(
            Icons.remove_circle_rounded,
            color: AppColors.error,
            size: 13,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$outOfStock out',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ],
    );
  }
}