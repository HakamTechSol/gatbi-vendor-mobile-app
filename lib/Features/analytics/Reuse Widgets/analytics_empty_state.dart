import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';

class AnalyticsEmptyState extends StatelessWidget {
  const AnalyticsEmptyState({
    super.key,
    this.title = 'No analytics data yet',
    this.description =
        'Once you start receiving paid orders, your top products and revenue breakdown will appear here.',
    this.icon = Icons.bar_chart_rounded,
    this.buttonText,
    this.onButtonPressed,
  });

  final String title;
  final String description;
  final IconData icon;

  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─────────────────────────────────────────────────────────────────
          // ICON
          // ─────────────────────────────────────────────────────────────────

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.borderPrimary,
              ),
            ),
            child: Icon(
              icon,
              size: 30,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          // ─────────────────────────────────────────────────────────────────
          // TITLE
          // ─────────────────────────────────────────────────────────────────

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateTitle,
          ),

          const SizedBox(height: 8),

          // ─────────────────────────────────────────────────────────────────
          // DESCRIPTION
          // ─────────────────────────────────────────────────────────────────

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 360,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription,
            ),
          ),

          // ─────────────────────────────────────────────────────────────────
          // OPTIONAL ACTION
          // ─────────────────────────────────────────────────────────────────

          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 20),

            CustomButton(
              text: buttonText!,
              onPressed: onButtonPressed,
              type: CustomButtonType.outlined,
              width: 170,
              height: 44,
              borderRadius: 10,
              icon: Icons.arrow_forward_rounded,
              iconPosition: CustomButtonIconPosition.trailing,
            ),
          ],
        ],
      ),
    );
  }
}
