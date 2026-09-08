import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/my_product_model.dart';

class MyProductCard extends StatelessWidget {
  const MyProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStockEdit,
  });

  final MyProductModel product;

  /// Opens complete product details.
  final VoidCallback? onTap;

  /// Edit product action.
  final VoidCallback? onEdit;

  /// Delete product action.
  final VoidCallback? onDelete;

  /// Quick stock update action.
  final VoidCallback? onStockEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 1),
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
              _buildProductImage(),

              const SizedBox(width: 12),

              Expanded(child: _buildProductInformation()),

              const SizedBox(width: 4),

              _buildActionMenu(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT IMAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 88,
        height: 98,
        color: AppColors.background,
        child: product.imageUrl.trim().isEmpty
            ? _buildImagePlaceholder()
            : Image.network(
                product.imageUrl,
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

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory(),

        const SizedBox(height: 4),

        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),

        if (product.sku != null && product.sku!.trim().isNotEmpty) ...[
          const SizedBox(height: 3),
          _buildSku(),
        ],

        const SizedBox(height: 8),

        _buildPriceRow(),

        const SizedBox(height: 8),

        _buildBottomRow(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        product.category,
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

  // ═══════════════════════════════════════════════════════════════════════════
  // SKU
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPriceRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            'AED ${product.price.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        if (product.originalPrice != null &&
            product.originalPrice! > product.price) ...[
          const SizedBox(width: 6),

          Flexible(
            child: Text(
              'AED ${product.originalPrice!.toStringAsFixed(2)}',
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

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM ROW
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(child: _buildStockInfo()),

        const SizedBox(width: 6),

        _buildStatusBadge(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STOCK
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStockInfo() {
    final bool outOfStock = product.isOutOfStock;
    final bool lowStock = !outOfStock && product.stockQuantity <= 10;

    Color stockColor;

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
      stockText = 'Stock: ${product.stockQuantity}';

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

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusBadge() {
    final String status = product.status.toLowerCase();

    final Color backgroundColor;
    final Color textColor;

    switch (status) {
      case 'active':
        backgroundColor = AppColors.success.withValues(alpha: 0.10);
        textColor = AppColors.success;
        break;

      case 'draft':
        backgroundColor = AppColors.warning.withValues(alpha: 0.12);
        textColor = AppColors.warning;
        break;

      case 'inactive':
        backgroundColor = AppColors.errorDark.withValues(alpha: 0.09);
        textColor = AppColors.errorDark;
        break;

      default:
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.10);
        textColor = AppColors.textSecondary;
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 50),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        _capitalize(status),
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

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION MENU
  // ═══════════════════════════════════════════════════════════════════════════

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

  String _capitalize(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1);
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PRODUCT MENU ITEM
// ═════════════════════════════════════════════════════════════════════════════

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

// ═════════════════════════════════════════════════════════════════════════════
// ACTION ENUM
// ═════════════════════════════════════════════════════════════════════════════

enum _ProductAction { edit, stock, delete }
