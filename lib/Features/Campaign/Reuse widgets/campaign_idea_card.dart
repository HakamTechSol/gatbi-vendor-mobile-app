import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Data/dummy_campaign_data.dart';

class CampaignIdeaCard extends StatelessWidget {
  const CampaignIdeaCard({super.key, required this.idea, this.onTap});

  final CampaignIdeaModel idea;
  final VoidCallback? onTap;

  IconData get _icon {
    switch (idea.icon) {
      case 'flash':
        return Icons.flash_on_rounded;
      case 'star':
        return Icons.star_outline_rounded;
      case 'bundle':
        return Icons.inventory_2_outlined;
      case 'shipping':
        return Icons.local_shipping_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 170,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, size: 21, color: AppColors.white),
              ),
              const SizedBox(height: 14),
              Text(
                idea.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                idea.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore',
                    style: AppTextStyles.buttonText.copyWith(fontSize: 12),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
