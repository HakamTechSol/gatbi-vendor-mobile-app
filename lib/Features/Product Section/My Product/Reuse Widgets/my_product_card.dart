import 'package:flutter/material.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';
import '../Models/my_product_model.dart';

class MyProductCard extends StatelessWidget {
  const MyProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStockEdit,

    // Bulk selection
    this.selectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  final MyProductModel product;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStockEdit;

  // ============================================================
  // BULK SELECTION
  // ============================================================

  final bool selectionMode;

  final bool isSelected;

  final ValueChanged<bool>? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: selectionMode
            ? () {
                onSelectionChanged?.call(!isSelected);
              }
            : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.035)
                : AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.55)
                  : AppColors.border,
              width: isSelected ? 1.3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withValues(alpha: 0.055),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectionMode) ...[
                _buildSelectionRadio(),

                const SizedBox(width: 8),
              ],

              _buildProductImage(),

              const SizedBox(width: 12),

              Expanded(child: _buildProductInformation()),

              const SizedBox(width: 4),

              if (!selectionMode) _buildActionMenu(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SELECTION RADIO
  // ============================================================

  Widget _buildSelectionRadio() {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: GestureDetector(
        onTap: () {
          onSelectionChanged?.call(!isSelected);
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 21,
          height: 21,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.primary : AppColors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          child: isSelected
              ? const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: AppColors.white,
                )
              : null,
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _buildProductImage() {
    final String imageUrl = product.image?.trim() ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 88,
        height: 98,
        color: AppColors.background,
        child: imageUrl.isEmpty
            ? _buildImagePlaceholder()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _buildImagePlaceholder(isLoading: true);
                },
              ),
      ),
    );
  }

  Widget _buildImagePlaceholder({bool isLoading = false}) {
    return Center(
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : const Icon(
              Icons.image_outlined,
              size: 28,
              color: AppColors.textSecondary,
            ),
    );
  }

  // ============================================================
  // PRODUCT INFORMATION
  // ============================================================

  Widget _buildProductInformation() {
    final String productName = product.name?.trim().isNotEmpty == true
        ? product.name!.trim()
        : 'Unnamed Product';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory(),

        const SizedBox(height: 4),

        Text(
          productName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),

        if (_hasSku) ...[const SizedBox(height: 3), _buildSku()],

        const SizedBox(height: 8),

        _buildPriceRow(),

        const SizedBox(height: 8),

        _buildBottomRow(),
      ],
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategory() {
    final String category = product.category?.name?.trim() ?? '';

    if (category.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // SKU
  // ============================================================

  bool get _hasSku {
    return product.sku?.trim().isNotEmpty == true;
  }

  Widget _buildSku() {
    return Text(
      'SKU: ${product.sku}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontSize: 8.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ============================================================
  // PRICE
  // ============================================================

  Widget _buildPriceRow() {
    final double currentPrice =
        product.price ?? product.salePrice ?? product.regularPrice ?? 0;

    final double? oldPrice = product.priceOld ?? product.regularPrice;

    final String currencySymbol =
        product.currencySymbol?.trim().isNotEmpty == true
        ? product.currencySymbol!.trim()
        : product.currency?.trim().isNotEmpty == true
        ? product.currency!.trim()
        : 'AED';

    final bool hasOldPrice = oldPrice != null && oldPrice > currentPrice;

    return Row(
      children: [
        Flexible(
          child: Text(
            '$currencySymbol ${currentPrice.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        if (hasOldPrice) ...[
          const SizedBox(width: 6),

          Flexible(
            child: Text(
              '$currencySymbol ${oldPrice.toStringAsFixed(2)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 8.5,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // BOTTOM ROW
  // ============================================================

  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(child: _buildStockInfo()),

        const SizedBox(width: 6),

        _buildStatusBadge(),
      ],
    );
  }

  // ============================================================
  // STOCK
  // ============================================================

  Widget _buildStockInfo() {
    final int stockQuantity = product.stockQuantity ?? 0;

    final String stockStatus = product.stockStatus?.toLowerCase().trim() ?? '';

    final bool outOfStock =
        stockQuantity <= 0 ||
        stockStatus == 'out_of_stock' ||
        stockStatus == 'out of stock';

    final bool lowStock = !outOfStock && stockQuantity <= 10;

    final Color stockColor;

    if (outOfStock) {
      stockColor = AppColors.errorDark;
    } else if (lowStock) {
      stockColor = AppColors.warning;
    } else {
      stockColor = AppColors.success;
    }

    String stockText;

    if (outOfStock) {
      stockText = 'Out of stock';
    } else {
      stockText = 'Stock: $stockQuantity';

      if (lowStock) {
        stockText += ' • Low';
      }
    }

    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: stockColor, shape: BoxShape.circle),
        ),

        const SizedBox(width: 5),

        Flexible(
          child: Text(
            stockText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: stockColor,
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge() {
    final bool active = product.isActive;

    final Color backgroundColor;
    final Color textColor;
    final String label;

    if (active) {
      backgroundColor = AppColors.success.withValues(alpha: 0.10);
      textColor = AppColors.success;
      label = 'Active';
    } else {
      backgroundColor = AppColors.errorDark.withValues(alpha: 0.09);
      textColor = AppColors.errorDark;
      label = 'Inactive';
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 50),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ============================================================
  // ACTION MENU
  // ============================================================

  Widget _buildActionMenu() {
    return PopupMenuButton<_ProductAction>(
      tooltip: 'Product actions',
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      onSelected: (action) {
        switch (action) {
          case _ProductAction.edit:
            onEdit?.call();
            break;

          case _ProductAction.stock:
            onStockEdit?.call();
            break;

          case _ProductAction.delete:
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<_ProductAction>(
            value: _ProductAction.edit,
            child: _ProductMenuItem(
              icon: Icons.edit_outlined,
              label: 'Edit Product',
            ),
          ),
          const PopupMenuItem<_ProductAction>(
            value: _ProductAction.stock,
            child: _ProductMenuItem(
              icon: Icons.inventory_2_outlined,
              label: 'Update Stock',
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<_ProductAction>(
            value: _ProductAction.delete,
            child: _ProductMenuItem(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Product',
              isDestructive: true,
            ),
          ),
        ];
      },
    );
  }
}

// ============================================================
// PRODUCT MENU ITEM
// ============================================================

class _ProductMenuItem extends StatelessWidget {
  const _ProductMenuItem({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDestructive ? AppColors.errorDark : AppColors.textSecondary,
        ),

        const SizedBox(width: 10),

        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDestructive ? AppColors.errorDark : AppColors.navy,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ACTION ENUM
// ============================================================

enum _ProductAction { edit, stock, delete }
