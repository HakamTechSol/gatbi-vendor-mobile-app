import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileEmpty extends StatelessWidget {
  const VendorProfileEmpty({super.key, this.onRefresh});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ==========================================================
            // EMPTY ICON
            // ==========================================================
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                gradient: AppColors.softGradient,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.storefront_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================================
            // TITLE
            // ==========================================================
            Text(
              'Profile Not Available',
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateTitle,
            ),

            const SizedBox(height: 8),

            // ==========================================================
            // DESCRIPTION
            // ==========================================================
            Text(
              'Your merchant profile information is not '
              'available right now. Please refresh and try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription.copyWith(height: 1.55),
            ),

            // ==========================================================
            // REFRESH BUTTON
            // ==========================================================
            if (onRefresh != null) ...[
              const SizedBox(height: 22),

              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Refresh Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.borderPrimary),
                  backgroundColor: AppColors.primarySurface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
