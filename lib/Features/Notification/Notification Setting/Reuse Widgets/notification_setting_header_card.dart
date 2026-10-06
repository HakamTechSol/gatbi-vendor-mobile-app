import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class NotificationSettingHeaderCard extends StatelessWidget {
  const NotificationSettingHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconContainer(),

          const SizedBox(width: 16),

          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  Widget _buildIconContainer() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.textOnPrimarySecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.notifications_active_rounded,
        color: AppColors.white,
        size: 28,
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
          'Notification Preferences',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Choose how you want to receive updates and important information.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textOnPrimarySecondary,
          ),
        ),
      ],
    );
  }
}
