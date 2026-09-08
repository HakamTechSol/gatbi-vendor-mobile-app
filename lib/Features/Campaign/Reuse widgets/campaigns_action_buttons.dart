import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';

class CampaignsActionButtons extends StatelessWidget {
  const CampaignsActionButtons({
    super.key,
    this.onPickProducts,
    this.onRequestCampaign,
  });

  final VoidCallback? onPickProducts;
  final VoidCallback? onRequestCampaign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Pick Products',
          icon: Icons.shopping_bag_outlined,
          iconPosition: CustomButtonIconPosition.leading,
          onPressed: onPickProducts,
          height: 50,
          borderRadius: 12,
          elevation: 2,
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'Request Campaign',
          type: CustomButtonType.outlined,
          icon: Icons.campaign_outlined,
          iconPosition: CustomButtonIconPosition.leading,
          onPressed: onRequestCampaign,
          height: 50,
          borderRadius: 12,
          textStyle: AppTextStyles.buttonOutlined,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primary,
        ),
      ],
    );
  }
}