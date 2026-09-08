import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';

class ProductDescriptionCard extends StatelessWidget {
  const ProductDescriptionCard({super.key, required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final hasShortDescription =
        product.shortDescription!.trim().isNotEmpty;

    final hasFullDescription =
        product.fullDescription!.trim().isNotEmpty;

    if (!hasShortDescription && !hasFullDescription) {
      return const SizedBox.shrink();
    }

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

          const SizedBox(height: 17),

          if (hasShortDescription) ...[
            _buildSectionTitle('Short Description'),

            const SizedBox(height: 7),

            Text(
              product.shortDescription!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
                fontSize: 12.5,
              ),
            ),
          ],

          if (hasShortDescription && hasFullDescription)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Divider(
                height: 1,
                color: AppColors.border.withOpacity(.65),
              ),
            ),

          if (hasFullDescription) ...[
            _buildSectionTitle('Full Description'),

            const SizedBox(height: 8),

            Text(
              product.fullDescription!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.65,
                fontSize: 12.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.description_outlined,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Product details & description',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.navy,
        fontWeight: FontWeight.w800,
        fontSize: 11.5,
      ),
    );
  }
}
