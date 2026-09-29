import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class EventKycCard extends StatelessWidget {
  const EventKycCard({
    super.key,
    required this.kycStatus,
    required this.kycLocked,
  });

  final String? kycStatus;
  final bool kycLocked;

  @override
  Widget build(BuildContext context) {
    final status = _normalizeStatus(kycStatus);

    final config = _getConfig(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: config.borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: config.lightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(config.icon, size: 21, color: config.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'KYC Verification',
                  style: AppTextStyles.titleMedium,
                ),
              ),
              _KycStatusBadge(
                label: config.label,
                color: config.color,
                backgroundColor: config.lightColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: config.lightColor,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: config.borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(config.icon, size: 20, color: config.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.title,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: config.darkColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        config.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (kycLocked) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 17,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Event participation is currently locked until KYC requirements are completed.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _normalizeStatus(String? value) {
    return value?.trim().toLowerCase() ?? 'not_submitted';
  }

  _KycConfig _getConfig(String status) {
    switch (status) {
      case 'approved':
      case 'verified':
      case 'completed':
        return const _KycConfig(
          label: 'Approved',
          title: 'KYC verification approved',
          description:
              'Your KYC verification has been approved. You can participate in eligible events.',
          color: AppColors.success,
          darkColor: AppColors.successDark,
          lightColor: AppColors.successLight,
          borderColor: AppColors.successBorder,
          icon: Icons.verified_user_outlined,
        );

      case 'pending':
      case 'processing':
      case 'under_review':
      case 'submitted':
        return const _KycConfig(
          label: 'Pending',
          title: 'KYC verification is pending',
          description:
              'Your KYC documents are currently being reviewed. Some event actions may remain unavailable.',
          color: AppColors.warning,
          darkColor: AppColors.warningDark,
          lightColor: AppColors.warningLight,
          borderColor: AppColors.warningBorder,
          icon: Icons.hourglass_top_rounded,
        );

      case 'rejected':
      case 'failed':
        return const _KycConfig(
          label: 'Rejected',
          title: 'KYC verification requires attention',
          description:
              'Your KYC verification was not approved. Please review your KYC information and submit the required documents again.',
          color: AppColors.error,
          darkColor: AppColors.errorDark,
          lightColor: AppColors.errorLight,
          borderColor: AppColors.errorBorder,
          icon: Icons.gpp_bad_outlined,
        );

      case 'not_submitted':
      case 'not-submitted':
      case 'incomplete':
      case 'unverified':
      default:
        return const _KycConfig(
          label: 'Not Submitted',
          title: 'KYC verification is required',
          description:
              'Complete your KYC verification before participating in events that require verified vendor information.',
          color: AppColors.draft,
          darkColor: AppColors.textSecondary,
          lightColor: AppColors.surfaceMuted,
          borderColor: AppColors.border,
          icon: Icons.assignment_late_outlined,
        );
    }
  }
}

class _KycStatusBadge extends StatelessWidget {
  const _KycStatusBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.statusBadge.copyWith(color: color),
      ),
    );
  }
}

class _KycConfig {
  const _KycConfig({
    required this.label,
    required this.title,
    required this.description,
    required this.color,
    required this.darkColor,
    required this.lightColor,
    required this.borderColor,
    required this.icon,
  });

  final String label;
  final String title;
  final String description;
  final Color color;
  final Color darkColor;
  final Color lightColor;
  final Color borderColor;
  final IconData icon;
}
