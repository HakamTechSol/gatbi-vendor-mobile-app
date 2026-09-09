import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_detail_item_model.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    super.key,
    required this.item,
  });

  final OrderDetailItemModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductImage(
          imageUrl: item.imageUrl,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.productName,
              ),

              if (item.variantName != null &&
                  item.variantName!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.variantName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.productSku,
                ),
              ],

              const SizedBox(height: 5),

              Text(
                _buildMeta(),
                style: AppTextStyles.productSku,
              ),

              const SizedBox(height: 7),

              Text(
                '${item.quantity} × ${item.price.toStringAsFixed(2)} ${_currency}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Text(
          '${item.calculatedTotal.toStringAsFixed(2)} ${_currency}',
          textAlign: TextAlign.end,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String get _currency => 'AED';

  String _buildMeta() {
    if (item.sku != null && item.sku!.isNotEmpty) {
      return 'SKU: ${item.sku}';
    }

    return 'Product item';
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const _PlaceholderIcon();
              },
            )
          : const _PlaceholderIcon(),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.image_outlined,
        size: 25,
        color: AppColors.iconMuted,
      ),
    );
  }
}