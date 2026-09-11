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

        // Responsive grid
        final crossAxisCount = width >= 900
            ? 4
            : width >= 600
            ? 3
            : 2;

        final isSmallScreen = width < 360;

        // Aspect ratio tuned to avoid overflow on all screens
        final childAspectRatio = isSmallScreen
            ? 0.92
            : width < 600
            ? 0.98
            : 1.05;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // SECTION HEADER
            // ============================================================
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store Overview',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A quick look at your store performance',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ============================================================
            // STATS GRID
            // ============================================================
            GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: childAspectRatio,
              children: [
                _DashboardStatCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Total Products',
                  value: totalProducts.toString(),
                  subtitle: '$activeProducts active',
                  accentColor: const Color(0xFF6366F1), // indigo
                  subtitleTone: _SubtitleTone.neutral,
                  isCompact: isSmallScreen,
                ),

                _DashboardStatCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Total Orders',
                  value: totalOrders.toString(),
                  subtitle: '$pendingOrders pending',
                  accentColor: const Color(0xFFF59E0B), // amber
                  subtitleTone: pendingOrders > 0
                      ? _SubtitleTone.warning
                      : _SubtitleTone.neutral,
                  isCompact: isSmallScreen,
                ),

                _DashboardStatCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Total Revenue',
                  value: _formatAmount(totalRevenue),
                  subtitle: '${_formatAmount(thisMonthRevenue)} this month',
                  accentColor: const Color(0xFF10B981), // emerald
                  subtitleTone: _SubtitleTone.success,
                  isCompact: isSmallScreen,
                ),

                _DashboardStatCard(
                  icon: Icons.today_outlined,
                  title: 'Orders Today',
                  value: ordersToday.toString(),
                  subtitle:
                      '$lowStockCount low · '
                      '$outOfStockCount out',
                  accentColor: const Color(0xFF3B82F6), // blue
                  subtitleTone: outOfStockCount > 0
                      ? _SubtitleTone.danger
                      : lowStockCount > 0
                      ? _SubtitleTone.warning
                      : _SubtitleTone.neutral,
                  isCompact: isSmallScreen,
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
// SUBTITLE TONE
// ═════════════════════════════════════════════════════════════════════════════

enum _SubtitleTone { neutral, success, warning, danger }

// ═════════════════════════════════════════════════════════════════════════════
// STAT CARD
// ═════════════════════════════════════════════════════════════════════════════

class _DashboardStatCard extends StatelessWidget {
  const _DashboardStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accentColor,
    required this.subtitleTone,
    required this.isCompact,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;
  final _SubtitleTone subtitleTone;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final Color subtitleColor = switch (subtitleTone) {
      _SubtitleTone.success => const Color(0xFF10B981),
      _SubtitleTone.warning => const Color(0xFFF59E0B),
      _SubtitleTone.danger => const Color(0xFFEF4444),
      _SubtitleTone.neutral => AppColors.textSecondary,
    };

    final Color subtitleBg = switch (subtitleTone) {
      _SubtitleTone.success => const Color(0xFF10B981).withValues(alpha: 0.10),
      _SubtitleTone.warning => const Color(0xFFF59E0B).withValues(alpha: 0.10),
      _SubtitleTone.danger => const Color(0xFFEF4444).withValues(alpha: 0.10),
      _SubtitleTone.neutral => AppColors.divider.withValues(alpha: 0.35),
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // ============================================================
            // TOP ACCENT BAR
            // ============================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.35)],
                  ),
                ),
              ),
            ),

            // ============================================================
            // SOFT GLOW (corner)
            // ============================================================
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.08),
                ),
              ),
            ),

            // ============================================================
            // CONTENT
            // ============================================================
            Padding(
              padding: EdgeInsets.all(isCompact ? 12 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- ICON + TITLE ----------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: isCompact ? 34 : 38,
                        height: isCompact ? 34 : 38,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.20),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: isCompact ? 17 : 19,
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
                            fontSize: isCompact ? 10.5 : 11.5,
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ---------- VALUE ----------
                  FittedBox(
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      maxLines: 1,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                        fontSize: isCompact ? 22 : 26,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ---------- SUBTITLE CHIP ----------
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 7 : 8,
                      vertical: isCompact ? 3 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: subtitleBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: subtitleColor,
                        fontSize: isCompact ? 9.5 : 10.5,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
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
