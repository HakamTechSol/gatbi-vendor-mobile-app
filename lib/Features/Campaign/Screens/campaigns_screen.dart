import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Data/dummy_campaign_data.dart';
import '../Models/campaign_model.dart';
import '../Reuse widgets/campaign_card.dart';
import '../Reuse widgets/campaigns_action_buttons.dart';
import '../Reuse widgets/campaigns_empty_state.dart';
import '../Reuse widgets/campaigns_header.dart';
import '../Reuse widgets/campaigns_how_it_works.dart';
import '../Reuse widgets/campaigns_suggested_ideas.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  CampaignStatus? _selectedStatus;

  List<CampaignModel> get _filteredCampaigns {
    if (_selectedStatus == null) {
      return dummyCampaigns;
    }

    return dummyCampaigns
        .where((campaign) => campaign.status == _selectedStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const CampaignsHeader(),

                    const SizedBox(height: 18),

                    CampaignsActionButtons(
                      onPickProducts: _handlePickProducts,
                      onRequestCampaign: _handleRequestCampaign,
                    ),

                    const SizedBox(height: 26),

                    _buildCampaignsSection(),

                    const SizedBox(height: 26),

                    const CampaignsHowItWorks(),

                    const SizedBox(height: 26),

                    CampaignsSuggestedIdeas(onIdeaTap: _handleIdeaTap),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignsSection() {
    final campaigns = _filteredCampaigns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Your campaigns',
          subtitle: campaigns.isEmpty
              ? 'No campaigns available right now.'
              : '${campaigns.length} campaign${campaigns.length == 1 ? '' : 's'}',
        ),

        const SizedBox(height: 14),

        _buildStatusFilters(),

        const SizedBox(height: 14),

        if (campaigns.isEmpty)
          CampaignsEmptyState(onContactSupport: _handleContactSupport)
        else
          _buildCampaignList(campaigns),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilters() {
    const filters = [
      _CampaignFilter(label: 'All', status: null),
      _CampaignFilter(label: 'Active', status: CampaignStatus.active),
      _CampaignFilter(label: 'Scheduled', status: CampaignStatus.scheduled),
      _CampaignFilter(label: 'Completed', status: CampaignStatus.completed),
      _CampaignFilter(label: 'Draft', status: CampaignStatus.draft),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];

          return _CampaignFilterChip(
            label: filter.label,
            isSelected: _selectedStatus == filter.status,
            onTap: () {
              setState(() {
                _selectedStatus = filter.status;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildCampaignList(List<CampaignModel> campaigns) {
    return Column(
      children: [
        for (int index = 0; index < campaigns.length; index++) ...[
          CampaignCard(
            campaign: campaigns[index],
            onTap: () => _handleCampaignTap(campaigns[index]),
          ),
          if (index != campaigns.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {});
  }

  void _handlePickProducts() {
    _showComingSoonMessage('Product selection will be connected here.');
  }

  void _handleRequestCampaign() {
    _showComingSoonMessage('Campaign request flow will be connected here.');
  }

  void _handleContactSupport() {
    _showComingSoonMessage('Support contact flow will be connected here.');
  }

  void _handleIdeaTap(CampaignIdeaModel idea) {
    _showComingSoonMessage(
      '${idea.title} campaign flow will be connected here.',
    );
  }

  void _handleCampaignTap(CampaignModel campaign) {
    _showComingSoonMessage('${campaign.title} details will be connected here.');
  }

  void _showComingSoonMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.navy,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}

class _CampaignFilter {
  const _CampaignFilter({required this.label, required this.status});

  final String label;
  final CampaignStatus? status;
}

class _CampaignFilterChip extends StatelessWidget {
  const _CampaignFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.borderPrimary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.filterChip.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
