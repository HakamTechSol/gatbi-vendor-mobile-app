import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_detail_model.dart';
import 'order_item_tile.dart';

class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({super.key, required this.order});

  final OrderDetailModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color: AppColors.iconPrimary,
              ),
              const SizedBox(width: 9),
              Text(
                'Order Items',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text('${order.itemCount} items', style: AppTextStyles.orderMeta),
            ],
          ),

          const SizedBox(height: 16),

          if (order.items.isEmpty)
            const _EmptyItems()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1, color: AppColors.divider),
                );
              },
              itemBuilder: (context, index) {
                return OrderItemTile(item: order.items[index]);
              },
            ),
        ],
      ),
    );
  }
}

class _EmptyItems extends StatelessWidget {
  const _EmptyItems();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 32,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: 8),
          Text(
            'No items found',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
