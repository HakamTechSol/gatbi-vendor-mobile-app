import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketReplyInput extends StatelessWidget {
  const TicketReplyInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSend,
    this.onEmojiTap,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSend;
  final VoidCallback? onEmojiTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ═══════════════════════════════════════════════════
          // EMOJI BUTTON
          // ═══════════════════════════════════════════════════

          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              onTap: enabled && onEmojiTap != null
                  ? onEmojiTap
                  : null,
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  size: 21,
                  color: enabled
                      ? AppColors.primary
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // ═══════════════════════════════════════════════════
          // TEXT FIELD
          // ═══════════════════════════════════════════════════

          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Type your message here',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 9,
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // ═══════════════════════════════════════════════════
          // SEND BUTTON
          // ═══════════════════════════════════════════════════

          Material(
            color: enabled
                ? AppColors.primary
                : AppColors.disabled,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: enabled && onSend != null
                  ? onSend
                  : null,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  Icons.send_rounded,
                  size: 18,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}