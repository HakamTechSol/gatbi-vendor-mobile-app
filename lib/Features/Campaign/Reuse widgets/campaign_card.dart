import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/campaign_model.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({super.key, required this.campaign, this.onTap});

  final CampaignModel campaign;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              Text(
                campaign.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 5),
              Text(
                campaign.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 14),
              _buildMeta(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.campaign_rounded,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        _StatusBadge(status: campaign.status, label: campaign.statusLabel),
      ],
    );
  }

  Widget _buildMeta() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (campaign.discount != null)
          _MetaItem(
            icon: Icons.local_offer_outlined,
            text: '${_formatDiscount(campaign.discount!)}% OFF',
          ),
        _MetaItem(
          icon: Icons.inventory_2_outlined,
          text: '${campaign.productCount} products',
        ),
        if (campaign.startDate != null)
          _MetaItem(
            icon: Icons.calendar_today_outlined,
            text: _formatDate(campaign.startDate!),
          ),
      ],
    );
  }

  String _formatDiscount(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.iconSecondary),
        const SizedBox(width: 5),
        Text(text, style: AppTextStyles.captionMedium),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.label});

  final CampaignStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.statusBadge.copyWith(color: colors.foreground),
      ),
    );
  }

  _StatusColors _statusColors(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.active:
        return const _StatusColors(
          background: AppColors.successLight,
          foreground: AppColors.successDark,
          border: AppColors.successBorder,
        );

      case CampaignStatus.scheduled:
        return const _StatusColors(
          background: AppColors.infoLight,
          foreground: AppColors.infoDark,
          border: AppColors.infoBorder,
        );

      case CampaignStatus.completed:
        return const _StatusColors(
          background: AppColors.primaryLight,
          foreground: AppColors.primary,
          border: AppColors.borderPrimary,
        );

      case CampaignStatus.cancelled:
        return const _StatusColors(
          background: AppColors.errorLight,
          foreground: AppColors.errorDark,
          border: AppColors.errorBorder,
        );

      case CampaignStatus.draft:
        return const _StatusColors(
          background: AppColors.draftLight,
          foreground: AppColors.draft,
          border: AppColors.border,
        );
    }
  }
}

class _StatusColors {
  const _StatusColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
