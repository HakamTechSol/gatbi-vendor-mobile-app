import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';

class ProductBasicInfo extends StatelessWidget {
  const ProductBasicInfo({super.key, required this.product});

  final ProductDetailItemModel product;

  // ============================================================
  // Yes / No
  // ============================================================

  String _yesNo(bool value) {
    return value ? 'Yes' : 'No';
  }

  // ============================================================
  // Stock Status
  // ============================================================

  bool get _isOutOfStock {
    return product.stockStatus?.toLowerCase() == 'out_of_stock' ||
        (product.stockQuantity ?? 0) <= 0;
  }

  bool get _isLowStock {
    final stock = product.stockQuantity ?? 0;

    return !_isOutOfStock && stock > 0 && stock <= 5;
  }

  bool get _isInStock {
    return !_isOutOfStock;
  }

  // ============================================================
  // Build
  // ============================================================

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

  // ============================================================
  // SECTION TITLE
  // ============================================================

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
                'Inventory, category & product information',
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
  // INFORMATION GRID
  // ============================================================

  Widget _buildInfoGrid() {
    final items = <_InfoItem>[
      // --------------------------------------------------------
      // Stock
      // --------------------------------------------------------
      _InfoItem(
        label: 'Stock',
        value: '${product.stockQuantity ?? 0}',
        icon: Icons.inventory_2_outlined,
        valueColor: _isOutOfStock
            ? AppColors.error
            : _isLowStock
            ? AppColors.warning
            : AppColors.success,
      ),

      // --------------------------------------------------------
      // Stock Status
      // --------------------------------------------------------
      _InfoItem(
        label: 'Stock Status',
        value: _formatStatus(product.stockStatus),
        icon: Icons.inventory_outlined,
        valueColor: _isInStock ? AppColors.success : AppColors.error,
      ),

      // --------------------------------------------------------
      // Category
      // --------------------------------------------------------
      _InfoItem(
        label: 'Category',
        value: _display(product.category?.name),
        icon: Icons.category_outlined,
      ),

      // --------------------------------------------------------
      // Brand
      // --------------------------------------------------------
      _InfoItem(
        label: 'Brand',
        value: _display(product.brand),
        icon: Icons.branding_watermark_outlined,
      ),

      // --------------------------------------------------------
      // Status
      // --------------------------------------------------------
      _InfoItem(
        label: 'Status',
        value: product.isActive ? 'Active' : 'Inactive',
        icon: Icons.verified_outlined,
        valueColor: product.isActive ? AppColors.success : AppColors.error,
      ),

      // --------------------------------------------------------
      // Featured
      // --------------------------------------------------------
      _InfoItem(
        label: 'Featured',
        value: _yesNo(product.featured),
        icon: Icons.star_outline_rounded,
        valueColor: product.featured ? AppColors.warning : null,
      ),

      // --------------------------------------------------------
      // Flash Deal
      // --------------------------------------------------------
      _InfoItem(
        label: 'Flash Deal',
        value: _yesNo(product.isFlashDeal),
        icon: Icons.bolt_outlined,
        valueColor: product.isFlashDeal ? AppColors.warning : null,
      ),

      // --------------------------------------------------------
      // On Sale
      // --------------------------------------------------------
      _InfoItem(
        label: 'On Sale',
        value: _yesNo(product.onSale),
        icon: Icons.local_offer_outlined,
        valueColor: product.onSale ? AppColors.success : null,
      ),

      // --------------------------------------------------------
      // Variants
      // --------------------------------------------------------
      _InfoItem(
        label: 'Variants',
        value: product.hasVariants
            ? '${product.variants.length} Available'
            : 'No Variants',
        icon: Icons.tune_rounded,
        valueColor: product.hasVariants ? AppColors.primary : null,
      ),

      // --------------------------------------------------------
      // SKU
      // --------------------------------------------------------
      _InfoItem(
        label: 'SKU',
        value: _display(product.sku),
        icon: Icons.qr_code_2_rounded,
      ),

      // --------------------------------------------------------
      // Merchant
      // --------------------------------------------------------
      _InfoItem(
        label: 'Merchant',
        value: _display(product.merchantName),
        icon: Icons.storefront_outlined,
      ),

      // --------------------------------------------------------
      // Reviews
      // --------------------------------------------------------
      _InfoItem(
        label: 'Reviews',
        value: '${product.reviewCount ?? 0}',
        icon: Icons.rate_review_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= 900
            ? 4
            : width >= 600
            ? 3
            : 2;

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

  // ============================================================
  // INFO CARD
  // ============================================================

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

  // ============================================================
  // DISPLAY
  // ============================================================

  String _display(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value;
  }

  // ============================================================
  // FORMAT STATUS
  // ============================================================

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    final formatted = value.replaceAll('_', ' ').replaceAll('-', ' ').trim();

    if (formatted.isEmpty) {
      return '—';
    }

    return formatted
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

// ================================================================
// INFO ITEM
// ================================================================

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
