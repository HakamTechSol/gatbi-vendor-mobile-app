// lib/core/widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final bool isDot;
  final double? fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.primary,
    this.isDot = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDot ? 0 : 10,
        vertical: isDot ? 0 : 4,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.text,
                shape: BoxShape.circle,
              ),
            ),
          ] else ...[
            Text(
              label,
              style: AppTextStyles.statusBadge.copyWith(
                color: colors.text,
                fontSize: fontSize,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _BadgeColors _getColors() {
    switch (type) {
      case StatusBadgeType.success:
        return _BadgeColors(
          background: AppColors.successLight,
          border: AppColors.successBorder,
          text: AppColors.success,
        );
      case StatusBadgeType.warning:
        return _BadgeColors(
          background: AppColors.warningLight,
          border: AppColors.warningBorder,
          text: AppColors.warning,
        );
      case StatusBadgeType.error:
        return _BadgeColors(
          background: AppColors.errorLight,
          border: AppColors.errorBorder,
          text: AppColors.error,
        );
      case StatusBadgeType.info:
        return _BadgeColors(
          background: AppColors.infoLight,
          border: AppColors.infoBorder,
          text: AppColors.info,
        );
      case StatusBadgeType.primary:
        return _BadgeColors(
          background: AppColors.primaryLight,
          border: AppColors.borderPrimary,
          text: AppColors.primary,
        );
      case StatusBadgeType.secondary:
        return _BadgeColors(
          background: AppColors.surfaceMuted,
          border: AppColors.border,
          text: AppColors.textSecondary,
        );
    }
  }
}

enum StatusBadgeType {
  primary,
  success,
  warning,
  error,
  info,
  secondary,
}

class _BadgeColors {
  final Color background;
  final Color border;
  final Color text;

  _BadgeColors({
    required this.background,
    required this.border,
    required this.text,
  });
}