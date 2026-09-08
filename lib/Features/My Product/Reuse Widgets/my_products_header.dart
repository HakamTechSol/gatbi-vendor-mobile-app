import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class MyProductsHeader extends StatelessWidget {
  const MyProductsHeader({super.key, this.onAddProduct});

  final VoidCallback? onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Products',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 21,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Manage your store catalogue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 112,
          child: CustomButton(
            text: 'Add Product',
            icon: Icons.add_rounded,
            onPressed: onAddProduct,
            type: CustomButtonType.primary,
            height: 40,
            borderRadius: 11,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            textStyle: AppTextStyles.buttonOutlined.copyWith(
              color: AppColors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
