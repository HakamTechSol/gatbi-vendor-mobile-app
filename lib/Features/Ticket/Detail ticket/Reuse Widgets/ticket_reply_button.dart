
import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketReplyButton extends StatelessWidget {
  const TicketReplyButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !isLoading && onPressed != null;

    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: isLoading
            ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.send_rounded,
                size: 18,
              ),
        label: Text(
          isLoading ? 'Sending...' : 'Send Reply',
          style: AppTextStyles.buttonMedium.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              AppColors.disabled,
          disabledForegroundColor:
              AppColors.textTertiary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
