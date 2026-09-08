// lib/View/Vendor/Dashboard/widgets/recent_orders_section.dart

import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class RecentOrderItem {
  const RecentOrderItem({
    required this.orderId,
    required this.customerName,
    required this.amount,
    required this.status,
    this.date,
    this.statusColor,
  });

  final String orderId;
  final String customerName;
  final String amount;
  final String status;
  final String? date;
  final Color? statusColor;
}

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({
    super.key,
    this.orders = const [],
    this.onViewAll,
    this.onOrderTap,
  });

  final List<RecentOrderItem> orders;
  final VoidCallback? onViewAll;
  final ValueChanged<RecentOrderItem>? onOrderTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 14),

          if (orders.isEmpty) _buildEmptyState() else _buildOrdersList(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Orders',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                orders.isEmpty
                    ? 'Your latest orders will appear here'
                    : 'Latest activity from your store',
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

        const SizedBox(width: 8),

        if (onViewAll != null)
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View all',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 3),

                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
              size: 25,
            ),
          ),

          const SizedBox(height: 11),

          Text(
            'No orders yet',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.navy,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Once customers place orders, your latest orders will show up here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDERS LIST
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOrdersList() {
    return Column(
      children: [
        for (int index = 0; index < orders.length; index++) ...[
          _buildOrderTile(orders[index]),
          if (index != orders.length - 1)
            Divider(height: 1, color: AppColors.divider.withValues(alpha: 0.7)),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDER TILE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOrderTile(RecentOrderItem order) {
    final statusColor = order.statusColor ?? _getStatusColor(order.status);

    return InkWell(
      onTap: onOrderTap == null ? null : () => onOrderTap!(order),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            // Order icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 19,
              ),
            ),

            const SizedBox(width: 10),

            // Order information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          order.orderId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.navy,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      if (order.date != null) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            order.date!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 8.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    order.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Amount + status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.navy,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  constraints: const BoxConstraints(maxWidth: 85),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLOR
  // ═══════════════════════════════════════════════════════════════════════════

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;

      case 'processing':
        return AppColors.primary;

      case 'shipped':
        return AppColors.info;

      case 'delivered':
        return AppColors.success;

      case 'cancelled':
      case 'canceled':
        return AppColors.error;

      default:
        return AppColors.textSecondary;
    }
  }
}
