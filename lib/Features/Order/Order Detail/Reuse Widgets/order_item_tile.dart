import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_detail_item_model.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item, this.currency});

  final VendorOrderDetailItemModel item;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final currencyValue = currency?.trim().isNotEmpty == true
        ? currency!.trim()
        : 'AED';

    final quantity = item.quantity ?? 0;
    final price = item.price ?? 0;
    final total = item.total ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductImage(imageUrl: item.image),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? 'Product',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.productName,
              ),

              const SizedBox(height: 5),

              Text(
                'Product ID: ${item.productId ?? 'N/A'}',
                style: AppTextStyles.productSku,
              ),

              const SizedBox(height: 7),

              Text(
                '$quantity × ${_formatAmount(price)} $currencyValue',
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
          '${_formatAmount(total)} $currencyValue',
          textAlign: TextAlign.end,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatAmount(num value) {
    return value.toStringAsFixed(2);
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const _PlaceholderIcon();
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }

                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
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
      child: Icon(Icons.image_outlined, size: 25, color: AppColors.iconMuted),
    );
  }
}
