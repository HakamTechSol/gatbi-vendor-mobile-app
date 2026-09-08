import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8),
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
            _formatStatus(status),
            style: AppTextStyles.statusBadge.copyWith(
              color: config.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(String value) {
    switch (value.trim().toLowerCase()) {
      case 'open':
        return const _StatusConfig(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primary,
        );

      case 'pending':
        return const _StatusConfig(
          backgroundColor: Color(0xFFFFF4D9),
          foregroundColor: AppColors.warning,
        );

      case 'processing':
        return const _StatusConfig(
          backgroundColor: Color(0xFFE8F1FF),
          foregroundColor: AppColors.info,
        );

      case 'resolved':
      case 'completed':
        return const _StatusConfig(
          backgroundColor: Color(0xFFE4F8EF),
          foregroundColor: AppColors.success,
        );

      case 'closed':
        return const _StatusConfig(
          backgroundColor: Color(0xFFF0F1F5),
          foregroundColor: AppColors.textSecondary,
        );

      case 'cancelled':
        return const _StatusConfig(
          backgroundColor: Color(0xFFFFE9E9),
          foregroundColor: AppColors.error,
        );

      default:
        return const _StatusConfig(
          backgroundColor: AppColors.chipBackground,
          foregroundColor: AppColors.textSecondary,
        );
    }
  }

  String _formatStatus(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Unknown';
    }

    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
}
