import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class MyProductsEmptyState extends StatelessWidget {
  const MyProductsEmptyState({super.key, this.onAddProduct});

  final VoidCallback? onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),

          const SizedBox(height: 18),

          Text(
            'No Products Yet',
            textAlign: TextAlign.center,
            style: AppTextStyles.authTitle.copyWith(
              color: AppColors.navy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              'Start by adding your first product and begin building your store catalogue.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 22),

          CustomButton(
            text: 'Add Product Now',
            icon: Icons.add_rounded,
            onPressed: onAddProduct,
            type: CustomButtonType.primary,
            height: 46,
            width: 190,
            borderRadius: 11,
            elevation: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.inventory_2_outlined,
          size: 31,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
