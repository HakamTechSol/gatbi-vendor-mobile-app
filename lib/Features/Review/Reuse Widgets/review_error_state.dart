import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewErrorState extends StatelessWidget {
  const ReviewErrorState({
    super.key,
    this.title = 'Unable to Load Reviews',
    this.message =
        'Something went wrong while loading customer reviews. Please try again.',
    this.onRetry,
    this.buttonText = 'Try Again',
  });

  // ===========================================================================
  // Fields
  // ===========================================================================

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String buttonText;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.errorBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------------------------------------------------------------------
          // Error Icon
          // -------------------------------------------------------------------
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.errorBorder),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              size: 34,
              color: AppColors.error,
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------------------------------------------------
          // Title
          // -------------------------------------------------------------------
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.errorTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // -------------------------------------------------------------------
          // Message
          // -------------------------------------------------------------------
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.errorDescription.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // Retry Button
          // -------------------------------------------------------------------
          if (onRetry != null) ...[
            const SizedBox(height: 22),
            _buildRetryButton(),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // Retry Button
  // ===========================================================================

  Widget _buildRetryButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRetry,
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.errorBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.error,
              ),
              const SizedBox(width: 7),
              Text(
                buttonText,
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.errorDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
