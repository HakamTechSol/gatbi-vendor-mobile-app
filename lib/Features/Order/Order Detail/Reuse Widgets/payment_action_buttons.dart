import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PaymentActionButtons extends StatelessWidget {
  const PaymentActionButtons({
    super.key,
    required this.onApprove,
    required this.onReject,
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
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onReject,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Reject'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error.withValues(alpha: 0.35)),
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: AppTextStyles.buttonText,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onApprove,
            icon: isLoading
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(isLoading ? 'Processing...' : 'Accept'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: AppTextStyles.buttonText,
            ),
          ),
        ),
      ],
    );
  }
}
