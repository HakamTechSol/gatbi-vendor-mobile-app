import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutEmptyState extends StatelessWidget {
  const PayoutEmptyState({
    super.key,
    required this.onRequestPayout,
    this.title = 'No Payouts Yet',
    this.description =
        'You don’t have any payout requests yet. Request your first payout to get started.',
    this.isEnabled = true,
  });

  final VoidCallback onRequestPayout;
  final String title;
  final String description;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
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
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                gradient: AppColors.softGradient,
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 34,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            CustomButton(
              text: 'Request Payout',
              onPressed: onRequestPayout,
              isEnabled: isEnabled,
              height: 48,
              borderRadius: 11,
              width: double.infinity,
              icon: Icons.add_rounded,
              iconPosition: CustomButtonIconPosition.leading,
              textStyle: AppTextStyles.buttonMedium,
            ),
          ],
        ),
      ),
    );
  }
}
