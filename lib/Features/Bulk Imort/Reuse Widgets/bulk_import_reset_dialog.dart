import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';

class BulkImportResetDialog extends StatelessWidget {
  const BulkImportResetDialog({
    super.key,
    this.title = 'Reset Import?',
    this.description =
        'This will remove the selected files and reset the '
        'current import setup. This action cannot be undone.',
    this.confirmText = 'Reset Import',
    this.cancelText = 'Cancel',
    this.onConfirm,
  });

  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;

  static Future<bool?> show(
    BuildContext context, {
    String title = 'Reset Import?',
    String description =
        'This will remove the selected files and reset the '
        'current import setup. This action cannot be undone.',
    String confirmText = 'Reset Import',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => BulkImportResetDialog(
        title: title,
        description: description,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 23,
                    color: AppColors.warningDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(title, style: AppTextStyles.titleMedium),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  tooltip: 'Close',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.iconSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(description, style: AppTextStyles.bodySmall),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: cancelText,
                    type: CustomButtonType.outlined,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    height: 46,
                    borderRadius: 10,
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: confirmText,
                    onPressed: onConfirm,
                    height: 46,
                    borderRadius: 10,
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
