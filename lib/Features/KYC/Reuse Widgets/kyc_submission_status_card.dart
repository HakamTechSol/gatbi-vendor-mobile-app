import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class KycSubmissionStatusCard extends StatelessWidget {
  const KycSubmissionStatusCard({
    super.key,
    required this.status,
    this.message,
    this.onRefresh,
  });

  final String? status;
  final String? message;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status?.trim().toLowerCase();

    final statusInfo = _getStatusInfo(normalizedStatus);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusInfo.color.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ========================================================
          // ICON
          // ========================================================
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: statusInfo.color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(statusInfo.icon, color: statusInfo.color, size: 34),
          ),

          const SizedBox(height: 18),

          // ========================================================
          // TITLE
          // ========================================================
          Text(
            'KYC Submitted Successfully',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // ========================================================
          // MESSAGE
          // ========================================================
          Text(
            message ?? 'Your KYC information has been submitted successfully.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // ========================================================
          // STATUS
          // ========================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusInfo.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: statusInfo.color.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusInfo.icon, size: 17, color: statusInfo.color),
                const SizedBox(width: 7),
                Text(
                  statusInfo.label,
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: statusInfo.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ========================================================
          // REVIEW MESSAGE
          // ========================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: AppColors.iconSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Our compliance team will review your submitted information and documents.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // REFRESH
          // ========================================================
          if (onRefresh != null) ...[
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Refresh Status'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // STATUS INFO
  // ============================================================

  _KycStatusInfo _getStatusInfo(String? status) {
    switch (status) {
      case 'approved':
      case 'verified':
        return const _KycStatusInfo(
          label: 'Approved',
          icon: Icons.verified_rounded,
          color: AppColors.success,
        );

      case 'rejected':
      case 'declined':
        return const _KycStatusInfo(
          label: 'Rejected',
          icon: Icons.cancel_outlined,
          color: AppColors.error,
        );

      case 'under_review':
      case 'review':
        return const _KycStatusInfo(
          label: 'Under Review',
          icon: Icons.manage_search_rounded,
          color: AppColors.primary,
        );

      case 'pending':
      default:
        return const _KycStatusInfo(
          label: 'Pending Review',
          icon: Icons.hourglass_top_rounded,
          color: AppColors.primary,
        );
    }
  }
}

// ================================================================
// STATUS INFO
// ================================================================

class _KycStatusInfo {
  const _KycStatusInfo({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
