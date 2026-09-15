import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/analytics_model.dart';

class TopProductItem extends StatelessWidget {
  const TopProductItem({
    super.key,
    required this.product,
    this.rank,
    this.onTap,
  });

  final AnalyticsTopProductModel product;
  final int? rank;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              _buildRank(),
              const SizedBox(width: 12),
              Expanded(child: _buildProductInfo()),
              const SizedBox(width: 8),
              _buildRevenue(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRank() {
    if (rank == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 24,
      child: Text(
        '#$rank',
        textAlign: TextAlign.center,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }


  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name ?? 'Unnamed Product',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.productName,
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 14,
              color: AppColors.iconSecondary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${product.units} units sold',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatAmount(product.revenue),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: AppTextStyles.productPrice.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text('Revenue', style: AppTextStyles.captionMedium),
      ],
    );
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }
}
