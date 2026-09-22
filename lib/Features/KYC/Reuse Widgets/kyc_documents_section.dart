import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/vendor_kyc_document_model.dart';
import 'kyc_document_status_card.dart';

class KycDocumentsSection extends StatelessWidget {
  const KycDocumentsSection({
    super.key,
    required this.documents,
    this.onPreview,
    this.onDownload,
  });

  final List<VendorKycDocumentModel> documents;

  final void Function(VendorKycDocumentModel document)? onPreview;

  final void Function(VendorKycDocumentModel document)? onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.folder_copy_outlined,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submitted Documents',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${documents.length} document${documents.length == 1 ? '' : 's'} submitted',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (documents.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: [
                for (
                  int index = 0;
                  index < documents.length;
                  index++
                ) ...[
                  KycDocumentStatusCard(
                    document: documents[index],

                    // ------------------------------------------------
                    // Preview
                    // ------------------------------------------------

                    onPreview: onPreview == null
                        ? null
                        : () {
                            onPreview!(
                              documents[index],
                            );
                          },

                    // ------------------------------------------------
                    // Download
                    // ------------------------------------------------

                    onDownload: onDownload == null
                        ? null
                        : () {
                            onDownload!(
                              documents[index],
                            );
                          },
                  ),

                  if (index != documents.length - 1)
                    const SizedBox(height: 12),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.folder_off_outlined,
            size: 38,
            color: AppColors.iconSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            'No Documents Available',
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 5),
          Text(
            'No KYC documents have been submitted yet.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}