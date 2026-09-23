import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/product_detail_item_model.dart';

class ProductArabicCard extends StatelessWidget {
  const ProductArabicCard({super.key, required this.product});

  final ProductDetailItemModel product;

  @override
  Widget build(BuildContext context) {
    final productName = product.name?.trim() ?? '';
    final shortDescription = product.shortDescription?.trim() ?? '';
    final description = product.description?.trim() ?? '';

    final hasName = productName.isNotEmpty;
    final hasShort = shortDescription.isNotEmpty;
    final hasFull = description.isNotEmpty;

    if (!hasName && !hasShort && !hasFull) {
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

          if (hasName) ...[
            _buildFieldLabel('Product Name'),

            const SizedBox(height: 7),

            _buildArabicText(
              productName,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ],

          if (hasShort) ...[
            if (hasName) ...[
              const SizedBox(height: 17),
              _buildDivider(),
              const SizedBox(height: 16),
            ],

            _buildFieldLabel('Short Description'),

            const SizedBox(height: 7),

            _buildArabicText(shortDescription),
          ],

          if (hasFull) ...[
            if (hasName || hasShort) ...[
              const SizedBox(height: 17),
              _buildDivider(),
              const SizedBox(height: 16),
            ],

            _buildFieldLabel('Full Description'),

            const SizedBox(height: 7),

            _buildArabicText(description, height: 1.8),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // Header
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
            Icons.translate_rounded,
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
                'Product Information',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Product information from API',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.07),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            'العربية',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Field Label
  // ============================================================

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
        fontSize: 10.5,
      ),
    );
  }

  // ============================================================
  // Text
  // ============================================================

  Widget _buildArabicText(
    String text, {
    double fontSize = 12.5,
    FontWeight fontWeight = FontWeight.w500,
    double height = 1.6,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border.withOpacity(.55)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: height,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Divider
  // ============================================================

  Widget _buildDivider() {
    return Divider(height: 1, color: AppColors.border.withOpacity(.65));
  }
}
