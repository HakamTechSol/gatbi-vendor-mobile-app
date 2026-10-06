import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class NotificationSettingSwitchTile extends StatelessWidget {
  const NotificationSettingSwitchTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final String title;
  final String description;
  final IconData icon;

  final bool value;
  final ValueChanged<bool>? onChanged;

  final bool isEnabled;

  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primary;

    final effectiveIconBackground =
        iconBackgroundColor ?? AppColors.primaryLight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? AppColors.primarySurface : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? AppColors.borderPrimary : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(
            color: effectiveIconColor,
            backgroundColor: effectiveIconBackground,
          ),

          const SizedBox(width: 14),

          Expanded(child: _buildContent()),

          const SizedBox(width: 12),

          _buildSwitch(),
        ],
      ),
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  Widget _buildIcon({required Color color, required Color backgroundColor}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: value ? backgroundColor : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 22,
        color: isEnabled ? color : AppColors.iconMuted,
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: isEnabled ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: isEnabled ? AppColors.textSecondary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SWITCH
  // ============================================================

  Widget _buildSwitch() {
    return Switch.adaptive(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      activeColor: AppColors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: AppColors.white,
      inactiveTrackColor: AppColors.borderStrong,
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }

        return AppColors.borderStrong;
      }),
    );
  }
}
