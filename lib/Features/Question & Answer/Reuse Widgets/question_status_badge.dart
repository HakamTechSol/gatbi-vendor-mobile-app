import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class QuestionStatusBadge extends StatelessWidget {
  const QuestionStatusBadge({super.key, required this.isAnswered});

  final bool? isAnswered;

  @override
  Widget build(BuildContext context) {
    final answered = isAnswered == true;

    final backgroundColor = answered
        ? AppColors.success.withValues(alpha: 0.10)
        : AppColors.warning.withValues(alpha: 0.10);

    final foregroundColor = answered ? AppColors.success : AppColors.warning;

    final icon = answered
        ? Icons.check_circle_outline_rounded
        : Icons.schedule_rounded;

    final label = answered ? 'Answered' : 'Pending Answer';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
