import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';

class ProductBasicInfo extends StatelessWidget {
  const ProductBasicInfo({super.key, required this.product});

  final ProductDetailModel product;

  String _yesNo(bool value) {
    return value ? 'Yes' : 'No';
  }

  @override
  Widget build(BuildContext context) {
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
          _buildSectionTitle(),

          const SizedBox(height: 16),

          _buildInfoGrid(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION TITLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.09),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Details',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pricing, inventory & product information',
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

  // ═══════════════════════════════════════════════════════════════════════════
  // INFORMATION GRID
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildInfoGrid() {
    final items = <_InfoItem>[
      _InfoItem(
        label: 'Stock',
        value: '${product.stock}',
        icon: Icons.inventory_2_outlined,
        valueColor: product.isOutOfStock
            ? AppColors.error
            : product.isLowStock
            ? AppColors.warning
            : AppColors.success,
      ),
      _InfoItem(
        label: 'Category',
        value: _display(product.categoryName),
        icon: Icons.category_outlined,
      ),
      _InfoItem(
        label: 'Brand',
        value: _display(product.brandName),
        icon: Icons.branding_watermark_outlined,
      ),
      _InfoItem(
        label: 'Status',
        value: _display(product.status),
        icon: Icons.verified_outlined,
        valueColor: product.isInStock ? AppColors.success : AppColors.error,
      ),
      _InfoItem(
        label: 'Featured',
        value: _yesNo(product.isFeatured),
        icon: Icons.star_outline_rounded,
      ),
      _InfoItem(
        label: 'Trending',
        value: _yesNo(product.isTrending),
        icon: Icons.trending_up_rounded,
      ),
      _InfoItem(
        label: 'Flash Deal',
        value: _yesNo(product.isFlashDeal),
        icon: Icons.bolt_outlined,
      ),
      _InfoItem(
        label: 'Affiliates',
        value: product.allowAffiliates ? 'Allowed' : 'Not allowed',
        icon: Icons.people_outline_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 600 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 82,
          ),
          itemBuilder: (context, index) {
            return _buildInfoCard(items[index]);
          },
        );
      },
    );
  }

  Widget _buildInfoCard(_InfoItem item) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withOpacity(.7)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 17,
              color: item.valueColor ?? AppColors.primary,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: item.valueColor ?? AppColors.navy,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
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
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  String _display(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// INFO ITEM
// ═════════════════════════════════════════════════════════════════════════════

class _InfoItem {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
}
