import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/campaign_detail_model.dart';

class CampaignDiscountCard extends StatelessWidget {
  const CampaignDiscountCard({super.key, required this.campaign});

  final CampaignDetailData campaign;

  @override
  Widget build(BuildContext context) {
    final discount = campaign.discountPercentage;
    final requestedDiscount = campaign.requestedDiscountPercentage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.percent_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Campaign Discount',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPercentage(discount),
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'Discount',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnPrimarySecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.white.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.request_quote_outlined,
                  size: 18,
                  color: AppColors.white,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Requested Discount',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnPrimarySecondary,
                    ),
                  ),
                ),
                Text(
                  _formatPercentage(requestedDiscount),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPercentage(double? value) {
    if (value == null) {
      return '—';
    }

    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }

    return '${value.toStringAsFixed(1)}%';
  }
}
