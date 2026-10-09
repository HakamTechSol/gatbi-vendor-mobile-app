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

  final double grossAmount;
  final double shippingAmount;
  final double commissionAmount;
  final double netPayable;
  final double commissionPercentage;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isSmall = width < 520;

        return Column(
          children: [
            _buildNetHeroCard(),

            const SizedBox(height: 12),

            if (isSmall)
              Column(
                children: [
                  _buildGrossCard(),
                  const SizedBox(height: 12),
                  _buildCommissionCard(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildGrossCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCommissionCard()),
                ],
              ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // NET PAYABLE HERO
  // ===========================================================================

  Widget _buildNetHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // -------------------------------------------------------------------
          // LEFT ICON
          // -------------------------------------------------------------------
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.14),
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          // -------------------------------------------------------------------
          // CONTENT
          // -------------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Net Payable to You',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencySymbol,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.82),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          netPayable.toStringAsFixed(2),
                          maxLines: 1,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            height: 0.95,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  'Estimated earnings after Gatbi commission',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.72),
                    fontSize: 8.8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // GROSS CARD
  // ===========================================================================

  Widget _buildGrossCard() {
    return _SmallEarningsCard(
      icon: Icons.shopping_bag_rounded,
      iconColor: AppColors.primary,
      iconBackground: AppColors.primary.withValues(alpha: 0.08),
      title: 'Products Gross',
      amount: grossAmount,
      currencySymbol: currencySymbol,
      subtitle: 'Total sales generated',
      bottom: Row(
        children: [
          Expanded(
            child: _MiniInfo(
              icon: Icons.inventory_2_outlined,
              label: 'Products',
              value: '$currencySymbol ${grossAmount.toStringAsFixed(2)}',
            ),
          ),
          Container(
            width: 1,
            height: 28,
            color: AppColors.divider.withValues(alpha: 0.8),
          ),
          Expanded(
            child: _MiniInfo(
              icon: Icons.local_shipping_outlined,
              label: 'Shipping',
              value: '$currencySymbol ${shippingAmount.toStringAsFixed(2)}',
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // COMMISSION CARD
  // ===========================================================================

  Widget _buildCommissionCard() {
    return _SmallEarningsCard(
      icon: Icons.percent_rounded,
      iconColor: AppColors.errorDark,
      iconBackground: AppColors.error.withValues(alpha: 0.08),
      title: 'Gatbi Commission',
      amount: commissionAmount,
      currencySymbol: currencySymbol,
      subtitle: 'Deducted from your sales',
      badge: '${commissionPercentage.toStringAsFixed(2)}%',
    );
  }
}

// =============================================================================
// SMALL EARNINGS CARD
// =============================================================================

class _SmallEarningsCard extends StatelessWidget {
  const _SmallEarningsCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.amount,
    required this.currencySymbol,
    required this.subtitle,
    this.bottom,
    this.badge,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  final String title;
  final double amount;
  final String currencySymbol;
  final String subtitle;

  final Widget? bottom;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.045),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------------
          // TOP
          // -------------------------------------------------------------------
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 8.8,
                      ),
                    ),
                  ],
                ),
              ),

              if (badge != null) ...[
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.errorDark,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          // -------------------------------------------------------------------
          // AMOUNT
          // -------------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencySymbol,
                style: AppTextStyles.titleMedium.copyWith(
                  color: iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount.toStringAsFixed(2),
                    maxLines: 1,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.navy,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (bottom != null) ...[
            const SizedBox(height: 13),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(11),
              ),
              child: bottom!,
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// MINI INFO
// =============================================================================

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: AppColors.primary, size: 13),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 7.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.navy,
                  fontSize: 8.8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
