import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class StoreStatusBanner extends StatelessWidget {
  const StoreStatusBanner({
    super.key,
    required this.isStoreApproved,
    this.onViewDetails,
  });

  /// true = Store approved
  /// false = Store pending / under review
  final bool isStoreApproved;

  /// Optional action for viewing store application/details.
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    // Store approved hai to banner show nahi hoga.
    if (isStoreApproved) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══════════════════════════════════════════════════════════════
          // ICON
          // ═══════════════════════════════════════════════════════════════

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          // ═══════════════════════════════════════════════════════════════
          // CONTENT
          // ═══════════════════════════════════════════════════════════════

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your store application is under review',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Our team is reviewing your store details. '
                  'You will be able to add products once your store is approved.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),

                if (onViewDetails != null) ...[
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: onViewDetails,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View application',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}