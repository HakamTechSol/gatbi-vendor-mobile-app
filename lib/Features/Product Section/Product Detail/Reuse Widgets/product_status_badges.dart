import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';

class ProductStatusBadges extends StatelessWidget {
  const ProductStatusBadges({super.key, required this.product});

  final ProductDetailItemModel product;

  @override
  Widget build(BuildContext context) {
    final badges = _buildBadges();

    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Wrap(spacing: 8, runSpacing: 8, children: badges),
    );
  }

  // ============================================================
  // BUILD BADGES
  // ============================================================

  List<Widget> _buildBadges() {
    final List<Widget> badges = [];

    // ------------------------------------------------------------
    // Stock Status
    // ------------------------------------------------------------

    final stockStatus = product.stockStatus?.trim() ?? '';

    if (stockStatus.isNotEmpty) {
      final isInStock = _isInStock;

      badges.add(
        _StatusBadge(
          label: _formatStockStatus(stockStatus),
          icon: isInStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
          foregroundColor: isInStock ? AppColors.success : AppColors.error,
          backgroundColor: isInStock
              ? AppColors.success.withOpacity(.10)
              : AppColors.error.withOpacity(.10),
        ),
      );
    }

    // ------------------------------------------------------------
    // Low Stock
    // ------------------------------------------------------------

    final stockQuantity = product.stockQuantity;

    if (stockQuantity != null && stockQuantity > 0 && stockQuantity <= 5) {
      badges.add(
        const _StatusBadge(
          label: 'Low Stock',
          icon: Icons.warning_amber_rounded,
          foregroundColor: AppColors.warning,
          backgroundColor: Color(0xFFFFF7E6),
        ),
      );
    }

    // ------------------------------------------------------------
    // Featured
    // ------------------------------------------------------------

    if (product.featured) {
      badges.add(
        const _StatusBadge(
          label: 'Featured',
          icon: Icons.star_rounded,
          foregroundColor: AppColors.warning,
          backgroundColor: Color(0xFFFFF7E6),
        ),
      );
    }

    // ------------------------------------------------------------
    // On Sale
    // ------------------------------------------------------------

    if (product.onSale) {
      badges.add(
        const _StatusBadge(
          label: 'On Sale',
          icon: Icons.local_offer_rounded,
          foregroundColor: AppColors.success,
          backgroundColor: Color(0xFFEFFBF3),
        ),
      );
    }

    // ------------------------------------------------------------
    // Flash Deal
    // ------------------------------------------------------------

    if (product.isFlashDeal) {
      badges.add(
        const _StatusBadge(
          label: 'Flash Deal',
          icon: Icons.bolt_rounded,
          foregroundColor: AppColors.error,
          backgroundColor: Color(0xFFFFEEEE),
        ),
      );
    }

    // ------------------------------------------------------------
    // Active / Inactive
    // ------------------------------------------------------------

    badges.add(
      _StatusBadge(
        label: product.isActive ? 'Active' : 'Inactive',
        icon: product.isActive
            ? Icons.visibility_rounded
            : Icons.visibility_off_rounded,
        foregroundColor: product.isActive
            ? AppColors.success
            : AppColors.textSecondary,
        backgroundColor: product.isActive
            ? AppColors.success.withOpacity(.10)
            : AppColors.border.withOpacity(.35),
      ),
    );

    return badges;
  }

  // ============================================================
  // STOCK STATUS
  // ============================================================

  bool get _isInStock {
    final status = product.stockStatus?.trim().toLowerCase() ?? '';

    if (status == 'in_stock' || status == 'in stock' || status == 'available') {
      return true;
    }

    if (status == 'out_of_stock' ||
        status == 'out of stock' ||
        status == 'unavailable') {
      return false;
    }

    // Fallback to quantity when status is unknown.
    final quantity = product.stockQuantity;

    if (quantity != null) {
      return quantity > 0;
    }

    return false;
  }

  // ============================================================
  // FORMAT STOCK STATUS
  // ============================================================

  String _formatStockStatus(String status) {
    final normalized = status.trim().toLowerCase();

    switch (normalized) {
      case 'in_stock':
        return 'In Stock';

      case 'out_of_stock':
        return 'Out of Stock';

      case 'on_backorder':
        return 'Backorder';

      case 'backorder':
        return 'Backorder';

      case 'in stock':
        return 'In Stock';

      case 'out of stock':
        return 'Out of Stock';

      default:
        if (status.isEmpty) {
          return 'Unknown';
        }

        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
            )
            .join(' ');
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SINGLE BADGE
// ═════════════════════════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: foregroundColor.withOpacity(.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
