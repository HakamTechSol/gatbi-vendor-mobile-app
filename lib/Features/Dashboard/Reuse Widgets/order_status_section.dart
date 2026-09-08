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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 16),

          _buildStatusGrid(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.primary,
            size: 20,
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
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Track your order progress',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS GRID
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusGrid() {
    final statuses = [
      _OrderStatusItem(
        title: 'Pending',
        count: pending,
        icon: Icons.schedule_rounded,
        color: const Color(0xFFF59E0B),
        backgroundColor: const Color(0xFFFFF7E6),
      ),
      _OrderStatusItem(
        title: 'Processing',
        count: processing,
        icon: Icons.sync_rounded,
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFFEFF6FF),
      ),
      _OrderStatusItem(
        title: 'Shipped',
        count: shipped,
        icon: Icons.local_shipping_outlined,
        color: const Color(0xFF8B5CF6),
        backgroundColor: const Color(0xFFF5F3FF),
      ),
      _OrderStatusItem(
        title: 'Delivered',
        count: delivered,
        icon: Icons.check_circle_outline_rounded,
        color: const Color(0xFF10B981),
        backgroundColor: const Color(0xFFECFDF5),
      ),
      _OrderStatusItem(
        title: 'Cancelled',
        count: cancelled,
        icon: Icons.cancel_outlined,
        color: const Color(0xFFEF4444),
        backgroundColor: const Color(0xFFFEF2F2),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 10.0;

        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: statuses.map((status) {
            return SizedBox(width: itemWidth, child: _buildStatusCard(status));
          }).toList(),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusCard(_OrderStatusItem status) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onStatusTap == null ? null : () => onStatusTap!(status.title),
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: status.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: status.color.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(status.icon, color: status.color, size: 18),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${status.count}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ORDER STATUS MODEL
// ═════════════════════════════════════════════════════════════════════════════

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
