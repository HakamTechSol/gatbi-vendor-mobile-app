import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/campaign_detail_model.dart';

class CampaignDetailHeader extends StatelessWidget {
  const CampaignDetailHeader({super.key, required this.campaign, this.onBack});

  final CampaignDetailData campaign;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBackButton(),
              const SizedBox(width: 12),
              Expanded(child: _buildTitleSection()),
              const SizedBox(width: 12),
              _CampaignStatusBadge(
                status: campaign.status,
                label: campaign.statusLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: AppColors.primarySurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onBack,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 21,
            color: AppColors.iconPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    final name = campaign.name?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name?.isNotEmpty == true ? name! : 'Campaign Details',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.campaign_outlined,
              size: 14,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                _formatCampaignType(campaign.campaignType),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCampaignType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campaign';
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

class _CampaignStatusBadge extends StatelessWidget {
  const _CampaignStatusBadge({required this.status, this.label});

  final String? status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final statusValue = status?.toLowerCase().trim() ?? '';

    final colors = _statusColors(statusValue);

    final displayLabel = label?.trim().isNotEmpty == true
        ? label!.trim()
        : _formatStatus(statusValue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.foreground.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            displayLabel,
            style: AppTextStyles.statusBadge.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _StatusColors _statusColors(String status) {
    switch (status) {
      case 'active':
      case 'completed':
        return const _StatusColors(
          foreground: AppColors.success,
          background: AppColors.successLight,
        );

      case 'scheduled':
      case 'processing':
        return const _StatusColors(
          foreground: AppColors.info,
          background: AppColors.infoLight,
        );

      case 'pending':
        return const _StatusColors(
          foreground: AppColors.warning,
          background: AppColors.warningLight,
        );

      case 'cancelled':
      case 'rejected':
        return const _StatusColors(
          foreground: AppColors.error,
          background: AppColors.errorLight,
        );

      case 'draft':
        return const _StatusColors(
          foreground: AppColors.textSecondary,
          background: AppColors.surfaceMuted,
        );

      default:
        return const _StatusColors(
          foreground: AppColors.textSecondary,
          background: AppColors.surfaceMuted,
        );
    }
  }

  String _formatStatus(String value) {
    if (value.isEmpty) {
      return 'Unknown';
    }

    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _StatusColors {
  const _StatusColors({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}
