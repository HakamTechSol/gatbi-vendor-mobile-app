import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class EventStatusBadge extends StatelessWidget {
  const EventStatusBadge({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: AppTextStyles.statusBadge.copyWith(color: config.color),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getConfig(String? value) {
    final normalized = value?.trim().toLowerCase();

    switch (normalized) {
      case 'open':
      case 'active':
      case 'ongoing':
        return const _StatusConfig(
          label: 'Open',
          color: AppColors.successDark,
          backgroundColor: AppColors.successLight,
        );

      case 'upcoming':
      case 'scheduled':
        return const _StatusConfig(
          label: 'Upcoming',
          color: AppColors.infoDark,
          backgroundColor: AppColors.infoLight,
        );

      case 'pending':
        return const _StatusConfig(
          label: 'Pending',
          color: AppColors.warningDark,
          backgroundColor: AppColors.warningLight,
        );

      case 'closed':
        return const _StatusConfig(
          label: 'Closed',
          color: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
        );

      case 'cancelled':
      case 'canceled':
        return const _StatusConfig(
          label: 'Cancelled',
          color: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
        );

      case 'rejected':
        return const _StatusConfig(
          label: 'Rejected',
          color: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
        );

      case 'expired':
        return const _StatusConfig(
          label: 'Expired',
          color: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
        );

      case 'completed':
      case 'complete':
        return const _StatusConfig(
          label: 'Completed',
          color: AppColors.successDark,
          backgroundColor: AppColors.successLight,
        );

      case 'draft':
        return const _StatusConfig(
          label: 'Draft',
          color: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceMuted,
        );

      default:
        return _StatusConfig(
          label: _formatStatus(value),
          color: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceMuted,
        );
    }
  }

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Unknown';
    }

    return value
        .trim()
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;
}
