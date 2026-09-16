import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  final String? status;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status?.trim().toLowerCase();

    final config = _statusConfig(normalizedStatus);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: config.borderColor,
        ),
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
            _statusLabel(normalizedStatus),
            style: AppTextStyles.statusBadge.copyWith(
              color: config.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(String? status) {
    switch (status) {
      case 'pending':
        return const _StatusConfig(
          backgroundColor: AppColors.pendingLight,
          foregroundColor: AppColors.pending,
          borderColor: AppColors.warningBorder,
        );

      case 'processing':
        return const _StatusConfig(
          backgroundColor: AppColors.processingLight,
          foregroundColor: AppColors.processing,
          borderColor: AppColors.infoBorder,
        );

      case 'shipped':
        return const _StatusConfig(
          backgroundColor: AppColors.purpleLight,
          foregroundColor: AppColors.purple,
          borderColor: AppColors.borderPrimary,
        );

      case 'delivered':
        return const _StatusConfig(
          backgroundColor: AppColors.successLight,
          foregroundColor: AppColors.success,
          borderColor: AppColors.successBorder,
        );

      case 'cancelled':
        return const _StatusConfig(
          backgroundColor: AppColors.cancelledLight,
          foregroundColor: AppColors.cancelled,
          borderColor: AppColors.errorBorder,
        );

      case 'draft':
        return const _StatusConfig(
          backgroundColor: AppColors.draftLight,
          foregroundColor: AppColors.draft,
          borderColor: AppColors.border,
        );

      default:
        return const _StatusConfig(
          backgroundColor: AppColors.backgroundSecondary,
          foregroundColor: AppColors.textSecondary,
          borderColor: AppColors.border,
        );
    }
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'pending':
        return 'Pending';

      case 'processing':
        return 'Processing';

      case 'shipped':
        return 'Shipped';

      case 'delivered':
        return 'Delivered';

      case 'cancelled':
        return 'Cancelled';

      case 'draft':
        return 'Draft';

      default:
        if (status == null || status.isEmpty) {
          return 'Unknown';
        }

        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
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