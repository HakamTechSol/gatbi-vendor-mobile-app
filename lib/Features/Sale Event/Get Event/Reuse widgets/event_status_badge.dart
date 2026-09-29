import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class EventStatusBadge extends StatelessWidget {
  const EventStatusBadge({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _formatStatus(status),
            style: AppTextStyles.statusBadge.copyWith(color: colors.foreground),
          ),
        ],
      ),
    );
  }

  _EventStatusColors _getColors(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'open':
        return const _EventStatusColors(
          background: AppColors.successLight,
          foreground: AppColors.successDark,
          border: AppColors.successBorder,
        );

      case 'active':
        return const _EventStatusColors(
          background: AppColors.infoLight,
          foreground: AppColors.infoDark,
          border: AppColors.infoBorder,
        );

      default:
        return const _EventStatusColors(
          background: AppColors.draftLight,
          foreground: AppColors.textSecondary,
          border: AppColors.border,
        );
    }
  }

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Unknown';
    }

    switch (value.trim().toLowerCase()) {
      case 'open':
        return 'Open';

      case 'active':
        return 'Active';

      default:
        return value
            .split('_')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}'
                        '${word.substring(1)}',
            )
            .join(' ');
    }
  }
}

class _EventStatusColors {
  const _EventStatusColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
