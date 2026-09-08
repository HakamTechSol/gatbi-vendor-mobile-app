import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class BulkImportFilePicker extends StatelessWidget {
  const BulkImportFilePicker({
    super.key,
    required this.title,
    this.helperText,
    this.selectedFileName,
    this.onPick,
    this.onRemove,
    this.icon = Icons.insert_drive_file_outlined,
    this.required = false,
    this.allowedFormats,
  });

  final String title;
  final String? helperText;
  final String? selectedFileName;

  final VoidCallback? onPick;
  final VoidCallback? onRemove;

  final IconData icon;
  final bool required;

  final List<String>? allowedFormats;

  bool get hasFile =>
      selectedFileName != null && selectedFileName!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),

        const SizedBox(height: 9),

        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: hasFile ? AppColors.primarySurface : AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasFile ? AppColors.borderPrimary : AppColors.border,
            ),
          ),
          child: hasFile ? _buildSelectedFile() : _buildEmptyState(),
        ),

        if (helperText != null) ...[
          const SizedBox(height: 7),
          Text(helperText!, style: AppTextStyles.formHelper),
        ],

        if (allowedFormats != null && allowedFormats!.isNotEmpty) ...[
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: allowedFormats!
                .map((format) => _FormatChip(label: format))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(title, style: AppTextStyles.formLabel),

        if (required) ...[
          const SizedBox(width: 3),
          Text(
            '*',
            style: AppTextStyles.formLabel.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose File',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text('Tap to select a file', style: AppTextStyles.caption),
              ],
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.upload_file_rounded,
            size: 21,
            color: AppColors.iconSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 23,
            color: AppColors.success,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedFileName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 3),
              Text(
                'File selected successfully',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.successDark,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 4),

        IconButton(
          onPressed: onRemove,
          tooltip: 'Remove file',
          icon: const Icon(
            Icons.close_rounded,
            size: 20,
            color: AppColors.iconSecondary,
          ),
        ),
      ],
    );
  }
}

class _FormatChip extends StatelessWidget {
  const _FormatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.captionMedium),
    );
  }
}
