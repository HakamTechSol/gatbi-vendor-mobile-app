import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class CampaignStatusBadge extends StatelessWidget {
  const CampaignStatusBadge({
    super.key,
    required this.status,
    this.label,
    this.compact = false,
  });

  final String? status;
  final String? label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status?.trim().toLowerCase() ?? '';
    final colors = _getStatusColors(normalizedStatus);

    final displayLabel = label != null && label!.trim().isNotEmpty
        ? label!.trim()
        : _formatStatus(normalizedStatus);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.foreground.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 7,
            height: compact ? 6 : 7,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 5 : 6),
          Text(
            displayLabel,
            style: AppTextStyles.statusBadge.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 11 : null,
            ),
          ),
        ],
      ),
    );
  }

  _StatusColors _getStatusColors(String status) {
    switch (status) {
      case 'active':
        return const _StatusColors(
          foreground: AppColors.success,
          background: AppColors.successLight,
        );

      case 'completed':
        return const _StatusColors(
          foreground: AppColors.success,
          background: AppColors.successLight,
        );

      case 'scheduled':
      case 'processing':
        return const _StatusColors(
          foreground: AppColors.info,
          background: AppColors.infoLight,
        );

      case 'pending':
        return const _StatusColors(
          foreground: AppColors.warning,
          background: AppColors.warningLight,
        );

      case 'cancelled':
      case 'rejected':
        return const _StatusColors(
          foreground: AppColors.error,
          background: AppColors.errorLight,
        );

      case 'draft':
        return const _StatusColors(
          foreground: AppColors.textSecondary,
          background: AppColors.surfaceMuted,
        );

      default:
        return const _StatusColors(
          foreground: AppColors.textSecondary,
          background: AppColors.surfaceMuted,
        );
    }
  }

  String _formatStatus(String value) {
    if (value.isEmpty) {
      return 'Unknown';
    }

    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _StatusColors {
  const _StatusColors({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}
