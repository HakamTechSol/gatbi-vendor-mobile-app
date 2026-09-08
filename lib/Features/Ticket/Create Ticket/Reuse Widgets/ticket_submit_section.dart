import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketSubmitSection extends StatelessWidget {
  const TicketSubmitSection({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.enabled = true,
    this.buttonText = 'Submit Ticket',
  });

  final VoidCallback? onSubmit;
  final bool isLoading;
  final bool enabled;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: isLoading ? 'Submitting...' : buttonText,
            onPressed: enabled && !isLoading ? onSubmit : null,
            isLoading: isLoading,
            icon: Icons.send_rounded,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 14,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                'Your ticket will be securely submitted to our support team.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
