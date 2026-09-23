import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';
import 'product_detail_row.dart';

class ProductSeoCard extends StatelessWidget {
  const ProductSeoCard({super.key, required this.product});

  final ProductDetailItemModel product;

  @override
  Widget build(BuildContext context) {
    final slug = product.slug?.trim() ?? '';

    // ============================================================
    // API currently provides only slug for SEO-related information.
    // Meta title, meta description, meta keywords and Arabic SEO
    // fields are not available in the current product detail API.
    // ============================================================

    if (slug.isEmpty) {
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

          _buildSeoTitle('SEO'),

          const SizedBox(height: 7),

          ProductDetailRow(
            label: 'Slug',
            value: slug,
            icon: Icons.link_rounded,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

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

  // ============================================================
  // SEO Section Title
  // ============================================================

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
}
