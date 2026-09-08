import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';

class ProductVariantsCard extends StatelessWidget {
  const ProductVariantsCard({super.key, required this.product});

  final ProductDetailModel product;

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
              child: _buildVariant(variant),
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
                '${product.variants.length} attribute'
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

  Widget _buildVariant(ProductVariantModel variant) {
    final name = variant.name.trim();

    final values = variant.values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                name.isEmpty ? 'Variant' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),

            if (values.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.07),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '${values.length} option'
                  '${values.length == 1 ? '' : 's'}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 9.5,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 11),

        if (values.isEmpty)
          _buildEmptyOptions()
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) => _buildValueChip(value)).toList(),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VALUE CHIP
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildValueChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.09),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 12,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 7),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY OPTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyOptions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: 7),

          Text(
            'No options available',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
