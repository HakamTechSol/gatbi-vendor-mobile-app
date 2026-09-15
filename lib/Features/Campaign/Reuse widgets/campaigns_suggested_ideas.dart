import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Campain Type/campain_type_controller.dart';
import '../Campain Type/campain_type_model.dart';
import 'campaign_idea_card.dart';

class CampaignsSuggestedIdeas extends ConsumerWidget {
  const CampaignsSuggestedIdeas({super.key, this.onIdeaTap});

  final ValueChanged<CampaignTypeModel>? onIdeaTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(campaignsSuggestedIdeasProvider);

    return campaignsAsync.when(
      loading: () => const _SuggestedIdeasLoading(),
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      data: (campaigns) {
        if (campaigns.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, campaigns);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<CampaignTypeModel> campaigns,
  ) {
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
                '${campaigns.length} ideas',
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
            itemCount: campaigns.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final campaign = campaigns[index];

              return CampaignIdeaCard(
                campaign: campaign,
                onTap: () => onIdeaTap?.call(campaign),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Provider only for the Suggested Ideas section.
///
/// It reuses the existing Campaigns API controller.
/// No new API call / Dio client / repository is created.
final campaignsSuggestedIdeasProvider = FutureProvider<List<CampaignTypeModel>>(
  (ref) async {
    final controller = ref.watch(campaignsControllerProvider);

    final response = await controller.getCampaigns();

    return response.campaignTypes;
  },
);

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
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) {
              return Container(
                width: 220,
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
