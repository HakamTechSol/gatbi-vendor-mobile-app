import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class CampaignsHowItWorks extends StatelessWidget {
  const CampaignsHowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How it works', style: AppTextStyles.titleLarge),
          const SizedBox(height: 5),
          Text(
            'Create campaigns and get more attention for your products.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),

          const _CampaignStep(
            number: 1,
            icon: Icons.shopping_bag_outlined,
            title: 'Choose products',
            description: 'Select the products you want to promote.',
          ),

          const _StepDivider(),

          const _CampaignStep(
            number: 2,
            icon: Icons.local_offer_outlined,
            title: 'Set an offer',
            description: 'Choose discounts, bundles or featured promotions.',
          ),

          const _StepDivider(),

          const _CampaignStep(
            number: 3,
            icon: Icons.rocket_launch_outlined,
            title: 'Go live',
            description: 'Review your campaign and publish it to customers.',
          ),
        ],
      ),
    );
  }
}

class _CampaignStep extends StatelessWidget {
  const _CampaignStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  final int number;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 10, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(width: 1, height: 18, color: AppColors.divider),
      ),
    );
  }
}
