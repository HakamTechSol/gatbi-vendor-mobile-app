import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class KycHelpCard extends StatelessWidget {
  const KycHelpCard({
    super.key,
    this.title = 'Need Help?',
    this.description = 'Have questions about the required documents?',
    this.email = 'support@gatbi.ae',
    this.supportHours = 'Sun – Thu · 9am to 6pm UAE',
    this.supportNote =
        'Please reference your Store ID when contacting support.',
    this.buttonText = 'Contact Support',
    this.onContactSupport,
  });

  final String title;
  final String description;
  final String email;
  final String supportHours;
  final String supportNote;
  final String buttonText;
  final VoidCallback? onContactSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  size: 21,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(child: Text(title, style: AppTextStyles.titleMedium)),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          _HelpInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
          ),

          const SizedBox(height: 12),

          _HelpInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Support Hours',
            value: supportHours,
          ),

          const SizedBox(height: 12),

          _HelpInfoRow(
            icon: Icons.info_outline_rounded,
            label: 'Support',
            value: supportNote,
          ),

          const SizedBox(height: 16),

          CustomButton(
            text: buttonText,
            type: CustomButtonType.outlined,
            height: 46,
            width: 170,
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: onContactSupport,
          ),
        ],
      ),
    );
  }
}

class _HelpInfoRow extends StatelessWidget {
  const _HelpInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: AppColors.iconSecondary),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.captionMedium),

              const SizedBox(height: 2),

              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
