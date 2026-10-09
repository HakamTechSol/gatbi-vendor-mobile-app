// lib/View/Vendor/Dashboard/widgets/products_preview_section.dart

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isVerySmall = constraints.maxWidth < 370;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withValues(alpha: 0.055),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductsHeader(
                productCount: products.length,
                hasProducts: products.isNotEmpty,
                onManageProducts: onManageProducts,
                isMobile: isMobile,
              ),

              SizedBox(height: isMobile ? 15 : 18),

              if (products.isEmpty)
                _ProductsEmptyState(
                  onAddProduct: onAddProduct,
                  isMobile: isMobile,
                )
              else
                _ProductsList(
                  products: products,
                  onProductTap: onProductTap,
                  isMobile: isMobile,
                  isVerySmall: isVerySmall,
                ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({
    required this.productCount,
    required this.hasProducts,
    required this.onManageProducts,
    required this.isMobile,
  });

  final int productCount;
  final bool hasProducts;
  final VoidCallback? onManageProducts;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isMobile ? 42 : 46,
          height: isMobile ? 42 : 46,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow.withValues(alpha: 0.16),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            color: AppColors.white,
            size: isMobile ? 20 : 22,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Your Products',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.navy,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  if (hasProducts) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$productCount',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 4),

              Text(
                hasProducts
                    ? 'Manage your latest store products'
                    : 'Manage your store catalogue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 10 : 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        if (onManageProducts != null) ...[
          const SizedBox(width: 8),
          _ManageProductsButton(onTap: onManageProducts!, isMobile: isMobile),
        ],
      ],
    );
  }
}

// ============================================================================
// MANAGE PRODUCTS BUTTON
// ============================================================================

class _ManageProductsButton extends StatelessWidget {
  const _ManageProductsButton({required this.onTap, required this.isMobile});

  final VoidCallback onTap;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight.withValues(alpha: 0.70),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Manage',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.primary,
                  fontSize: isMobile ? 9 : 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PRODUCTS LIST
// ============================================================================

class _ProductsList extends StatelessWidget {
  const _ProductsList({
    required this.products,
    required this.onProductTap,
    required this.isMobile,
    required this.isVerySmall,
  });

  final List<DashboardProductModel> products;
  final ValueChanged<DashboardProductModel>? onProductTap;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < products.length; index++) ...[
          _ProductCard(
            product: products[index],
            onTap: onProductTap == null
                ? null
                : () => onProductTap!(products[index]),
            isMobile: isMobile,
            isVerySmall: isVerySmall,
          ),

          if (index != products.length - 1) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

// ============================================================================
// PRODUCT CARD
// ============================================================================

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.isMobile,
    required this.isVerySmall,
  });

  final DashboardProductModel product;
  final VoidCallback? onTap;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    final StockInfo stockInfo = _getStockInfo(product);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(
            isVerySmall
                ? 9
                : isMobile
                ? 10
                : 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: stockInfo.color.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              _ProductImage(
                imageUrl: product.image,
                stockColor: stockInfo.color,
                isMobile: isMobile,
              ),

              SizedBox(width: isMobile ? 10 : 12),

              Expanded(
                child: _ProductInformation(
                  product: product,
                  stockInfo: stockInfo,
                  isMobile: isMobile,
                  isVerySmall: isVerySmall,
                ),
              ),

              SizedBox(width: isMobile ? 7 : 10),

              _ProductPriceSection(
                product: product,
                stockInfo: stockInfo,
                isMobile: isMobile,
                isVerySmall: isVerySmall,
              ),

              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.50),
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  StockInfo _getStockInfo(DashboardProductModel product) {
    final String status = product.stockStatus?.toLowerCase().trim() ?? '';

    final int quantity = product.stockQuantity ?? 0;

    if (status == 'out_of_stock' || quantity <= 0) {
      return const StockInfo(
        label: 'Out of stock',
        color: AppColors.error,
        icon: Icons.remove_circle_rounded,
      );
    }

    if (status == 'in_stock') {
      return const StockInfo(
        label: 'In stock',
        color: AppColors.success,
        icon: Icons.check_circle_rounded,
      );
    }

    return const StockInfo(
      label: 'Low stock',
      color: AppColors.warning,
      icon: Icons.warning_amber_rounded,
    );
  }
}

// ============================================================================
// PRODUCT IMAGE
// ============================================================================

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
    required this.stockColor,
    required this.isMobile,
  });

  final String? imageUrl;
  final Color stockColor;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final double size = isMobile ? 54 : 60;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: stockColor.withValues(alpha: 0.10)),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.trim().isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return Center(
                  child: SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.8,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) {
                return _ImagePlaceholder(size: size);
              },
            )
          : _ImagePlaceholder(size: size),
    );
  }
}

// ============================================================================
// IMAGE PLACEHOLDER
// ============================================================================

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLight.withValues(alpha: 0.75),
      alignment: Alignment.center,
      child: Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: size * 0.42,
      ),
    );
  }
}

// ============================================================================
// PRODUCT INFORMATION
// ============================================================================

class _ProductInformation extends StatelessWidget {
  const _ProductInformation({
    required this.product,
    required this.stockInfo,
    required this.isMobile,
    required this.isVerySmall,
  });

  final DashboardProductModel product;
  final StockInfo stockInfo;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    final int stockQuantity = product.stockQuantity ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name?.trim().isNotEmpty == true
              ? product.name!
              : 'Unnamed Product',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.navy,
            fontSize: isVerySmall
                ? 10.5
                : isMobile
                ? 11
                : 12,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: stockInfo.color.withValues(alpha: 0.85),
              size: 12,
            ),

            const SizedBox(width: 4),

            Flexible(
              child: Text(
                '$stockQuantity ${stockQuantity == 1 ? 'item' : 'items'} in stock',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 8.5 : 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// PRODUCT PRICE + STOCK
// ============================================================================

class _ProductPriceSection extends StatelessWidget {
  const _ProductPriceSection({
    required this.product,
    required this.stockInfo,
    required this.isMobile,
    required this.isVerySmall,
  });

  final DashboardProductModel product;
  final StockInfo stockInfo;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    final String currency = product.currencySymbol ?? product.currency ?? 'AED';

    final double price = product.price ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 105),
          child: Text(
            '$currency ${price.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontSize: isVerySmall
                  ? 10
                  : isMobile
                  ? 10.5
                  : 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),

        const SizedBox(height: 5),

        _StockBadge(
          stockInfo: stockInfo,
          isMobile: isMobile,
          isVerySmall: isVerySmall,
        ),
      ],
    );
  }
}

// ============================================================================
// STOCK BADGE
// ============================================================================

class _StockBadge extends StatelessWidget {
  const _StockBadge({
    required this.stockInfo,
    required this.isMobile,
    required this.isVerySmall,
  });

  final StockInfo stockInfo;
  final bool isMobile;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 105),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 7,
        vertical: isMobile ? 4 : 4,
      ),
      decoration: BoxDecoration(
        color: stockInfo.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: stockInfo.color.withValues(alpha: 0.07)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(stockInfo.icon, color: stockInfo.color, size: isMobile ? 9 : 10),

          const SizedBox(width: 4),

          Flexible(
            child: Text(
              stockInfo.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: stockInfo.color,
                fontSize: isVerySmall
                    ? 6.8
                    : isMobile
                    ? 7.2
                    : 7.8,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _ProductsEmptyState extends StatelessWidget {
  const _ProductsEmptyState({
    required this.onAddProduct,
    required this.isMobile,
  });

  final VoidCallback? onAddProduct;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 24,
        vertical: isMobile ? 26 : 30,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 62 : 68,
            height: isMobile ? 62 : 68,
            decoration: BoxDecoration(
              gradient: AppColors.softGradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryShadow.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.inventory_2_rounded,
              color: AppColors.primary,
              size: isMobile ? 28 : 31,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            "You haven't added any products yet",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              'Add products to start selling and make them available to your customers.',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 9.5 : 10,
                height: 1.45,
              ),
            ),
          ),

          const SizedBox(height: 17),

          CustomButton(
            text: 'Add your first product',
            icon: Icons.add_rounded,
            onPressed: onAddProduct,
            type: CustomButtonType.primary,
            width: isMobile ? 195 : 210,
            height: isMobile ? 43 : 45,
            borderRadius: 11,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            textStyle: AppTextStyles.buttonLarge.copyWith(
              color: AppColors.textOnPrimary,
              fontSize: isMobile ? 10.5 : 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STOCK INFO
// ============================================================================

class StockInfo {
  const StockInfo({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}
