import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileHeader extends StatelessWidget {
  const VendorProfileHeader({
    super.key,
    this.onBack,
    this.onEdit,
    this.title = 'My Profile',
    this.description = 'View and manage your merchant business information.',
  });

  final VoidCallback? onBack;
  final VoidCallback? onEdit;

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ============================================================
        // BACK BUTTON
        // ============================================================
        _HeaderIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
        ),

        const SizedBox(width: 12),

        // ============================================================
        // TITLE CONTENT
        // ============================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineSmall,
              ),

              const SizedBox(height: 2),

              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ============================================================
        // EDIT BUTTON
        // ============================================================
        _HeaderIconButton(
          icon: Icons.edit_rounded,
          onTap: onEdit,
          enabled: onEdit != null,
          iconColor: AppColors.primary,
        ),
      ],
    );
  }
}

// ================================================================
// HEADER ICON BUTTON
// ================================================================

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    this.onTap,
    this.enabled = true,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.white : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled
                ? (iconColor ?? AppColors.iconPrimary)
                : AppColors.iconMuted,
          ),
        ),
      ),
    );
  }
}
