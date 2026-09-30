import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileStatusBadge extends StatelessWidget {
  const VendorProfileStatusBadge({super.key, this.status, this.large = false});

  final String? status;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 10,
        vertical: large ? 7 : 6,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: config.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: large ? 15 : 13,
            color: config.foregroundColor,
          ),

          const SizedBox(width: 6),

          Text(
            config.label,
            style: large
                ? AppTextStyles.statusBadgeLarge.copyWith(
                    color: config.foregroundColor,
                  )
                : AppTextStyles.statusBadge.copyWith(
                    color: config.foregroundColor,
                  ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String? value) {
    final normalized = value?.trim().toLowerCase();

    switch (normalized) {
      case 'approved':
        return const _StatusConfig(
          label: 'Approved',
          icon: Icons.verified_rounded,
          foregroundColor: AppColors.successDark,
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.successBorder,
        );

      case 'active':
        return const _StatusConfig(
          label: 'Active',
          icon: Icons.check_circle_outline_rounded,
          foregroundColor: AppColors.successDark,
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.successBorder,
        );

      case 'pending':
        return const _StatusConfig(
          label: 'Pending',
          icon: Icons.schedule_rounded,
          foregroundColor: AppColors.warningDark,
          backgroundColor: AppColors.warningLight,
          borderColor: AppColors.warningBorder,
        );

      case 'rejected':
        return const _StatusConfig(
          label: 'Rejected',
          icon: Icons.cancel_outlined,
          foregroundColor: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
          borderColor: AppColors.errorBorder,
        );

      case 'suspended':
        return const _StatusConfig(
          label: 'Suspended',
          icon: Icons.block_outlined,
          foregroundColor: AppColors.errorDark,
          backgroundColor: AppColors.errorLight,
          borderColor: AppColors.errorBorder,
        );

      default:
        return _StatusConfig(
          label: _formatUnknownStatus(normalized),
          icon: Icons.info_outline_rounded,
          foregroundColor: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceMuted,
          borderColor: AppColors.border,
        );
    }
  }

  String _formatUnknownStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unknown';
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}

// ================================================================
// STATUS CONFIG
// ================================================================

class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
}
