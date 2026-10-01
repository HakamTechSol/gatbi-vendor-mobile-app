import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class NotificationsErrorState extends StatelessWidget {
  const NotificationsErrorState({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final displayMessage = message?.trim();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.errorBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --------------------------------------------------
              // Icon
              // --------------------------------------------------
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.errorBorder),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_off_outlined,
                  size: 31,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // Title
              // --------------------------------------------------
              Text(
                'Unable to load notifications',
                textAlign: TextAlign.center,
                style: AppTextStyles.errorTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // --------------------------------------------------
              // Description
              // --------------------------------------------------
              Text(
                displayMessage != null && displayMessage.isNotEmpty
                    ? displayMessage
                    : 'Something went wrong while loading your '
                          'notifications. Please try again.',
                textAlign: TextAlign.center,
                style: AppTextStyles.errorDescription.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              if (onRetry != null) ...[
                const SizedBox(height: 20),

                _buildRetryButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Retry Button
  // ============================================================

  Widget _buildRetryButton() {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onRetry,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          constraints: const BoxConstraints(minWidth: 120, maxWidth: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.white,
              ),

              const SizedBox(width: 7),

              Text(
                'Try Again',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
