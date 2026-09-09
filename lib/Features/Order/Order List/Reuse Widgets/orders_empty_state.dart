import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({
    super.key,
    this.title = 'No orders found',
    this.description =
        'There are no orders matching your current search or filter.',
    this.icon = Icons.receipt_long_outlined,
    this.onClearFilters,
    this.actionText = 'Clear filters',
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onClearFilters;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppColors.primary),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateTitle,
            ),

            const SizedBox(height: 8),

            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            if (onClearFilters != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onClearFilters,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: Text(actionText, style: AppTextStyles.buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
