import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class EventKycNotice extends StatelessWidget {
  const EventKycNotice({
    super.key,
    required this.kycStatus,
    required this.kycLocked,
  });

  final String? kycStatus;
  final bool kycLocked;

  @override
  Widget build(BuildContext context) {
    if (!kycLocked) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 20,
            color: AppColors.warningDark,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events are locked',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.warningDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Complete your KYC verification to participate '
                  'in vendor events.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
