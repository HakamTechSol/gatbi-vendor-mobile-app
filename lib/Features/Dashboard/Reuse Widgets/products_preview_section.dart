import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Models/dashboard_product_model.dart';

class ProductsPreviewSection extends StatelessWidget {
  const ProductsPreviewSection({
    super.key,
    required this.products,
    this.onAddProduct,
    this.onManageProducts,
    this.onProductTap,
  });

  final List<DashboardProductModel> products;

  final VoidCallback? onAddProduct;
  final VoidCallback? onManageProducts;

  final ValueChanged<DashboardProductModel>? onProductTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isSmallScreen),

          const SizedBox(height: 16),

          if (products.isEmpty)
            _buildEmptyState(isSmallScreen)
          else
            _buildProductsList(isSmallScreen),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(bool isSmallScreen) {
    return Row(
      children: [
        Container(
          width: isSmallScreen ? 40 : 44,
          height: isSmallScreen ? 40 : 44,
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.primaryLight),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            color: AppColors.primary,
            size: isSmallScreen ? 19 : 21,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Products',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontSize: isSmallScreen ? 14 : 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                products.isEmpty
                    ? 'Manage your store catalogue'
                    : '${products.length} recent products',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isSmallScreen ? 9.5 : 10,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        _buildManageButton(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MANAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildManageButton() {
    return InkWell(
      onTap: onManageProducts,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Manage',
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.primary,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(width: 3),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS LIST
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductsList(bool isSmallScreen) {
    return Column(
      children: [
        for (int index = 0; index < products.length; index++) ...[
          _buildProductTile(products[index], isSmallScreen),

          if (index != products.length - 1)
            Divider(height: 1, color: AppColors.divider.withValues(alpha: 0.7)),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT TILE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductTile(DashboardProductModel product, bool isSmallScreen) {
    return InkWell(
      onTap: onProductTap == null ? null : () => onProductTap!(product),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _buildProductImage(product, isSmallScreen),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Unnamed Product',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.navy,
                      fontSize: isSmallScreen ? 10.5 : 11.5,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${product.stockQuantity ?? 0} in stock',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.currencySymbol ?? product.currency ?? 'AED'} '
                  '${(product.price ?? 0).toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.navy,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                _buildStockBadge(product),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT IMAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductImage(DashboardProductModel product, bool isSmallScreen) {
    final size = isSmallScreen ? 48.0 : 54.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(13),
      ),
      clipBehavior: Clip.antiAlias,
      child: product.image != null && product.image!.isNotEmpty
          ? Image.network(
              product.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primary,
                  size: isSmallScreen ? 21 : 23,
                );
              },
            )
          : Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: isSmallScreen ? 21 : 23,
            ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STOCK BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStockBadge(DashboardProductModel product) {
    final status = product.stockStatus?.toLowerCase() ?? '';

    final bool isInStock = status == 'in_stock';
    final bool isOutOfStock = status == 'out_of_stock';

    final Color badgeColor;
    final Color textColor;

    if (isInStock) {
      badgeColor = AppColors.success.withValues(alpha: 0.10);
      textColor = AppColors.success;
    } else if (isOutOfStock) {
      badgeColor = AppColors.error.withValues(alpha: 0.10);
      textColor = AppColors.error;
    } else {
      badgeColor = AppColors.warning.withValues(alpha: 0.10);
      textColor = AppColors.warning;
    }

    final label = isInStock
        ? 'In stock'
        : isOutOfStock
        ? 'Out of stock'
        : 'Low stock';

    return Container(
      constraints: const BoxConstraints(maxWidth: 85),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyState(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 20 : 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
      ),
      child: Column(
        children: [
          Container(
            width: isSmallScreen ? 48 : 54,
            height: isSmallScreen ? 48 : 54,
            decoration: BoxDecoration(
              gradient: AppColors.softGradient,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: isSmallScreen ? 23 : 26,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "You haven't added any products yet",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontSize: isSmallScreen ? 12 : 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Add products to start selling and make them available to your customers.',
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: isSmallScreen ? 9.5 : 10,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          CustomButton(
            text: 'Add your first product',
            icon: Icons.add_rounded,
            onPressed: onAddProduct,
            type: CustomButtonType.primary,
            width: isSmallScreen ? 190 : 205,
            height: isSmallScreen ? 42 : 44,
            borderRadius: 10,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            textStyle: AppTextStyles.buttonLarge.copyWith(
              color: AppColors.textOnPrimary,
              fontSize: isSmallScreen ? 10.5 : 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
