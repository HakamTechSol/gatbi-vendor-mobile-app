import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Get Campaign/Models/campaign_model.dart';

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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildTitle(),
              const SizedBox(height: 6),
              _buildCampaignType(),
              const SizedBox(height: 14),
              _buildMeta(),
              if (_hasNotes) ...[const SizedBox(height: 12), _buildNotes()],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.campaign_rounded,
            size: 21,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            campaign.campaignType ?? 'Campaign',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _StatusBadge(status: campaign.status, label: campaign.statusLabel),
      ],
    );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle() {
    return Text(
      campaign.name ?? 'Untitled campaign',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.titleMedium,
    );
  }

  // ============================================================
  // Campaign Type
  // ============================================================

  Widget _buildCampaignType() {
    final type = campaign.campaignType;

    if (type == null || type.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      _formatCampaignType(type),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ============================================================
  // Meta
  // ============================================================

  Widget _buildMeta() {
    return Wrap(
      spacing: 16,
      runSpacing: 9,
      children: [
        if (_discount != null)
          _MetaItem(
            icon: Icons.local_offer_outlined,
            text: '${_formatDiscount(_discount!)}% OFF',
          ),

        _MetaItem(
          icon: Icons.inventory_2_outlined,
          text: '${campaign.productIdList.length} products',
        ),

        if (campaign.startDate != null)
          _MetaItem(
            icon: Icons.calendar_today_outlined,
            text: _formatDate(campaign.startDate!),
          ),

        if (campaign.endDate != null)
          _MetaItem(
            icon: Icons.event_outlined,
            text: _formatDate(campaign.endDate!),
          ),
      ],
    );
  }

  // ============================================================
  // Notes
  // ============================================================

  bool get _hasNotes {
    final vendorNotes = campaign.vendorNotes;

    return vendorNotes != null && vendorNotes.trim().isNotEmpty;
  }

  Widget _buildNotes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notes_outlined,
            size: 17,
            color: AppColors.iconSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              campaign.vendorNotes!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Discount
  // ============================================================

  double? get _discount {
    return campaign.discountPercentage ?? campaign.requestedDiscountPercentage;
  }

  String _formatDiscount(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  // ============================================================
  // Campaign Type Formatting
  // ============================================================

  String _formatCampaignType(String value) {
    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  // ============================================================
  // Date Formatting
  // ============================================================

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);

    if (parsed == null) {
      return value;
    }

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

    return '${months[parsed.month - 1]} '
        '${parsed.day}, '
        '${parsed.year}';
  }
}

// ============================================================
// Meta Item
// ============================================================

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

// ============================================================
// Status Badge
// ============================================================

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.label});

  final String? status;
  final String? label;

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
        _displayLabel,
        style: AppTextStyles.statusBadge.copyWith(color: colors.foreground),
      ),
    );
  }

  // ============================================================
  // Display Label
  // ============================================================

  String get _displayLabel {
    if (label != null && label!.trim().isNotEmpty) {
      return label!.trim();
    }

    return _formatStatus(status);
  }

  // ============================================================
  // Fixed Status Colors
  // ============================================================

  _StatusColors _statusColors(String? status) {
    switch (status?.trim().toLowerCase()) {
      // ----------------------------------------------------------
      // Pending
      // ----------------------------------------------------------
      case 'pending':
        return const _StatusColors(
          background: AppColors.infoLight,
          foreground: AppColors.infoDark,
          border: AppColors.infoBorder,
        );

      // ----------------------------------------------------------
      // Approved
      // ----------------------------------------------------------
      case 'approved':
        return const _StatusColors(
          background: AppColors.successLight,
          foreground: AppColors.successDark,
          border: AppColors.successBorder,
        );

      // ----------------------------------------------------------
      // Active
      // ----------------------------------------------------------
      case 'active':
        return const _StatusColors(
          background: AppColors.successLight,
          foreground: AppColors.successDark,
          border: AppColors.successBorder,
        );

      // ----------------------------------------------------------
      // Rejected
      // ----------------------------------------------------------
      case 'rejected':
        return const _StatusColors(
          background: AppColors.errorLight,
          foreground: AppColors.errorDark,
          border: AppColors.errorBorder,
        );

      // ----------------------------------------------------------
      // Expired
      // ----------------------------------------------------------
      case 'expired':
        return const _StatusColors(
          background: AppColors.draftLight,
          foreground: AppColors.textSecondary,
          border: AppColors.border,
        );

      // ----------------------------------------------------------
      // Cancelled
      // ----------------------------------------------------------
      case 'cancelled':
        return const _StatusColors(
          background: AppColors.errorLight,
          foreground: AppColors.errorDark,
          border: AppColors.errorBorder,
        );

      // ----------------------------------------------------------
      // Unknown / Null
      // ----------------------------------------------------------
      default:
        return const _StatusColors(
          background: AppColors.draftLight,
          foreground: AppColors.textSecondary,
          border: AppColors.border,
        );
    }
  }

  // ============================================================
  // Status Text
  // ============================================================

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Unknown';
    }

    switch (value.trim().toLowerCase()) {
      case 'pending':
        return 'Pending';

      case 'approved':
        return 'Approved';

      case 'active':
        return 'Active';

      case 'rejected':
        return 'Rejected';

      case 'expired':
        return 'Expired';

      case 'cancelled':
        return 'Cancelled';

      default:
        return value
            .split('_')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }
}

// ============================================================
// Status Colors
// ============================================================

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
