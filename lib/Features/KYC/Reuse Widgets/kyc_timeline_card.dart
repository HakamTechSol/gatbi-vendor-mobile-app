import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class KycTimelineStep {
  const KycTimelineStep({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isActive = false,
  });

  final String title;
  final String description;
  final bool isCompleted;
  final bool isActive;
}

class KycTimelineCard extends StatelessWidget {
  const KycTimelineCard({
    super.key,
    this.title = 'Verification Timeline',
    this.steps = const [
      KycTimelineStep(
        title: 'Submit Documents',
        description:
            'Provide complete business details and upload required legal documents.',
        isActive: true,
      ),
      KycTimelineStep(
        title: 'Compliance Review',
        description: 'Our team reviews submissions within 1–2 business days.',
      ),
      KycTimelineStep(
        title: 'Approval / Feedback',
        description:
            'If additional documents are needed, you’ll be notified via email.',
      ),
    ],
  });

  final String title;
  final List<KycTimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Text(title, style: AppTextStyles.titleMedium),
          ),

          const Divider(height: 1, color: AppColors.divider),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Column(
              children: [
                for (int index = 0; index < steps.length; index++)
                  _TimelineItem(
                    step: steps[index],
                    isLast: index == steps.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.step, required this.isLast});

  final KycTimelineStep step;
  final bool isLast;

  Color get _lineColor {
    if (step.isCompleted) {
      return AppColors.successBorder;
    }

    return AppColors.divider;
  }

  Color get _titleColor {
    if (step.isActive || step.isCompleted) {
      return AppColors.textPrimary;
    }

    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                _buildStepIndicator(),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: _lineColor,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: _titleColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(step.description, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    if (step.isCompleted) {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: AppColors.white,
        ),
      );
    }

    if (step.isActive) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.circle, size: 8, color: AppColors.primary),
        ),
      );
    }

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderStrong, width: 1),
      ),
      child: const Center(
        child: Icon(Icons.circle, size: 6, color: AppColors.textMuted),
      ),
    );
  }
}
