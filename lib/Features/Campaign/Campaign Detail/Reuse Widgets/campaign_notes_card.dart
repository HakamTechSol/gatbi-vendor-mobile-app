import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/campaign_detail_model.dart';

class CampaignNotesCard extends StatelessWidget {
  const CampaignNotesCard({super.key, required this.campaign});

  final CampaignDetailData campaign;

  @override
  Widget build(BuildContext context) {
    final hasVendorNotes = _hasText(campaign.vendorNotes);
    final hasAdminNotes = _hasText(campaign.adminNotes);

    // API response mein agar dono notes empty/null hon,
    // to complete notes card hide ho jayega.
    if (!hasVendorNotes && !hasAdminNotes) {
      return const SizedBox.shrink();
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 18),

          // Vendor notes sirf tab show honge jab API mein
          // actual non-empty vendor_notes available hon.
          if (hasVendorNotes)
            _NoteSection(
              icon: Icons.storefront_outlined,
              title: 'Vendor Notes',
              note: campaign.vendorNotes!.trim(),
              color: AppColors.primary,
              backgroundColor: AppColors.primarySurface,
            ),

          // Dono sections ke darmiyan spacing sirf tab
          // jab dono available hon.
          if (hasVendorNotes && hasAdminNotes) const SizedBox(height: 12),

          // Admin notes sirf tab show honge jab API mein
          // actual non-empty admin_notes available hon.
          if (hasAdminNotes)
            _NoteSection(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Admin Notes',
              note: campaign.adminNotes!.trim(),
              color: AppColors.purple,
              backgroundColor: AppColors.purpleLight,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notes_outlined,
            size: 21,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Notes',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Additional campaign information',
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

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _NoteSection extends StatelessWidget {
  const _NoteSection({
    required this.icon,
    required this.title,
    required this.note,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String title;
  final String note;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  note,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
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
