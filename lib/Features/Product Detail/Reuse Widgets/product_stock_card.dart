import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';
import 'product_detail_row.dart';

class ProductStockCard extends StatelessWidget {
  const ProductStockCard({super.key, required this.product});

  final ProductDetailModel product;

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
          _buildHeader(),

          const SizedBox(height: 16),

          _buildStockOverview(),

          const SizedBox(height: 15),

          _buildProgress(),

          const SizedBox(height: 10),

          _buildStockMessage(),

          const SizedBox(height: 8),

          ProductDetailRow(
            label: 'Inventory tracking',
            value: _formatInventoryType(product.inventoryType),
            icon: Icons.track_changes_rounded,
          ),

          ProductDetailRow(
            label: 'SKU',
            value: product.sku?.isNotEmpty == true ? product.sku! : '—',
            icon: Icons.qr_code_2_rounded,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: AppColors.success,
            size: 21,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Stock availability & inventory status',
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
  // STOCK OVERVIEW
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStockOverview() {
    final status = _stockStatus();

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.border.withOpacity(.65)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: status.color.withOpacity(.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(status.icon, color: status.color, size: 21),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Stock',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${product.stock}',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: status.color.withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: status.color.withOpacity(.15)),
          ),
          child: Text(
            status.label,
            style: AppTextStyles.caption.copyWith(
              color: status.color,
              fontWeight: FontWeight.w800,
              fontSize: 10.5,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROGRESS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProgress() {
    final progress = _stockProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Stock level',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(_stockStatus().color),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STOCK MESSAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStockMessage() {
    final status = _stockStatus();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: status.color.withOpacity(.06),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              status.message,
              style: AppTextStyles.caption.copyWith(
                color: status.color,
                fontWeight: FontWeight.w600,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  double _stockProgress() {
    if (product.stock <= 0) {
      return 0;
    }

    // UI-only baseline.
    // Later this can easily be replaced by API max-stock data.
    const maxStock = 100;

    return (product.stock / maxStock).clamp(0.0, 1.0);
  }

  _StockStatus _stockStatus() {
    if (product.stock <= 0) {
      return const _StockStatus(
        label: 'Out of Stock',
        message: 'This product is currently unavailable.',
        color: AppColors.error,
        icon: Icons.cancel_rounded,
      );
    }

    if (product.stock <= 10) {
      return const _StockStatus(
        label: 'Low Stock',
        message: 'Stock is running low. Consider restocking soon.',
        color: AppColors.warning,
        icon: Icons.warning_amber_rounded,
      );
    }

    return const _StockStatus(
      label: 'In Stock',
      message: 'Product has sufficient inventory available.',
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
    );
  }

  String _formatInventoryType(String? type) {
    if (type == null || type.trim().isEmpty) {
      return 'Not specified';
    }

    switch (type.toLowerCase()) {
      case 'track':
        return 'Track inventory';

      case 'dont_track':
      case 'do_not_track':
        return 'Do not track';

      default:
        return type;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STOCK STATUS
// ═════════════════════════════════════════════════════════════════════════════

class _StockStatus {
  const _StockStatus({
    required this.label,
    required this.message,
    required this.color,
    required this.icon,
  });

  final String label;
  final String message;
  final Color color;
  final IconData icon;
}
