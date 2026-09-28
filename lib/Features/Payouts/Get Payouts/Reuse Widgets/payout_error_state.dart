import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutErrorState extends StatelessWidget {
  const PayoutErrorState({
    super.key,
    required this.onRetry,
    this.message = 'Unable to load payouts.',
  });

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 30,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Something Went Wrong',
              textAlign: TextAlign.center,
              style: AppTextStyles.errorTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message.trim().isEmpty
                  ? 'We could not load your payouts. Please try again.'
                  : message,
              textAlign: TextAlign.center,
              style: AppTextStyles.errorDescription.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Try Again',
              onPressed: onRetry,
              type: CustomButtonType.outlined,
              height: 46,
              borderRadius: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              icon: Icons.refresh_rounded,
              iconPosition: CustomButtonIconPosition.leading,
              textStyle: AppTextStyles.buttonOutlined,
            ),
          ],
        ),
      ),
    );
  }
}
