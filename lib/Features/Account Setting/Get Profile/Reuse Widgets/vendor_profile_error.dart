import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileError extends StatelessWidget {
  const VendorProfileError({
    super.key,
    this.message = 'We couldn’t load your profile information.',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ==========================================================
            // ERROR ICON
            // ==========================================================
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.errorBorder),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 38,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================================
            // TITLE
            // ==========================================================
            Text(
              'Unable to Load Profile',
              textAlign: TextAlign.center,
              style: AppTextStyles.errorTitle,
            ),

            const SizedBox(height: 8),

            // ==========================================================
            // DESCRIPTION
            // ==========================================================
            Text(
              message.trim().isEmpty
                  ? 'Something went wrong while loading your profile.'
                  : message,
              textAlign: TextAlign.center,
              style: AppTextStyles.errorDescription.copyWith(height: 1.55),
            ),

            // ==========================================================
            // RETRY
            // ==========================================================
            if (onRetry != null) ...[
              const SizedBox(height: 22),

              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onRetry,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: AppColors.white,
                        ),

                        const SizedBox(width: 8),

                        Text('Try Again', style: AppTextStyles.buttonMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
