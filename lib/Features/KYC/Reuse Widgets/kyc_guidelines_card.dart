import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class KycGuidelinesCard extends StatelessWidget {
  const KycGuidelinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    const guidelines = [
      'Ensure all documents are clear, readable, and in colour where applicable.',
      'Trade license must be valid for at least 30 days from today.',
      'Owner / authorized ID must match the person responsible for the store.',
      'If your submission was rejected, upload corrected documents to resubmit.',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 19,
                color: AppColors.infoDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Guidelines',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.infoDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...guidelines.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: AppColors.infoDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.infoDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
