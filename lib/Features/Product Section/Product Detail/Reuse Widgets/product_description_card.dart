import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';

class ProductDescriptionCard extends StatelessWidget {
  const ProductDescriptionCard({super.key, required this.product});

  final ProductDetailItemModel product;

  @override
  Widget build(BuildContext context) {
    final shortDescription = product.shortDescription?.trim() ?? '';

    final description = product.description?.trim() ?? '';

    final hasShortDescription = shortDescription.isNotEmpty;

    final hasDescription = description.isNotEmpty;

    if (!hasShortDescription && !hasDescription) {
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

          // ======================================================
          // SHORT DESCRIPTION
          // ======================================================
          if (hasShortDescription) ...[
            _buildSectionTitle('Short Description'),

            const SizedBox(height: 7),

            _buildDescriptionText(shortDescription),
          ],

          // ======================================================
          // DIVIDER
          // ======================================================
          if (hasShortDescription && hasDescription)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Divider(
                height: 1,
                color: AppColors.border.withOpacity(.65),
              ),
            ),

          // ======================================================
          // FULL DESCRIPTION
          // ======================================================
          if (hasDescription) ...[
            _buildSectionTitle('Full Description'),

            const SizedBox(height: 8),

            _buildDescriptionText(description, isFullDescription: true),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

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

  // ============================================================
  // SECTION TITLE
  // ============================================================

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

  // ============================================================
  // DESCRIPTION TEXT
  // ============================================================

  Widget _buildDescriptionText(String text, {bool isFullDescription = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border.withOpacity(.55)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isFullDescription
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          height: isFullDescription ? 1.65 : 1.55,
          fontSize: 12.5,
        ),
      ),
    );
  }
}
