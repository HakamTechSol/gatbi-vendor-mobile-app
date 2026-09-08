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
        final isSmallScreen = constraints.maxWidth < 360;

        final crossAxisCount = constraints.maxWidth >= 700 ? 4 : 2;

        final childAspectRatio = isSmallScreen ? 1.05 : 1.18;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Overview',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'A quick look at your store performance',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
              children: [
                _DashboardStatCard(
                  icon: Icons.inventory_2_outlined,
                  iconBackgroundColor: AppColors.primaryLight,
                  iconColor: AppColors.primary,
                  title: 'Total Products',
                  value: totalProducts.toString(),
                  subtitle: '$activeProducts active',
                ),

                _DashboardStatCard(
                  icon: Icons.shopping_bag_outlined,
                  iconBackgroundColor: AppColors.primaryLight,
                  iconColor: AppColors.primary,
                  title: 'Total Orders',
                  value: totalOrders.toString(),
                  subtitle: '$pendingOrders pending',
                ),

                _DashboardStatCard(
                  icon: Icons.account_balance_wallet_outlined,
                  iconBackgroundColor: AppColors.primaryLight,
                  iconColor: AppColors.primary,
                  title: 'Total Revenue',
                  value: _formatAmount(totalRevenue),
                  subtitle: '${_formatAmount(thisMonthRevenue)} this month',
                ),

                _DashboardStatCard(
                  icon: Icons.today_outlined,
                  iconBackgroundColor: AppColors.primaryLight,
                  iconColor: AppColors.primary,
                  title: 'Orders Today',
                  value: ordersToday.toString(),
                  subtitle:
                      '$lowStockCount low stock • '
                      '$outOfStockCount out',
                  subtitleMaxLines: 2,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return 'AED ${(amount / 1000000).toStringAsFixed(1)}M';
    }

    if (amount >= 1000) {
      return 'AED ${(amount / 1000).toStringAsFixed(1)}K';
    }

    return 'AED ${amount.toStringAsFixed(0)}';
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STAT CARD
// ═════════════════════════════════════════════════════════════════════════════

class _DashboardStatCard extends StatelessWidget {
  const _DashboardStatCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    this.subtitleMaxLines = 1,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  final String title;
  final String value;
  final String subtitle;

  final int subtitleMaxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 165;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON + TITLE
              Row(
                children: [
                  Container(
                    width: isCompact ? 34 : 38,
                    height: isCompact ? 34 : 38,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: isCompact ? 18 : 20,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isCompact ? 10 : 11,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // VALUE
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  maxLines: 1,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: isCompact ? 20 : 22,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // SUBTITLE
              Text(
                subtitle,
                maxLines: subtitleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isCompact ? 9 : 10,
                  height: 1.25,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
