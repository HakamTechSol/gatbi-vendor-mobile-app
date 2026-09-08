import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/top_product_model.dart';
import 'top_product_item.dart';

class TopProductsSection extends StatelessWidget {
  const TopProductsSection({
    super.key,
    required this.products,
    this.title = 'Top Products',
    this.subtitle = 'Your best-performing products by revenue',
    this.maxItems = 5,
    this.onProductTap,
    this.onViewAllTap,
  });

  final List<TopProductModel> products;
  final String title;
  final String subtitle;
  final int maxItems;
  final ValueChanged<TopProductModel>? onProductTap;
  final VoidCallback? onViewAllTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleProducts = products.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleProducts.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (context, index) {
            final product = visibleProducts[index];

            return TopProductItem(
              product: product,
              rank: index + 1,
              onTap: onProductTap == null ? null : () => onProductTap!(product),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleLarge),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        if (onViewAllTap != null) ...[
          const SizedBox(width: 12),
          TextButton(
            onPressed: onViewAllTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View all',
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
