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
              _RecentOrdersHeader(
                orderCount: orders.length,
                hasOrders: orders.isNotEmpty,
                onViewAll: onViewAll,
                isMobile: isMobile,
              ),

              SizedBox(height: isMobile ? 14 : 18),

              if (orders.isEmpty)
                _RecentOrdersEmptyState(isMobile: isMobile)
              else
                _RecentOrdersList(
                  orders: orders,
                  onOrderTap: onOrderTap,
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

class _RecentOrdersHeader extends StatelessWidget {
  const _RecentOrdersHeader({
    required this.orderCount,
    required this.hasOrders,
    required this.onViewAll,
    required this.isMobile,
  });

  final int orderCount;
  final bool hasOrders;
  final VoidCallback? onViewAll;
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
            Icons.shopping_bag_rounded,
            color: AppColors.white,
            size: isMobile ? 20 : 22,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Recent Orders',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.navy,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  if (hasOrders) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$orderCount',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 4),

              Text(
                hasOrders
                    ? 'Latest activity from your store'
                    : 'Your latest orders will appear here',
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

        if (onViewAll != null) ...[
          const SizedBox(width: 8),
          _ViewAllButton(onTap: onViewAll!, isMobile: isMobile),
        ],
      ],
    );
  }
}

// ============================================================================
// VIEW ALL BUTTON
// ============================================================================

class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton({required this.onTap, required this.isMobile});

  final VoidCallback onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View all',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.primary,
                  fontSize: isMobile ? 9 : 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _RecentOrdersEmptyState extends StatelessWidget {
  const _RecentOrdersEmptyState({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 24,
        vertical: isMobile ? 25 : 30,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 58 : 64,
            height: isMobile ? 58 : 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryLight,
                  AppColors.primaryLight.withValues(alpha: 0.55),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: isMobile ? 27 : 30,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            'No orders yet',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.navy,
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Text(
              'Once customers place orders, your latest orders will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 10 : 10.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ORDERS LIST
// ============================================================================

class _RecentOrdersList extends StatelessWidget {
  const _RecentOrdersList({
    required this.orders,
    required this.onOrderTap,
    required this.isMobile,
    required this.isVerySmall,
  });

  final List<RecentOrderItem> orders;
  final ValueChanged<RecentOrderItem>? onOrderTap;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < orders.length; index++) ...[
          _RecentOrderCard(
            order: orders[index],
            onTap: onOrderTap == null ? null : () => onOrderTap!(orders[index]),
            isMobile: isMobile,
            isVerySmall: isVerySmall,
          ),

          if (index != orders.length - 1) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

// ============================================================================
// ORDER CARD
// ============================================================================

class _RecentOrderCard extends StatelessWidget {
  const _RecentOrderCard({
    required this.order,
    required this.onTap,
    required this.isMobile,
    required this.isVerySmall,
  });

  final RecentOrderItem order;
  final VoidCallback? onTap;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        order.statusColor ?? _getStatusColor(order.status);
    final IconData statusIcon = _getStatusIcon(order.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
            color: AppColors.background.withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
          ),
          child: Row(
            children: [
              _OrderIcon(statusColor: statusColor, isMobile: isMobile),

              SizedBox(width: isMobile ? 10 : 12),

              Expanded(
                child: _OrderInformation(
                  order: order,
                  isMobile: isMobile,
                  isVerySmall: isVerySmall,
                ),
              ),

              SizedBox(width: isMobile ? 7 : 10),

              _OrderAmountAndStatus(
                order: order,
                statusColor: statusColor,
                statusIcon: statusIcon,
                isMobile: isMobile,
                isVerySmall: isVerySmall,
              ),

              if (onTap != null) ...[
                const SizedBox(width: 5),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.55),
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase().trim()) {
      case 'pending':
        return Icons.schedule_rounded;

      case 'processing':
        return Icons.sync_rounded;

      case 'shipped':
        return Icons.local_shipping_rounded;

      case 'delivered':
        return Icons.check_circle_rounded;

      case 'cancelled':
      case 'canceled':
        return Icons.cancel_rounded;

      default:
        return Icons.info_rounded;
    }
  }
}

// ============================================================================
// ORDER ICON
// ============================================================================

class _OrderIcon extends StatelessWidget {
  const _OrderIcon({required this.statusColor, required this.isMobile});

  final Color statusColor;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final double size = isMobile ? 42 : 46;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.07),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shopping_bag_rounded,
            color: AppColors.primary,
            size: isMobile ? 19 : 21,
          ),

          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ORDER INFORMATION
// ============================================================================

class _OrderInformation extends StatelessWidget {
  const _OrderInformation({
    required this.order,
    required this.isMobile,
    required this.isVerySmall,
  });

  final RecentOrderItem order;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  fontSize: isVerySmall
                      ? 10.5
                      : isMobile
                      ? 11
                      : 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            if (order.date != null && order.date!.trim().isNotEmpty) ...[
              const SizedBox(width: 6),

              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.divider,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        order.date!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isMobile ? 8 : 8.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            Icon(
              Icons.person_outline_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.75),
              size: 13,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                order.customerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 9 : 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// AMOUNT + STATUS
// ============================================================================

class _OrderAmountAndStatus extends StatelessWidget {
  const _OrderAmountAndStatus({
    required this.order,
    required this.statusColor,
    required this.statusIcon,
    required this.isMobile,
    required this.isVerySmall,
  });

  final RecentOrderItem order;
  final Color statusColor;
  final IconData statusIcon;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 105),
          child: Text(
            order.amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontSize: isVerySmall
                  ? 10.5
                  : isMobile
                  ? 11
                  : 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(height: 5),

        Container(
          constraints: const BoxConstraints(maxWidth: 105),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 7 : 8,
            vertical: isMobile ? 4 : 4.5,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: isMobile ? 10 : 11),

              const SizedBox(width: 4),

              Flexible(
                child: Text(
                  order.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontSize: isVerySmall
                        ? 7
                        : isMobile
                        ? 7.5
                        : 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
