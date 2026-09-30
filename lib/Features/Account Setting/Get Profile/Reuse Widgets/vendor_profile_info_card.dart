import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/get_profile_model.dart';
import 'vendor_profile_info_tile.dart';

class VendorProfileInfoCard extends StatelessWidget {
  const VendorProfileInfoCard({super.key, required this.merchant});

  final VendorSettingsMerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    return _ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // CARD HEADER
          // ==========================================================
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: _SectionHeader(
              icon: Icons.business_center_outlined,
              title: 'Business Information',
              subtitle: 'Your primary merchant contact details',
            ),
          ),

          // ==========================================================
          // EMAIL
          // ==========================================================
          VendorProfileInfoTile(
            icon: Icons.email_outlined,
            title: 'Email Address',
            value: _value(merchant.email, fallback: 'Not provided'),
            showDivider: true,
          ),

          // ==========================================================
          // PHONE
          // ==========================================================
          VendorProfileInfoTile(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            value: _value(merchant.phone, fallback: 'Not provided'),
            iconColor: AppColors.success,
            iconBackground: AppColors.successLight,
            showDivider: true,
          ),

          // ==========================================================
          // STATUS
          // ==========================================================
          VendorProfileInfoTile(
            icon: Icons.verified_outlined,
            title: 'Account Status',
            value: _formatStatus(merchant.status),
            iconColor: _statusColor(merchant.status),
            iconBackground: _statusBackground(merchant.status),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  String _value(String? value, {required String fallback}) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }

    return value.trim();
  }

  String _formatStatus(String? status) {
    if (status == null || status.trim().isEmpty) {
      return 'Not available';
    }

    final value = status.trim();

    return value[0].toUpperCase() + value.substring(1);
  }

  Color _statusColor(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'approved':
      case 'active':
        return AppColors.success;

      case 'pending':
        return AppColors.warning;

      case 'rejected':
      case 'suspended':
        return AppColors.error;

      default:
        return AppColors.primary;
    }
  }

  Color _statusBackground(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'approved':
      case 'active':
        return AppColors.successLight;

      case 'pending':
        return AppColors.warningLight;

      case 'rejected':
      case 'suspended':
        return AppColors.errorLight;

      default:
        return AppColors.primaryLight;
    }
  }
}

// ================================================================
// PROFILE CARD
// ================================================================

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ================================================================
// SECTION HEADER
// ================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.business_center_outlined,
            size: 19,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.settingsSubtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
