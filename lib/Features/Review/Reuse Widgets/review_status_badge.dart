import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewStatusBadge extends StatelessWidget {
  const ReviewStatusBadge({
    super.key,
    required this.isApproved,
  });

  final bool? isApproved;

  @override
  Widget build(BuildContext context) {
    final approved = isApproved == true;

    final backgroundColor = approved
        ? AppColors.successLight
        : AppColors.pendingLight;

    final foregroundColor = approved
        ? AppColors.successDark
        : AppColors.warningDark;

    final borderColor = approved
        ? AppColors.successBorder
        : AppColors.warningBorder;

    final icon = approved
        ? Icons.check_circle_outline_rounded
        : Icons.schedule_rounded;

    final label = approved ? 'Approved' : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: foregroundColor,
          ),

          const SizedBox(width: 5),

          Text(
            label,
            style: AppTextStyles.statusBadge.copyWith(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}