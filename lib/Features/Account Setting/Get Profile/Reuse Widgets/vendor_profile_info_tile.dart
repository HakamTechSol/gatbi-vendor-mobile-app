import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileInfoTile extends StatelessWidget {
  const VendorProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.iconBackground,
    this.showDivider = true,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;

  final Color? iconColor;
  final Color? iconBackground;

  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ==========================================================
          // ICON
          // ==========================================================
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground ?? AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
          ),

          const SizedBox(width: 13),

          // ==========================================================
          // TITLE + VALUE
          // ==========================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.settingsSubtitle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.settingsTitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ==========================================================
          // OPTIONAL ARROW
          // ==========================================================
          if (onTap != null) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.iconMuted,
            ),
          ],
        ],
      ),
    );

    if (!showDivider) {
      return Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      );
    }

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(onTap: onTap, child: content),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
