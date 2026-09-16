import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/order_model.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});

  final VendorOrderModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 14),

              _buildCustomer(),

              const SizedBox(height: 14),

              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              const SizedBox(height: 14),

              _buildProductPreview(),

              const SizedBox(height: 14),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.orderNumber ?? 'Order #${order.id ?? 'N/A'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.orderNumber,
              ),

              const SizedBox(height: 4),

              Text(
                _formatDate(order.createdAt),
                style: AppTextStyles.orderMeta,
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        OrderStatusBadge(status: order.status),
      ],
    );
  }

  // ============================================================
  // CUSTOMER
  // ============================================================

  Widget _buildCustomer() {
    final customerName = order.customer?.name?.trim().isNotEmpty == true
        ? order.customer!.name!
        : 'Unknown customer';

    final customerEmail = order.customer?.email?.trim().isNotEmpty == true
        ? order.customer!.email!
        : null;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),

              if (customerEmail != null) ...[
                const SizedBox(height: 2),
                Text(
                  customerEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.orderMeta,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT
  // ============================================================

  Widget _buildProductPreview() {
    final productName = order.productName?.trim().isNotEmpty == true
        ? order.productName!
        : 'Product';

    return Row(
      children: [
        _buildProductImage(),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.productName,
              ),

              const SizedBox(height: 4),

              Text(
                _buildProductMeta(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.productSku,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _buildProductImage() {
    final imageUrl = order.productImage?.trim();

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.inputIconBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null || imageUrl.isEmpty
          ? const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.iconSecondary,
              size: 22,
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.iconSecondary,
                  size: 22,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ============================================================
  // PRODUCT META
  // ============================================================

  String _buildProductMeta() {
    final quantity = order.vendorQuantity ?? 0;

    return 'Qty: $quantity';
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    final total = order.vendorTotal ?? 0;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vendor Total', style: AppTextStyles.orderMeta),

            const SizedBox(height: 3),

            Text(_formatAmount(total), style: AppTextStyles.orderAmount),
          ],
        ),

        const Spacer(),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${order.vendorQuantity ?? 0} '
              '${(order.vendorQuantity ?? 0) == 1 ? 'item' : 'items'}',
              style: AppTextStyles.orderMeta,
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // AMOUNT
  // ============================================================

  String _formatAmount(num value) {
    return 'AED ${value.toStringAsFixed(2)}';
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date unavailable';
    }

    try {
      final date = DateTime.parse(value.replaceFirst(' ', 'T'));

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final hour = date.hour > 12
          ? date.hour - 12
          : date.hour == 0
          ? 12
          : date.hour;

      final minute = date.minute.toString().padLeft(2, '0');

      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '${months[date.month - 1]} '
          '${date.day}, '
          '${date.year} • '
          '$hour:$minute $period';
    } catch (_) {
      return value;
    }
  }
}
