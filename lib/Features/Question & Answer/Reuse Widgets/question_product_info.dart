import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class QuestionProductInfo extends StatelessWidget {
  const QuestionProductInfo({
    super.key,
    required this.productName,
    this.productId,
    this.productImage,
  });

  final String? productName;
  final int? productId;
  final String? productImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProductImage(),
        const SizedBox(width: 12),
        Expanded(child: _buildProductDetails()),
      ],
    );
  }

  Widget _buildProductImage() {
    final hasImage = productImage != null && productImage!.trim().isNotEmpty;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: hasImage
            ? Image.network(
                productImage!,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _buildPlaceholder(showLoader: true);
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder({bool showLoader = false}) {
    if (showLoader) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return const Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: 23,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          productName?.trim().isNotEmpty == true
              ? productName!.trim()
              : 'Unknown Product',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (productId != null) ...[
          const SizedBox(height: 4),
          Text(
            'ID: #$productId',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
