import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class BulkImportToggle extends StatelessWidget {
  const BulkImportToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.title = 'Auto-generate Arabic draft',
    this.description =
        'Automatically generate an Arabic draft for supported fields.',
    this.icon = Icons.translate_rounded,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: value ? AppColors.primarySurface : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value ? AppColors.borderPrimary : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: value ? AppColors.primaryLight : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 21,
              color: value ? AppColors.primary : AppColors.iconSecondary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primaryLight,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}
