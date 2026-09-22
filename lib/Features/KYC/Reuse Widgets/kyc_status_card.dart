import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class KycStatusCard extends StatelessWidget {
  const KycStatusCard({
    super.key,
    required this.status,
    this.statusLabel,
    this.message,
    this.rejectionReason,
    this.submissionCount,
    this.onRefresh,
  });

  final String? status;
  final String? statusLabel;
  final String? message;
  final String? rejectionReason;
  final int? submissionCount;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final info = _getStatusInfo(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: info.color.withValues(alpha: 0.22)),
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
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(info.icon, color: info.color, size: 36),
          ),

          const SizedBox(height: 18),

          Text(
            info.title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            message ?? info.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: info.color.withValues(alpha: 0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(info.icon, size: 17, color: info.color),
                const SizedBox(width: 7),
                Text(
                  statusLabel?.trim().isNotEmpty == true
                      ? statusLabel!
                      : info.label,
                  style: AppTextStyles.buttonSmall.copyWith(color: info.color),
                ),
              ],
            ),
          ),

          if (submissionCount != null) ...[
            const SizedBox(height: 12),
            Text(
              'Submission count: $submissionCount',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],

          if (rejectionReason != null &&
              rejectionReason!.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            _buildRejectionBox(rejectionReason!),
          ],

          const SizedBox(height: 20),

          _buildInfoBox(info),

          if (onRefresh != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
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
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRejectionBox(String reason) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rejection Reason',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(_KycStatusInfo info) {
    return Container(
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
          Icon(info.infoIcon, size: 20, color: info.color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              info.infoMessage,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _KycStatusInfo _getStatusInfo(String? value) {
    final normalized = value?.trim().toLowerCase();

    switch (normalized) {
      case 'approved':
      case 'verified':
        return const _KycStatusInfo(
          label: 'Approved',
          title: 'KYC Approved',
          description: 'Your KYC verification has been successfully approved.',
          infoMessage:
              'Your business verification is complete. You can continue using your vendor account.',
          icon: Icons.verified_rounded,
          infoIcon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
        );

      case 'rejected':
      case 'declined':
        return const _KycStatusInfo(
          label: 'Rejected',
          title: 'KYC Requires Attention',
          description:
              'Your KYC submission was not approved. Please review the reason below.',
          infoMessage:
              'Update the required information or documents and submit your KYC again.',
          icon: Icons.cancel_outlined,
          infoIcon: Icons.info_outline_rounded,
          color: AppColors.error,
        );

      case 'under_review':
      case 'review':
      case 'in_review':
        return const _KycStatusInfo(
          label: 'Under Review',
          title: 'KYC Is Under Review',
          description:
              'Your information and documents have been submitted and are currently being reviewed.',
          infoMessage:
              'Our compliance team is reviewing your submitted information and documents. You can refresh the status at any time.',
          icon: Icons.manage_search_rounded,
          infoIcon: Icons.info_outline_rounded,
          color: AppColors.primary,
        );

      case 'pending':
      default:
        return const _KycStatusInfo(
          label: 'Pending Review',
          title: 'KYC Submitted Successfully',
          description:
              'Your KYC information and documents have been submitted successfully.',
          infoMessage:
              'Our compliance team will review your submitted information and documents.',
          icon: Icons.hourglass_top_rounded,
          infoIcon: Icons.info_outline_rounded,
          color: AppColors.primary,
        );
    }
  }
}

class _KycStatusInfo {
  const _KycStatusInfo({
    required this.label,
    required this.title,
    required this.description,
    required this.infoMessage,
    required this.icon,
    required this.infoIcon,
    required this.color,
  });

  final String label;
  final String title;
  final String description;
  final String infoMessage;

  final IconData icon;
  final IconData infoIcon;

  final Color color;
}
