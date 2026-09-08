import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class AffiliateSection extends StatelessWidget {
  const AffiliateSection({
    super.key,
    required this.affiliateReadyProducts,
    required this.hiddenFromAffiliates,
    required this.commissionPercentage,
  });

  /// Products visible and available for affiliates.
  final int affiliateReadyProducts;

  /// Products hidden from affiliates.
  final int hiddenFromAffiliates;

  /// Example: 2.00
  final double commissionPercentage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;

        if (isSmallScreen) {
          return Column(
            children: [
              _buildAffiliateProductsCard(),

              const SizedBox(height: 12),

              _buildCommissionNote(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 4, child: _buildAffiliateProductsCard()),

            const SizedBox(width: 12),

            Expanded(flex: 7, child: _buildCommissionNote()),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AFFILIATE READY PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAffiliateProductsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.campaign_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Affiliate-ready Products',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  affiliateReadyProducts.toString(),
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.navy,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Hidden from affiliates: $hiddenFromAffiliates',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AFFILIATE COMMISSION NOTE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCommissionNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.percent_rounded,
              color: AppColors.primary,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Affiliate Commission Note',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.navy,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 9.5,
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'If your product sells via an affiliate, the affiliate earns ',
                      ),

                      TextSpan(
                        text: '${commissionPercentage.toStringAsFixed(2)}% ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const TextSpan(text: 'on the order subtotal.'),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'You can toggle affiliate visibility per product.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 8.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CARD DECORATION
  // ═══════════════════════════════════════════════════════════════════════════

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }
}
