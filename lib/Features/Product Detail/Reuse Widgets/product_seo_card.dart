import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';
import 'product_detail_row.dart';

class ProductSeoCard extends StatelessWidget {
  const ProductSeoCard({super.key, required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final hasSeo =
        product.slug!.trim().isNotEmpty ||
        product.metaTitle!.trim().isNotEmpty ||
        product.metaDescription!.trim().isNotEmpty ||
        product.metaKeywords!.trim().isNotEmpty;

    final hasArabicSeo =
        product.arabicMetaTitle!.trim().isNotEmpty ||
        product.arabicMetaDescription!.trim().isNotEmpty ||
        product.arabicMetaKeywords!.trim().isNotEmpty;

    if (!hasSeo && !hasArabicSeo) {
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

          const SizedBox(height: 17),

          if (hasSeo) ...[
            _buildSeoTitle('English SEO'),

            const SizedBox(height: 7),

            if (product.slug!.trim().isNotEmpty)
              ProductDetailRow(
                label: 'Slug',
                value: product.slug!,
                icon: Icons.link_rounded,
              ),

            if (product.metaTitle!.trim().isNotEmpty)
              ProductDetailRow(
                label: 'Meta Title',
                value: product.metaTitle!,
                icon: Icons.title_rounded,
              ),

            if (product.metaDescription!.trim().isNotEmpty)
              _buildLongValue(
                label: 'Meta Description',
                value: product.metaDescription!,
                icon: Icons.short_text_rounded,
              ),

            if (product.metaKeywords!.trim().isNotEmpty)
              _buildLongValue(
                label: 'Meta Keywords',
                value: product.metaKeywords!,
                icon: Icons.key_rounded,
              ),
          ],

          if (hasSeo && hasArabicSeo) ...[
            const SizedBox(height: 18),
            Divider(height: 1, color: AppColors.border.withOpacity(.65)),
            const SizedBox(height: 18),
          ],

          if (hasArabicSeo) ...[
            _buildSeoTitle('Arabic SEO'),

            const SizedBox(height: 7),

            if (product.arabicMetaTitle!.trim().isNotEmpty)
              ProductDetailRow(
                label: 'Meta Title',
                value: product.arabicMetaTitle!,
                icon: Icons.title_rounded,
              ),

            if (product.arabicMetaDescription!.trim().isNotEmpty)
              _buildArabicValue(
                label: 'Meta Description',
                value: product.arabicMetaDescription!,
                icon: Icons.short_text_rounded,
              ),

            if (product.arabicMetaKeywords!.trim().isNotEmpty)
              _buildArabicValue(
                label: 'Meta Keywords',
                value: product.arabicMetaKeywords!,
                icon: Icons.key_rounded,
                showDivider: false,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SEO',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Search engine optimization details',
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

  Widget _buildSeoTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 10.5,
        ),
      ),
    );
  }

  Widget _buildLongValue({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: AppColors.primary),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.border.withOpacity(.65)),
      ],
    );
  }

  Widget _buildArabicValue({
    required String label,
    required String value,
    required IconData icon,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: AppColors.primary),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: AppColors.border.withOpacity(.65)),
      ],
    );
  }
}
