import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_model.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});

  final OrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 14),

              _buildCustomer(),

              const SizedBox(height: 14),

              _buildDivider(),

              const SizedBox(height: 14),

              _buildProductPreview(),

              const SizedBox(height: 14),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.orderNumber, style: AppTextStyles.orderNumber),
              const SizedBox(height: 4),
              Text(
                _formatDate(order.createdAt),
                style: AppTextStyles.orderMeta,
              ),
            ],
          ),
        ),

        OrderStatusBadge(status: order.status),
      ],
    );
  }

  Widget _buildCustomer() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.customer.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (order.customer.email != null) ...[
                const SizedBox(height: 2),
                Text(
                  order.customer.email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.orderMeta,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }

  Widget _buildProductPreview() {
    if (order.items.isEmpty) {
      return Row(
        children: [
          _buildProductIcon(),
          const SizedBox(width: 10),
          Text('${order.itemCount} items', style: AppTextStyles.productName),
        ],
      );
    }

    final firstItem = order.items.first;
    final remainingItems = order.items.length - 1;

    return Row(
      children: [
        _buildProductIcon(),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstItem.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.productName,
              ),

              const SizedBox(height: 3),

              Text(
                _buildItemMeta(firstItem),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.productSku,
              ),
            ],
          ),
        ),

        if (remainingItems > 0)
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              '+$remainingItems',
              style: AppTextStyles.filterChip.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductIcon() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.inputIconBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.iconSecondary,
        size: 22,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total', style: AppTextStyles.orderMeta),
            const SizedBox(height: 3),
            Text(
              '${order.currency} ${order.totalAmount.toStringAsFixed(2)}',
              style: AppTextStyles.orderAmount,
            ),
          ],
        ),

        const Spacer(),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
              style: AppTextStyles.orderMeta,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ],
    );
  }

  String _buildItemMeta(dynamic item) {
    final quantity = item.quantity;
    final sku = item.sku;

    if (sku != null && sku.isNotEmpty) {
      return 'Qty: $quantity  •  SKU: $sku';
    }

    return 'Qty: $quantity';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${months[date.month - 1]} ${date.day}, ${date.year} • '
        '$hour:$minute $period';
  }
}
