import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: AppTextStyles.statusBadge.copyWith(
              color: config.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const _StatusConfig(
          backgroundColor: AppColors.pendingLight,
          foregroundColor: AppColors.pending,
          borderColor: AppColors.warningBorder,
        );

      case OrderStatus.processing:
        return const _StatusConfig(
          backgroundColor: AppColors.processingLight,
          foregroundColor: AppColors.processing,
          borderColor: AppColors.infoBorder,
        );

      case OrderStatus.shipped:
        return const _StatusConfig(
          backgroundColor: AppColors.purpleLight,
          foregroundColor: AppColors.purple,
          borderColor: AppColors.borderPrimary,
        );

      case OrderStatus.delivered:
        return const _StatusConfig(
          backgroundColor: AppColors.successLight,
          foregroundColor: AppColors.success,
          borderColor: AppColors.successBorder,
        );

      case OrderStatus.cancelled:
        return const _StatusConfig(
          backgroundColor: AppColors.cancelledLight,
          foregroundColor: AppColors.cancelled,
          borderColor: AppColors.errorBorder,
        );

      case OrderStatus.draft:
        return const _StatusConfig(
          backgroundColor: AppColors.draftLight,
          foregroundColor: AppColors.draft,
          borderColor: AppColors.border,
        );

      case OrderStatus.unknown:
        return const _StatusConfig(
          backgroundColor: AppColors.backgroundSecondary,
          foregroundColor: AppColors.textSecondary,
          borderColor: AppColors.border,
        );
    }
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
}
