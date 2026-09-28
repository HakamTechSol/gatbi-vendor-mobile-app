import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewProductInfo extends StatelessWidget {
  const ReviewProductInfo({
    super.key,
    required this.productName,
    this.productImage,
    this.productId,
  });

  // ===========================================================================
  // Fields
  // ===========================================================================

  final String? productName;
  final String? productImage;
  final int? productId;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final name = productName?.trim().isNotEmpty == true
        ? productName!.trim()
        : 'Unknown Product';

    final image = productImage?.trim() ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ---------------------------------------------------------------------
        // Product Image
        // ---------------------------------------------------------------------
        _buildProductImage(image),

        const SizedBox(width: 12),

        // ---------------------------------------------------------------------
        // Product Details
        // ---------------------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRODUCT',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              if (productId != null) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Product #$productId',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Product Image
  // ===========================================================================

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isEmpty
          ? _buildImageFallback()
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _buildImageFallback();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return _buildImageLoading();
              },
            ),
    );
  }

  // ===========================================================================
  // Image Fallback
  // ===========================================================================

  Widget _buildImageFallback() {
    return const Center(
      child: Icon(Icons.image_outlined, size: 26, color: AppColors.textMuted),
    );
  }

  // ===========================================================================
  // Image Loading
  // ===========================================================================

  Widget _buildImageLoading() {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
