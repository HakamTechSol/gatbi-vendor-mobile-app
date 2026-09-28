import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/campaign_detail_model.dart';

class CampaignOverviewCard extends StatelessWidget {
  const CampaignOverviewCard({super.key, required this.campaign});

  final CampaignDetailData campaign;

  @override
  Widget build(BuildContext context) {
    return _CampaignCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 18),
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        _IconContainer(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          backgroundColor: AppColors.primarySurface,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Overview',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Basic campaign information',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 500;

        if (isCompact) {
          return Column(
            children: [
              _CampaignInfoTile(
                icon: Icons.sell_outlined,
                label: 'Campaign Type',
                value: _formatValue(campaign.campaignType),
              ),
              const SizedBox(height: 12),
              _CampaignInfoTile(
                icon: Icons.flag_outlined,
                label: 'Status',
                value: _formatValue(campaign.statusLabel ?? campaign.status),
              ),
              const SizedBox(height: 12),
              _CampaignInfoTile(
                icon: Icons.tag_outlined,
                label: 'Campaign ID',
                value: campaign.id?.toString() ?? '—',
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _CampaignInfoTile(
                icon: Icons.sell_outlined,
                label: 'Campaign Type',
                value: _formatValue(campaign.campaignType),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CampaignInfoTile(
                icon: Icons.flag_outlined,
                label: 'Status',
                value: _formatValue(campaign.statusLabel ?? campaign.status),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CampaignInfoTile(
                icon: Icons.tag_outlined,
                label: 'Campaign ID',
                value: campaign.id?.toString() ?? '—',
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value
        .trim()
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 21, color: color),
    );
  }
}

class _CampaignInfoTile extends StatelessWidget {
  const _CampaignInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
