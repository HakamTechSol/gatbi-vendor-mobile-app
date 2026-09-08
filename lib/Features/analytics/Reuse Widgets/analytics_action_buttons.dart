import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';

class AnalyticsActionButtons extends StatelessWidget {
  const AnalyticsActionButtons({
    super.key,
    this.onOrdersTap,
    this.onProductsTap,
  });

  final VoidCallback? onOrdersTap;
  final VoidCallback? onProductsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Orders',
            icon: Icons.shopping_bag_outlined,
            iconPosition: CustomButtonIconPosition.leading,
            type: CustomButtonType.outlined,
            height: 48,
            borderRadius: 10,
            borderColor: AppColors.primary,
            textStyle: AppTextStyles.buttonOutlined,
            onPressed: onOrdersTap,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: CustomButton(
            text: 'Products',
            icon: Icons.inventory_2_outlined,
            iconPosition: CustomButtonIconPosition.leading,
            type: CustomButtonType.outlined,
            height: 48,
            borderRadius: 10,
            borderColor: AppColors.primary,
            textStyle: AppTextStyles.buttonOutlined,
            onPressed: onProductsTap,
          ),
        ),
      ],
    );
  }
}
