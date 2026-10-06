import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class NotificationSettingInfoCard extends StatelessWidget {
  const NotificationSettingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.info_outline_rounded,
              size: 19,
              color: AppColors.info,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              'You can update your notification preferences anytime. '
              'Important account and security notifications may still be sent when required.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.infoDark,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
