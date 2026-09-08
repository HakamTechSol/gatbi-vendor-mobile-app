import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';

class BulkImportActionButtons extends StatelessWidget {
  const BulkImportActionButtons({
    super.key,
    required this.onStartImport,
    this.onReset,
    this.isLoading = false,
    this.isEnabled = true,
    this.showReset = true,
  });

  final VoidCallback? onStartImport;
  final VoidCallback? onReset;

  final bool isLoading;
  final bool isEnabled;
  final bool showReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Start Import',
          icon: Icons.cloud_upload_outlined,
          iconPosition: CustomButtonIconPosition.leading,
          onPressed: onStartImport,
          isLoading: isLoading,
          isEnabled: isEnabled,
          height: 52,
          borderRadius: 12,
          elevation: 2,
        ),

        if (showReset) ...[
          const SizedBox(height: 8),

          CustomButton(
            text: 'Reset',
            type: CustomButtonType.text,
            icon: Icons.refresh_rounded,
            iconPosition: CustomButtonIconPosition.leading,
            onPressed: onReset,
            height: 44,
            textStyle: AppTextStyles.buttonText,
            foregroundColor: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }
}
