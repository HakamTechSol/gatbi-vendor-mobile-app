import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/vendor_kyc_document_model.dart';

class KycDocumentStatusCard extends StatelessWidget {
  const KycDocumentStatusCard({
    super.key,
    required this.document,
    this.onPreview,
    this.onDownload,
  });

  final VendorKycDocumentModel document;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(document.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDocumentIcon(),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDocumentType(document.documentType),
                      style: AppTextStyles.titleSmall,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      document.uploadedAt ?? 'Upload date unavailable',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              _buildStatusBadge(statusInfo),
            ],
          ),

          if (document.rejectionReason != null &&
              document.rejectionReason!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildRejectionMessage(document.rejectionReason!),
          ],

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPreview,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Preview'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDownload,
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentIcon() {
    final isPdf = document.fileUrl?.toLowerCase().contains('pdf') == true;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isPdf ? Icons.picture_as_pdf_outlined : Icons.description_outlined,
        color: AppColors.primary,
        size: 23,
      ),
    );
  }

  Widget _buildStatusBadge(_DocumentStatusInfo info) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.icon, size: 14, color: info.color),
          const SizedBox(width: 5),
          Text(
            info.label,
            style: AppTextStyles.caption.copyWith(
              color: info.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionMessage(String reason) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reason,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDocumentType(String? type) {
    switch (type?.trim().toLowerCase()) {
      case 'trade_license':
        return 'Trade License Copy';

      case 'id_card':
      case 'authorized_id':
        return 'Authorized Person ID';

      case 'tax_certificate':
      case 'vat':
        return 'VAT / Tax Registration';

      case 'other':
      case 'additional':
        return 'Additional Supporting Document';

      default:
        if (type == null || type.trim().isEmpty) {
          return 'KYC Document';
        }

        return type
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }

  _DocumentStatusInfo _getStatusInfo(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'approved':
      case 'verified':
        return const _DocumentStatusInfo(
          label: 'Approved',
          icon: Icons.verified_rounded,
          color: AppColors.success,
        );

      case 'rejected':
      case 'declined':
        return const _DocumentStatusInfo(
          label: 'Rejected',
          icon: Icons.cancel_outlined,
          color: AppColors.error,
        );

      case 'review':
      case 'in_review':
        return const _DocumentStatusInfo(
          label: 'In Review',
          icon: Icons.manage_search_rounded,
          color: AppColors.primary,
        );

      case 'pending':
      default:
        return const _DocumentStatusInfo(
          label: 'Pending',
          icon: Icons.hourglass_top_rounded,
          color: AppColors.primary,
        );
    }
  }
}

class _DocumentStatusInfo {
  const _DocumentStatusInfo({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
