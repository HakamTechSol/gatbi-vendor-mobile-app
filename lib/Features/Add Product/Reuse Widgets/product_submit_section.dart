import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';

class ProductSubmitSection extends StatelessWidget {
  const ProductSubmitSection({
    super.key,
    required this.onSubmit,
    this.onCancel,
    this.isSubmitting = false,
    this.submitLabel = 'Create Product',
    this.submittingLabel = 'Saving Product...',
    this.cancelLabel = 'Cancel',
  });

  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;

  final bool isSubmitting;

  final String submitLabel;
  final String submittingLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 500;

          final cancelButton = CustomButton(
            text: cancelLabel,
            type: CustomButtonType.outlined,
            onPressed: isSubmitting ? null : onCancel,
            isEnabled: !isSubmitting && onCancel != null,
            height: 48,
            width: isSmall ? double.infinity : 120,
          );

          final submitButton = CustomButton(
            text: isSubmitting ? submittingLabel : submitLabel,
            type: CustomButtonType.primary,
            onPressed: onSubmit,
            isLoading: isSubmitting,
            isEnabled: onSubmit != null && !isSubmitting,
            height: 48,
            width: isSmall ? double.infinity : 180,
            icon: isSubmitting ? null : Icons.check_rounded,
            iconPosition: CustomButtonIconPosition.leading,
          );

          if (isSmall) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                submitButton,
                if (onCancel != null) ...[
                  const SizedBox(height: 10),
                  cancelButton,
                ],
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onCancel != null) ...[
                cancelButton,
                const SizedBox(width: 12),
              ],
              submitButton,
            ],
          );
        },
      ),
    );
  }
}
