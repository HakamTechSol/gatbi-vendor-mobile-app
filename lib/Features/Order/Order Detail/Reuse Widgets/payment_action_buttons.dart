import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';

class PaymentActionButtons extends StatelessWidget {
  const PaymentActionButtons({
    super.key,
    this.onApprove,
    this.onReject,
    this.isLoading = false,
  });

  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Reject',
            type: CustomButtonType.outlined,
            icon: Icons.close_rounded,
            height: 46,
            borderRadius: 10,
            borderColor: AppColors.errorBorder,
            foregroundColor: AppColors.error,
            onPressed: isLoading ? null : onReject,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CustomButton(
            text: isLoading ? 'Processing...' : 'Approve',
            type: CustomButtonType.primary,
            icon: isLoading ? null : Icons.check_rounded,
            height: 46,
            borderRadius: 10,
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.white,
            isLoading: isLoading,
            onPressed: isLoading ? null : onApprove,
          ),
        ),
      ],
    );
  }
}
