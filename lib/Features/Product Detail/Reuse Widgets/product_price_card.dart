import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';
import 'product_detail_row.dart';

class ProductPriceCard extends StatelessWidget {
  const ProductPriceCard({super.key, required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final discount = _calculateDiscount();
    final profit = _calculateProfit();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 16),

          _buildMainPrice(),

          const SizedBox(height: 14),

          if (product.compareAtPrice != null)
            ProductDetailRow(
              label: 'Compare at price',
              value: _formatPrice(product.compareAtPrice),
              icon: Icons.price_check_rounded,
            ),

          if (product.costPrice != null)
            ProductDetailRow(
              label: 'Cost price',
              value: _formatPrice(product.costPrice),
              icon: Icons.account_balance_wallet_outlined,
            ),

          if (discount != null)
            ProductDetailRow(
              label: 'Discount',
              value: '${discount.toStringAsFixed(0)}%',
              icon: Icons.local_offer_outlined,
              valueColor: AppColors.success,
            ),

          if (profit != null)
            ProductDetailRow(
              label: 'Estimated profit',
              value: _formatPrice(profit),
              icon: Icons.trending_up_rounded,
              valueColor: AppColors.success,
              showDivider: false,
            )
          else if (product.costPrice == null)
            const SizedBox(height: 2),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      children: [
        _buildIcon(),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pricing',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Product pricing & profit overview',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(.14),
            AppColors.primaryDark.withOpacity(.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.payments_outlined,
        color: AppColors.primary,
        size: 21,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN PRICE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMainPrice() {
    final compareAtPrice = product.compareAtPrice;
    final hasComparePrice =
        compareAtPrice != null && compareAtPrice > (product.price ?? 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(.10),
            AppColors.primaryDark.withOpacity(.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(.10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.sell_outlined,
              color: AppColors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selling Price',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatPrice(product.price),
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          if (hasComparePrice)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Original',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatPrice(product.compareAtPrice),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  double? _calculateDiscount() {
    final compare = product.compareAtPrice;
    final price = product.price;

    if (compare == null || price == null || compare <= 0 || compare <= price) {
      return null;
    }

    return ((compare - price) / compare) * 100;
  }

  double? _calculateProfit() {
    final cost = product.costPrice;

    if (cost == null) {
      return null;
    }

    return product.price! - cost;
  }

  String _formatPrice(double? value) {
    if (value == null) {
      return '—';
    }

    return '${value.toStringAsFixed(2)} AED';
  }
}
