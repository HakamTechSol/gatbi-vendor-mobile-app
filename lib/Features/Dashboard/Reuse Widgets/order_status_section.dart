// lib/View/Vendor/Dashboard/widgets/order_status_section.dart

import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({
    super.key,
    this.pending = 0,
    this.processing = 0,
    this.shipped = 0,
    this.delivered = 0,
    this.cancelled = 0,
    this.onStatusTap,
  });

  final int pending;
  final int processing;
  final int shipped;
  final int delivered;
  final int cancelled;

  /// Returns the selected order status.
  final ValueChanged<String>? onStatusTap;

  @override
  Widget build(BuildContext context) {
    final int totalOrders =
        pending + processing + shipped + delivered + cancelled;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isVerySmall = constraints.maxWidth < 370;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withValues(alpha: 0.055),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderStatusHeader(totalOrders: totalOrders, isMobile: isMobile),

              SizedBox(height: isMobile ? 15 : 18),

              _OrderStatusGrid(
                statuses: [
                  _OrderStatusItem(
                    title: 'Pending',
                    count: pending,
                    icon: Icons.schedule_rounded,
                    color: AppColors.warning,
                    backgroundColor: const Color(0xFFFFF8E8),
                  ),
                  _OrderStatusItem(
                    title: 'Processing',
                    count: processing,
                    icon: Icons.sync_rounded,
                    color: AppColors.primary,
                    backgroundColor: const Color(0xFFF0F5FF),
                  ),
                  _OrderStatusItem(
                    title: 'Shipped',
                    count: shipped,
                    icon: Icons.local_shipping_rounded,
                    color: const Color(0xFF8B5CF6),
                    backgroundColor: const Color(0xFFF6F2FF),
                  ),
                  _OrderStatusItem(
                    title: 'Delivered',
                    count: delivered,
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    backgroundColor: const Color(0xFFECFBF4),
                  ),
                  _OrderStatusItem(
                    title: 'Cancelled',
                    count: cancelled,
                    icon: Icons.cancel_rounded,
                    color: AppColors.error,
                    backgroundColor: const Color(0xFFFFF1F1),
                  ),
                ],
                totalOrders: totalOrders,
                onStatusTap: onStatusTap,
                isMobile: isMobile,
                isVerySmall: isVerySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _OrderStatusHeader extends StatelessWidget {
  const _OrderStatusHeader({required this.totalOrders, required this.isMobile});

  final int totalOrders;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isMobile ? 42 : 46,
          height: isMobile ? 42 : 46,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow.withValues(alpha: 0.16),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.bar_chart_rounded,
            color: AppColors.white,
            size: isMobile ? 21 : 23,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Status',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 16 : 18,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Track your order progress',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 10 : 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 9 : 11,
            vertical: isMobile ? 7 : 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$totalOrders',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'TOTAL',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// STATUS GRID
// ============================================================================

class _OrderStatusGrid extends StatelessWidget {
  const _OrderStatusGrid({
    required this.statuses,
    required this.totalOrders,
    required this.onStatusTap,
    required this.isMobile,
    required this.isVerySmall,
  });

  final List<_OrderStatusItem> statuses;
  final int totalOrders;
  final ValueChanged<String>? onStatusTap;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = isMobile ? 9 : 12;

        final double cardWidth = (constraints.maxWidth - spacing) / 2;

        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _OrderStatusCard(
                    status: statuses[0],
                    totalOrders: totalOrders,
                    onTap: onStatusTap,
                    isMobile: isMobile,
                    isVerySmall: isVerySmall,
                  ),
                ),
                SizedBox(width: spacing),
                SizedBox(
                  width: cardWidth,
                  child: _OrderStatusCard(
                    status: statuses[1],
                    totalOrders: totalOrders,
                    onTap: onStatusTap,
                    isMobile: isMobile,
                    isVerySmall: isVerySmall,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing),

            Row(
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _OrderStatusCard(
                    status: statuses[2],
                    totalOrders: totalOrders,
                    onTap: onStatusTap,
                    isMobile: isMobile,
                    isVerySmall: isVerySmall,
                  ),
                ),
                SizedBox(width: spacing),
                SizedBox(
                  width: cardWidth,
                  child: _OrderStatusCard(
                    status: statuses[3],
                    totalOrders: totalOrders,
                    onTap: onStatusTap,
                    isMobile: isMobile,
                    isVerySmall: isVerySmall,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacing),

            Center(
              child: SizedBox(
                width: cardWidth,
                child: _OrderStatusCard(
                  status: statuses[4],
                  totalOrders: totalOrders,
                  onTap: onStatusTap,
                  isMobile: isMobile,
                  isVerySmall: isVerySmall,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// STATUS CARD
// ============================================================================

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({
    required this.status,
    required this.totalOrders,
    required this.onTap,
    required this.isMobile,
    required this.isVerySmall,
  });

  final _OrderStatusItem status;
  final int totalOrders;
  final ValueChanged<String>? onTap;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    final bool hasOrders = status.count > 0;

    final double percentage = totalOrders > 0 ? status.count / totalOrders : 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null ? null : () => onTap!(status.title),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(
            isVerySmall
                ? 10
                : isMobile
                ? 11
                : 13,
          ),
          decoration: BoxDecoration(
            color: hasOrders ? status.backgroundColor : AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasOrders
                  ? status.color.withValues(alpha: 0.13)
                  : AppColors.border.withValues(alpha: 0.55),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isMobile ? 37 : 40,
                    height: isMobile ? 37 : 40,
                    decoration: BoxDecoration(
                      color: hasOrders
                          ? status.color.withValues(alpha: 0.12)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: status.color.withValues(
                          alpha: hasOrders ? 0.12 : 0.07,
                        ),
                      ),
                    ),
                    child: Icon(
                      status.icon,
                      color: hasOrders ? status.color : AppColors.textSecondary,
                      size: isMobile ? 18 : 20,
                    ),
                  ),

                  const Spacer(),

                  if (hasOrders)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status.color.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(percentage * 100).round()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: status.color,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 11),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      status.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isVerySmall
                            ? 8.5
                            : isMobile
                            ? 9
                            : 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    '${status.count}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: hasOrders
                          ? AppColors.navy
                          : AppColors.textSecondary,
                      fontSize: isVerySmall
                          ? 17
                          : isMobile
                          ? 18
                          : 19,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 4,
                  width: double.infinity,
                  color: status.color.withValues(alpha: 0.08),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: hasOrders
                            ? status.color
                            : status.color.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MODEL
// ============================================================================

class _OrderStatusItem {
  const _OrderStatusItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}
