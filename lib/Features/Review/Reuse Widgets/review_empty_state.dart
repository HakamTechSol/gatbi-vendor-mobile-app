import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewEmptyState extends StatelessWidget {
  const ReviewEmptyState({
    super.key,
    this.title = 'No Reviews Yet',
    this.description =
        'Customer reviews for your products will appear here once they are submitted.',
    this.icon = Icons.rate_review_outlined,
    this.onRefresh,
    this.buttonText = 'Refresh Reviews',
  });

  // ===========================================================================
  // Fields
  // ===========================================================================

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRefresh;
  final String buttonText;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
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
          // Icon Container
          // -------------------------------------------------------------------
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              gradient: AppColors.softGradient,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderPrimary),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 32, color: AppColors.primary),
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------------------------------------------------
          // Title
          // -------------------------------------------------------------------
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // -------------------------------------------------------------------
          // Description
          // -------------------------------------------------------------------
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // Refresh Button
          // -------------------------------------------------------------------
          if (onRefresh != null) ...[
            const SizedBox(height: 22),
            _buildRefreshButton(),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // Refresh Button
  // ===========================================================================

  Widget _buildRefreshButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onRefresh,
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.borderPrimary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                buttonText,
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
