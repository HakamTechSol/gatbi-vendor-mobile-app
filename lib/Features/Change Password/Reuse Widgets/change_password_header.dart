import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChangePasswordHeader extends StatelessWidget {
  const ChangePasswordHeader({
    super.key,
    this.onBack,
    this.title = 'Change Password',
    this.subtitle = 'Update your password to keep your account secure.',
  });

  final VoidCallback? onBack;

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ─────────────────────────────────────────────────────────────
        // BACK BUTTON
        // ─────────────────────────────────────────────────────────────
        _HeaderIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
        ),

        const SizedBox(width: 12),

        // ─────────────────────────────────────────────────────────────
        // TITLE + SUBTITLE
        // ─────────────────────────────────────────────────────────────
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

              const SizedBox(height: 3),

              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 21, color: AppColors.iconPrimary),
        ),
      ),
    );
  }
}
