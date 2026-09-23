import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';
import '../Model/product_detail_option_value_model.dart';
import '../Model/product_detail_variant_model.dart';

class ProductVariantsCard extends StatelessWidget {
  const ProductVariantsCard({super.key, required this.product});

  final ProductDetailItemModel product;

  @override
  Widget build(BuildContext context) {
    // No variants → don't show the card.
    if (product.variants.isEmpty) {
      return const SizedBox.shrink();
    }

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

          const SizedBox(height: 18),

          ...List.generate(product.variants.length, (index) {
            final variant = product.variants[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == product.variants.length - 1 ? 0 : 18,
              ),
              child: _buildVariant(variant, index),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Variants',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '${product.variants.length} variant'
                '${product.variants.length == 1 ? '' : 's'} available',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '${product.variants.length}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildVariant(ProductDetailVariantModel variant, int index) {
    final sku = variant.sku?.trim() ?? '';
    final stock = variant.stockQty ?? 0;
    final price = variant.price;
    final optionValues = variant.optionValues;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border.withOpacity(.75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVariantHeader(variant: variant, index: index),

          const SizedBox(height: 13),

          if (optionValues.isNotEmpty) ...[
            _buildOptions(optionValues),
            const SizedBox(height: 13),
          ],

          _buildVariantDetails(
            variant: variant,
            sku: sku,
            stock: stock,
            price: price,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANT HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildVariantHeader({
    required ProductDetailVariantModel variant,
    required int index,
  }) {
    final isActive = variant.isActive;

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.09),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 10.5,
              ),
            ),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            'Variant ${index + 1}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withOpacity(.09)
                : AppColors.error.withOpacity(.09),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive
                    ? Icons.check_circle_outline_rounded
                    : Icons.cancel_outlined,
                size: 13,
                color: isActive ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                isActive ? 'Active' : 'Inactive',
                style: AppTextStyles.caption.copyWith(
                  color: isActive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w800,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OPTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOptions(List<ProductDetailOptionValueModel> options) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: options.map((option) => _buildOptionChip(option)).toList(),
    );
  }

  Widget _buildOptionChip(ProductDetailOptionValueModel option) {
    final attributeName = option.attribute?.trim() ?? '';
    final value = option.value?.trim() ?? '';
    final code = option.code?.trim() ?? '';

    final hasAttribute = attributeName.isNotEmpty;
    final hasValue = value.isNotEmpty;
    final hasCode = code.isNotEmpty;

    if (!hasAttribute && !hasValue) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasCode) ...[
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: _parseColor(code),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
            ),
            const SizedBox(width: 7),
          ] else ...[
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 11,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 7),
          ],

          if (hasAttribute)
            Text(
              '$attributeName: ',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 9.5,
              ),
            ),

          Text(
            hasValue ? value : '—',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANT DETAILS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildVariantDetails({
    required ProductDetailVariantModel variant,
    required String sku,
    required int stock,
    required double? price,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            icon: Icons.payments_outlined,
            label: 'Price',
            value: _formatPrice(price),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildDetailItem(
            icon: Icons.inventory_2_outlined,
            label: 'Stock',
            value: '$stock',
            valueColor: _stockColor(stock),
          ),
        ),

        if (sku.isNotEmpty) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _buildDetailItem(
              icon: Icons.qr_code_2_rounded,
              label: 'SKU',
              value: sku,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withOpacity(.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor ?? AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  String _formatPrice(double? price) {
    if (price == null) {
      return '—';
    }

    final symbol = product.currencySymbol?.trim() ?? '';

    if (symbol.isNotEmpty) {
      return '${price.toStringAsFixed(2)} $symbol';
    }

    final currency = product.currency?.trim() ?? '';

    if (currency.isNotEmpty) {
      return '${price.toStringAsFixed(2)} $currency';
    }

    return price.toStringAsFixed(2);
  }

  Color _stockColor(int stock) {
    if (stock <= 0) {
      return AppColors.error;
    }

    if (stock <= 10) {
      return AppColors.warning;
    }

    return AppColors.success;
  }

  Color _parseColor(String value) {
    var hex = value.trim().replaceFirst('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    if (hex.length == 8) {
      final colorValue = int.tryParse(hex, radix: 16);

      if (colorValue != null) {
        return Color(colorValue);
      }
    }

    return AppColors.primary;
  }
}
