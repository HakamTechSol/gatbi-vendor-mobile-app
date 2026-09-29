import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class EventsErrorState extends StatelessWidget {
  const EventsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              size: 29,
              color: AppColors.errorDark,
            ),
          ),

          const SizedBox(height: 14),

          Text('Unable to load events', style: AppTextStyles.titleMedium),

          const SizedBox(height: 6),

          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: 16),

          CustomButton(
            text: 'Try Again',
            onPressed: onRetry,
            width: 130,
            height: 44,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }
}
