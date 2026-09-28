import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Get Campaign/Models/campaign_type_model.dart';
import 'campaign_idea_card.dart';

class CampaignsSuggestedIdeas extends StatelessWidget {
  const CampaignsSuggestedIdeas({
    super.key,
    required this.campaignTypes,
    this.isLoading = false,
  });

  final List<CampaignTypeModel> campaignTypes;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _SuggestedIdeasLoading();
    }

    if (campaignTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested campaign ideas',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try one of these promotion ideas for your products.',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${campaignTypes.length} ideas',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: campaignTypes.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final campaignType = campaignTypes[index];

              return CampaignIdeaCard(
                campaign: campaignType,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Loading
// ============================================================

class _SuggestedIdeasLoading extends StatelessWidget {
  const _SuggestedIdeasLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested campaign ideas',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try one of these promotion ideas for your products.',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (_, __) {
              return Container(
                width: 230,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
