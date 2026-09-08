import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VariantValueChip extends StatelessWidget {
  const VariantValueChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.onTap,
    this.selected = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.10)
                : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: enabled
                      ? (selected ? AppColors.primary : AppColors.textPrimary)
                      : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: enabled ? onDeleted : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: enabled
                          ? AppColors.iconSecondary
                          : AppColors.iconMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
