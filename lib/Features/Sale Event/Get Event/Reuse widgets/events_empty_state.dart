import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class EventsEmptyState extends StatelessWidget {
  const EventsEmptyState({
    super.key,
    this.title = 'No Events Available',
    this.description =
        'There are no events matching your selected filter right now.',
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 30),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: AppColors.softGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateTitle,
          ),

          const SizedBox(height: 7),

          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateDescription,
          ),
        ],
      ),
    );
  }
}
