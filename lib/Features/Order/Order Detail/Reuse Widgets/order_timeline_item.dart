import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Order List/models/order_model.dart' as order_list_models;
import '../Models/order_timeline_model.dart';

class OrderTimelineItem extends StatelessWidget {
  const OrderTimelineItem({super.key, required this.item, this.isLast = false});

  final OrderTimelineModel item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: item.isCompleted || item.isCurrent
                        ? statusColor.withValues(alpha: 0.12)
                        : AppColors.backgroundSecondary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.isCompleted || item.isCurrent
                          ? statusColor.withValues(alpha: 0.35)
                          : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    _statusIcon(item.status),
                    size: 16,
                    color: item.isCompleted || item.isCurrent
                        ? statusColor
                        : AppColors.iconMuted,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        _formatDate(item.createdAt),
                        style: AppTextStyles.orderMeta,
                      ),
                    ],
                  ),

                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      item.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],

                  if (item.location != null && item.location!.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.iconMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location!,
                            style: AppTextStyles.orderMeta,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(order_list_models.OrderStatus status) {
    switch (status) {
      case order_list_models.OrderStatus.pending:
        return AppColors.warning;
      case order_list_models.OrderStatus.processing:
        return AppColors.info;
      case order_list_models.OrderStatus.shipped:
        return AppColors.purple;
      case order_list_models.OrderStatus.delivered:
        return AppColors.success;
      case order_list_models.OrderStatus.cancelled:
        return AppColors.error;
      case order_list_models.OrderStatus.draft:
        return AppColors.textTertiary;
      case order_list_models.OrderStatus.unknown:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(order_list_models.OrderStatus status) {
    switch (status) {
      case order_list_models.OrderStatus.pending:
        return Icons.schedule_rounded;
      case order_list_models.OrderStatus.processing:
        return Icons.autorenew_rounded;
      case order_list_models.OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case order_list_models.OrderStatus.delivered:
        return Icons.check_rounded;
      case order_list_models.OrderStatus.cancelled:
        return Icons.close_rounded;
      case order_list_models.OrderStatus.draft:
        return Icons.edit_note_rounded;
      case order_list_models.OrderStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
