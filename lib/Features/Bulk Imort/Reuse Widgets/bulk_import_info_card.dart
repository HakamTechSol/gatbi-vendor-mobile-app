import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

enum BulkImportInfoType { info, success, warning, error }

class BulkImportInfoCard extends StatelessWidget {
  const BulkImportInfoCard({
    super.key,
    required this.title,
    required this.description,
    this.type = BulkImportInfoType.info,
    this.icon,
    this.trailing,
  });

  final String title;
  final String description;
  final BulkImportInfoType type;
  final IconData? icon;
  final Widget? trailing;

  Color get _backgroundColor {
    switch (type) {
      case BulkImportInfoType.info:
        return AppColors.infoLight;

      case BulkImportInfoType.success:
        return AppColors.successLight;

      case BulkImportInfoType.warning:
        return AppColors.warningLight;

      case BulkImportInfoType.error:
        return AppColors.errorLight;
    }
  }

  Color get _accentColor {
    switch (type) {
      case BulkImportInfoType.info:
        return AppColors.info;

      case BulkImportInfoType.success:
        return AppColors.success;

      case BulkImportInfoType.warning:
        return AppColors.warningDark;

      case BulkImportInfoType.error:
        return AppColors.error;
    }
  }

  IconData get _defaultIcon {
    switch (type) {
      case BulkImportInfoType.info:
        return Icons.info_outline_rounded;

      case BulkImportInfoType.success:
        return Icons.check_circle_outline_rounded;

      case BulkImportInfoType.warning:
        return Icons.warning_amber_rounded;

      case BulkImportInfoType.error:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ────────────────────────────────────────────────────────────────
          // ICON
          // ────────────────────────────────────────────────────────────────
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _accentColor.withValues(alpha: 0.08)),
            ),
            child: Icon(icon ?? _defaultIcon, size: 20, color: _accentColor),
          ),

          const SizedBox(width: 11),

          // ────────────────────────────────────────────────────────────────
          // CONTENT
          // ────────────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          // ────────────────────────────────────────────────────────────────
          // TRAILING
          // ────────────────────────────────────────────────────────────────
          if (trailing != null) ...[
            const SizedBox(width: 10),
            Padding(padding: const EdgeInsets.only(top: 2), child: trailing!),
          ],
        ],
      ),
    );
  }
}
