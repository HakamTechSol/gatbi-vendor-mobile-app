import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChatProductCard extends StatelessWidget {
  const ChatProductCard({
    super.key,
    required this.product,
  });

  final Map<String, dynamic> product;

  // ============================================================
  // SAFE GETTERS
  // ============================================================

  double? _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  String _stringValue(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final productName = _stringValue(product['name']);

    final description = _stringValue(
      product['short_description'] ??
          product['description'] ??
          product['shortDescription'],
    );

    final merchantName = _stringValue(product['merchant_name']);

    final currency = _stringValue(product['currency']).isNotEmpty
        ? _stringValue(product['currency'])
        : 'AED';

    final heroImageUrl = _stringValue(product['hero_image_url']);

    final price = _parseDouble(product['price']);

    final oldPrice = _parseDouble(product['old_price']);

    return Container(
      // ----------------------------------------------------------
      // IMPORTANT:
      // Product should behave like a chat bubble.
      // It should NOT occupy the complete screen width.
      // ----------------------------------------------------------
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),

      margin: const EdgeInsets.only(
        top: 3,
        bottom: 8,
      ),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: AppColors.border.withOpacity(0.75),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ======================================================
          // PRODUCT IMAGE
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 145,
            child: heroImageUrl.isEmpty
                ? _buildImagePlaceholder()
                : Image.network(
                    heroImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _buildImagePlaceholder();
                    },
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return _buildImagePlaceholder(
                        showLoader: true,
                      );
                    },
                  ),
          ),

          // ======================================================
          // PRODUCT CONTENT
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              10,
              12,
              11,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // MERCHANT
                // ==================================================

                if (merchantName.isNotEmpty) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.storefront_rounded,
                        size: 13,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          merchantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                ],

                // ==================================================
                // PRODUCT NAME
                // ==================================================

                Text(
                  productName.isNotEmpty ? productName : 'Product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),

                // ==================================================
                // DESCRIPTION
                // ==================================================

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      height: 1.3,
                    ),
                  ),
                ],

                const SizedBox(height: 9),

                // ==================================================
                // PRICE
                // ==================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (price != null)
                      Text(
                        '${price.toStringAsFixed(2)} $currency',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                    if (oldPrice != null &&
                        price != null &&
                        oldPrice > price) ...[
                      const SizedBox(width: 7),
                      Text(
                        '${oldPrice.toStringAsFixed(2)} $currency',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _buildImagePlaceholder({
    bool showLoader = false,
  }) {
    return Container(
      color: AppColors.surfaceMuted,
      alignment: Alignment.center,
      child: showLoader
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(
              Icons.image_outlined,
              size: 32,
              color: AppColors.textMuted,
            ),
    );
  }
}