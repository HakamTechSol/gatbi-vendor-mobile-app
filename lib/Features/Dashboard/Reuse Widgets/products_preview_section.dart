import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class ProductsPreviewSection extends StatelessWidget {
  const ProductsPreviewSection({
    super.key,
    this.productCount = 0,
    this.onAddProduct,
    this.onManageProducts,
  });

  /// Total number of products.
  final int productCount;

  /// Called when user taps "Add your first product".
  final VoidCallback? onAddProduct;

  /// Called when user taps "Manage products".
  final VoidCallback? onManageProducts;

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
          _buildHeader(context, isSmallScreen),

          const SizedBox(height: 16),

          if (productCount == 0)
            _buildEmptyState(context, isSmallScreen)
          else
            _buildProductsPlaceholder(context, isSmallScreen),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                productCount == 0
                    ? 'Manage your store catalogue'
                    : '$productCount products in your catalogue',
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
  // MANAGE PRODUCTS
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
  // EMPTY STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyState(BuildContext context, bool isSmallScreen) {
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
          _buildEmptyIcon(isSmallScreen),

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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
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
          ),

          const SizedBox(height: 16),

          _buildAddProductButton(isSmallScreen),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyIcon(bool isSmallScreen) {
    final iconSize = isSmallScreen ? 48.0 : 54.0;

    return Container(
      width: iconSize,
      height: iconSize,
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
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ADD PRODUCT BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAddProductButton(bool isSmallScreen) {
    return CustomButton(
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
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS PLACEHOLDER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductsPlaceholder(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 44 : 48,
            height: isSmallScreen ? 44 : 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: isSmallScreen ? 21 : 23,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Catalogue',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.navy,
                    fontSize: isSmallScreen ? 11 : 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$productCount ${productCount == 1 ? 'product' : 'products'} available',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: isSmallScreen ? 9 : 9.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primary,
            size: 13,
          ),
        ],
      ),
    );
  }
}
