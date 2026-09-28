import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class QuestionErrorState extends StatelessWidget {
  const QuestionErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'Unable to Load Questions',
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildErrorIcon(),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message.trim().isNotEmpty
                ? message.trim()
                : 'Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 125,
            child: CustomButton(
              text: 'Retry',
              onPressed: onRetry,
              height: 42,
              borderRadius: 11,
              icon: Icons.refresh_rounded,
              iconPosition: CustomButtonIconPosition.leading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.cloud_off_rounded,
        size: 30,
        color: AppColors.error,
      ),
    );
  }
}
