import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class EarningsSummarySection extends StatelessWidget {
  const EarningsSummarySection({
    super.key,
    required this.grossAmount,
    required this.shippingAmount,
    required this.commissionAmount,
    required this.netPayable,
    required this.commissionPercentage,
    this.currencySymbol = 'د.إ',
  });

  /// Total products gross amount.
  final double grossAmount;

  /// Total shipping amount.
  final double shippingAmount;

  /// Gatbi commission amount.
  final double commissionAmount;

  /// Amount payable to vendor.
  final double netPayable;

  /// Example: 5.00
  final double commissionPercentage;

  /// API dashboard currently uses AED.
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 360) {
          return Column(
            children: [
              _buildGrossCard(),

              const SizedBox(height: 12),

              _buildCommissionCard(),

              const SizedBox(height: 12),

              _buildNetPayableCard(),
            ],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildGrossCard()),

                const SizedBox(width: 12),

                Expanded(child: _buildCommissionCard()),
              ],
            ),

            const SizedBox(height: 12),

            _buildNetPayableCard(),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // YOUR PRODUCTS GROSS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildGrossCard() {
    return _EarningsSummaryCard(
      icon: Icons.shopping_bag_outlined,
      iconColor: AppColors.primary,
      iconBackgroundColor: AppColors.primaryLight,
      title: 'Your Products Gross',
      amount: grossAmount,
      currencySymbol: currencySymbol,
      subtitle: 'Products: $currencySymbol ${grossAmount.toStringAsFixed(2)}',
      secondarySubtitle:
          'Shipping: $currencySymbol ${shippingAmount.toStringAsFixed(2)}',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GATBI COMMISSION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCommissionCard() {
    return _EarningsSummaryCard(
      icon: Icons.content_cut_rounded,
      iconColor: AppColors.errorDark,
      iconBackgroundColor: AppColors.error.withValues(alpha: 0.10),
      title: 'Gatbi Commission (${commissionPercentage.toStringAsFixed(2)}%)',
      amount: commissionAmount,
      currencySymbol: currencySymbol,
      subtitle: 'Deducted from your sales',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NET PAYABLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildNetPayableCard() {
    return _EarningsSummaryCard(
      icon: Icons.account_balance_wallet_outlined,
      iconColor: AppColors.success,
      iconBackgroundColor: AppColors.success.withValues(alpha: 0.10),
      title: 'Net Payable to You',
      amount: netPayable,
      currencySymbol: currencySymbol,
      subtitle: 'Gross minus Gatbi commission',
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// REUSABLE EARNINGS CARD
// ═════════════════════════════════════════════════════════════════════════════

class _EarningsSummaryCard extends StatelessWidget {
  const _EarningsSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.amount,
    required this.currencySymbol,
    required this.subtitle,
    this.secondarySubtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  final String title;
  final double amount;
  final String currencySymbol;

  final String subtitle;
  final String? secondarySubtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 132),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: iconColor, size: 23),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 5),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$currencySymbol ${amount.toStringAsFixed(2)}',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                  ),
                ),

                if (secondarySubtitle != null) ...[
                  const SizedBox(height: 2),

                  Text(
                    secondarySubtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 9,
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
