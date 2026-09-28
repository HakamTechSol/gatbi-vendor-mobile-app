import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Get Campaign/Models/campaign_type_model.dart';

class CampaignIdeaCard extends StatelessWidget {
  const CampaignIdeaCard({super.key, required this.campaign});

  final CampaignTypeModel campaign;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 230,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(height: 12),
              _buildName(),
              const SizedBox(height: 6),
              Expanded(child: _buildDescription()),
              const SizedBox(height: 10),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildName() {
    return Text(
      campaign.name ?? 'Campaign idea',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.titleMedium,
    );
  }

  Widget _buildDescription() {
    return Text(
      campaign.description ?? 'No description available.',
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodySmall,
    );
  }

  Widget _buildFooter() {
    final automated = campaign.automated ?? false;

    return Row(
      children: [
        Icon(
          automated ? Icons.bolt_rounded : Icons.support_agent_rounded,
          size: 15,
          color: automated ? AppColors.primary : AppColors.iconSecondary,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            automated ? 'Automated' : 'Team assisted',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: automated ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
