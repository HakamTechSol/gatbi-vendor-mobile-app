import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutAmount extends StatelessWidget {
  const PayoutAmount({
    super.key,
    required this.amount,
    this.currency = 'AED',
    this.symbol,
  });

  final double? amount;
  final String? currency;
  final String? symbol;

  String _formatAmount() {
    if (amount == null) {
      return '0.00';
    }

    return amount!.toStringAsFixed(2);
  }

  String _displayCurrency() {
    final currencySymbol = symbol?.trim();

    if (currencySymbol != null && currencySymbol.isNotEmpty) {
      return currencySymbol;
    }

    final currencyCode = currency?.trim();

    if (currencyCode != null && currencyCode.isNotEmpty) {
      return currencyCode;
    }

    return 'AED';
  }

  @override
  Widget build(BuildContext context) {
    final displayCurrency = _displayCurrency();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderPrimary.withOpacity(0.65)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ============================================================
          // WALLET ICON
          // ============================================================
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppColors.borderPrimary.withOpacity(0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              size: 21,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          // ============================================================
          // AMOUNT CONTENT
          // ============================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payout Amount',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        _formatAmount(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // ==================================================
                    // CURRENCY BADGE
                    // ==================================================
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          displayCurrency,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.captionMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ============================================================
          // DECORATIVE INDICATOR
          // ============================================================
          Container(
            width: 7,
            height: 34,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
