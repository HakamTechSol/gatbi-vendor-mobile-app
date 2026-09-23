import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';
import 'product_detail_row.dart';

class ProductPriceCard extends StatelessWidget {
  const ProductPriceCard({super.key, required this.product});

  final ProductDetailItemModel product;

  @override
  Widget build(BuildContext context) {
    final discount = _calculateDiscount();

    final price = product.price;
    final originalPrice = _originalPrice;

    final hasOriginalPrice =
        originalPrice != null && price != null && originalPrice > price;

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

          // ======================================================
          // ORIGINAL PRICE
          // ======================================================
          if (hasOriginalPrice)
            ProductDetailRow(
              label: 'Original price',
              value: _formatPrice(originalPrice),
              icon: Icons.price_check_rounded,
            ),

          // ======================================================
          // SALE PRICE
          // ======================================================
          if (product.salePrice != null && product.salePrice != product.price)
            ProductDetailRow(
              label: 'Sale price',
              value: _formatPrice(product.salePrice),
              icon: Icons.local_offer_outlined,
              valueColor: AppColors.success,
            ),

          // ======================================================
          // DISCOUNT
          // ======================================================
          if (discount != null)
            ProductDetailRow(
              label: 'Discount',
              value: '${discount.toStringAsFixed(0)}%',
              icon: Icons.percent_rounded,
              valueColor: AppColors.success,
            ),

          // ======================================================
          // PRICE RANGE
          // ======================================================
          if (_hasPriceRange)
            ProductDetailRow(
              label: 'Price range',
              value: _formatPriceRange(),
              icon: Icons.swap_vert_rounded,
              showDivider: false,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

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
                'Product pricing & discount overview',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),

        if (product.onSale) _buildSaleBadge(),
      ],
    );
  }

  // ============================================================
  // ICON
  // ============================================================

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

  // ============================================================
  // SALE BADGE
  // ============================================================

  Widget _buildSaleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(.09),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 13,
            color: AppColors.success,
          ),

          const SizedBox(width: 4),

          Text(
            'On Sale',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN PRICE
  // ============================================================

  Widget _buildMainPrice() {
    final price = product.price;
    final originalPrice = _originalPrice;

    final hasOriginalPrice =
        originalPrice != null && price != null && originalPrice > price;

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
                  _formatPrice(price),
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          if (hasOriginalPrice)
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
                  _formatPrice(originalPrice),
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

  // ============================================================
  // ORIGINAL PRICE
  // ============================================================

  double? get _originalPrice {
    // API has both regular_price and price_old.
    // price_old is the direct old/compare price used by
    // the Product Detail response.
    final priceOld = product.priceOld;

    if (priceOld != null && priceOld > 0) {
      return priceOld;
    }

    final regularPrice = product.regularPrice;

    if (regularPrice != null && regularPrice > 0) {
      return regularPrice;
    }

    final basePriceOld = product.basePriceOld;

    if (basePriceOld != null && basePriceOld > 0) {
      return basePriceOld;
    }

    return null;
  }

  // ============================================================
  // DISCOUNT
  // ============================================================

  double? _calculateDiscount() {
    final price = product.price;
    final originalPrice = _originalPrice;

    if (price == null ||
        originalPrice == null ||
        originalPrice <= 0 ||
        originalPrice <= price) {
      return null;
    }

    return ((originalPrice - price) / originalPrice) * 100;
  }

  // ============================================================
  // PRICE RANGE
  // ============================================================

  bool get _hasPriceRange {
    if (!product.hasVariants) {
      return false;
    }

    final min = product.priceMin;
    final max = product.priceMax;

    if (min == null || max == null) {
      return false;
    }

    return min != max;
  }

  String _formatPriceRange() {
    final min = product.priceMin;
    final max = product.priceMax;

    if (min == null || max == null) {
      return '—';
    }

    return '${_formatAmount(min)} - ${_formatAmount(max)} '
        '${_currencyLabel}';
  }

  // ============================================================
  // PRICE FORMAT
  // ============================================================

  String _formatPrice(double? value) {
    if (value == null) {
      return '—';
    }

    return '${_formatAmount(value)} $_currencyLabel';
  }

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  // ============================================================
  // CURRENCY
  // ============================================================

  String get _currencyLabel {
    final symbol = product.currencySymbol?.trim() ?? '';

    if (symbol.isNotEmpty) {
      return symbol;
    }

    final currency = product.currency?.trim() ?? '';

    if (currency.isNotEmpty) {
      return currency;
    }

    return 'AED';
  }
}
