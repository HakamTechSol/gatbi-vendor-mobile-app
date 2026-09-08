import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class BulkImportImageHelp extends StatelessWidget {
  const BulkImportImageHelp({
    super.key,
    this.title = 'How to Link Product Images',
    this.description =
        'Upload your product images inside the ZIP file and use '
        'the exact image file names in the CSV.',
    this.zipDescription =
        'Keep all image files inside the ZIP without changing '
        'their file names.',
    this.csvDescription =
        'Enter matching file names in the hero_image or '
        'gallery_images columns.',
  });

  final String title;
  final String description;
  final String zipDescription;
  final String csvDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  size: 21,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 4),
                    Text(description, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _HelpStep(
            number: '1',
            title: 'Prepare your ZIP',
            description: zipDescription,
            icon: Icons.folder_zip_outlined,
          ),
          const SizedBox(height: 10),
          _HelpStep(
            number: '2',
            title: 'Match the file names',
            description: csvDescription,
            icon: Icons.link_rounded,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: AppColors.warningDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Example: product-001.jpg in the ZIP should be '
                    'written as product-001.jpg in the CSV.',
                    style: AppTextStyles.captionMedium,
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

class _HelpStep extends StatelessWidget {
  const _HelpStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelLarge),
                    const SizedBox(height: 2),
                    Text(description, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
