import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Data/dummy_campaign_data.dart';
import 'campaign_idea_card.dart';

class CampaignsSuggestedIdeas extends StatelessWidget {
  const CampaignsSuggestedIdeas({
    super.key,
    this.ideas = dummyCampaignIdeas,
    this.onIdeaTap,
  });

  final List<CampaignIdeaModel> ideas;
  final ValueChanged<CampaignIdeaModel>? onIdeaTap;

  @override
  Widget build(BuildContext context) {
    if (ideas.isEmpty) {
      return const SizedBox.shrink();
    }

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
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${ideas.length} ideas',
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
            itemCount: ideas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final idea = ideas[index];

              return CampaignIdeaCard(
                idea: idea,
                onTap: () => onIdeaTap?.call(idea),
              );
            },
          ),
        ),
      ],
    );
  }
}