import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';

class ProductStatusBadges extends StatelessWidget {
  const ProductStatusBadges({super.key, required this.product});

  final ProductDetailModel product;

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

  List<Widget> _buildBadges() {
    final List<Widget> badges = [];

    // Status
    badges.add(
      _StatusBadge(
        label: product.status,
        icon: product.isInStock
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded,
        foregroundColor: product.isInStock
            ? AppColors.success
            : AppColors.error,
        backgroundColor: product.isInStock
            ? AppColors.success.withOpacity(.10)
            : AppColors.error.withOpacity(.10),
      ),
    );

    // Low stock
    if (product.isLowStock) {
      badges.add(
        const _StatusBadge(
          label: 'Low Stock',
          icon: Icons.warning_amber_rounded,
          foregroundColor: AppColors.warning,
          backgroundColor: Color(0xFFFFF7E6),
        ),
      );
    }

    // Featured
    if (product.isFeatured) {
      badges.add(
        const _StatusBadge(
          label: 'Featured',
          icon: Icons.star_rounded,
          foregroundColor: AppColors.warning,
          backgroundColor: Color(0xFFFFF7E6),
        ),
      );
    }

    // Trending
    if (product.isTrending) {
      badges.add(
        const _StatusBadge(
          label: 'Trending',
          icon: Icons.trending_up_rounded,
          foregroundColor: AppColors.primary,
          backgroundColor: Color(0xFFEEF2FF),
        ),
      );
    }

    // Flash Deal
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

    return badges;
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
