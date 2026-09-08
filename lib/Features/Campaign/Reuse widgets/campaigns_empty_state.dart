import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';

class CampaignsEmptyState extends StatelessWidget {
  const CampaignsEmptyState({super.key, this.onContactSupport});

  final VoidCallback? onContactSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_outlined,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No campaigns yet',
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Campaign tools will appear here once enabled. '
            'For now, you can request a promotion from support.',
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateDescription,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Contact Support',
            icon: Icons.support_agent_outlined,
            iconPosition: CustomButtonIconPosition.leading,
            onPressed: onContactSupport,
            width: 190,
            height: 46,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }
}
