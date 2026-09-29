import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class AttributesErrorState extends StatelessWidget {
  const AttributesErrorState({
    super.key,
    this.title = 'Unable to Load Attributes',
    this.message =
        'Something went wrong while loading attributes. Please try again.',
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.errorBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ErrorIcon(),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.errorTitle.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.errorDescription.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 170,
                    child: CustomButton(
                      text: 'Try Again',
                      onPressed: onRetry,
                      height: 46,
                      borderRadius: 10,
                      icon: Icons.refresh_rounded,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: const Icon(
        Icons.error_outline_rounded,
        size: 34,
        color: AppColors.error,
      ),
    );
  }
}
