import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/ticket_detail_message_model.dart';


class TicketMessageBubble extends StatelessWidget {
  const TicketMessageBubble({super.key, required this.message});

  final TicketDetailMessageModel message;

  bool get _isVendor {
    return message.senderType?.toLowerCase().trim() == 'vendor';
  }

  bool get _isAdmin {
    return message.senderType?.toLowerCase().trim() == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    final isVendor = _isVendor;

    final messageText = message.message?.trim() ?? '';
    final senderName = message.senderName?.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isVendor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isVendor) ...[_buildAvatar(), const SizedBox(width: 8)],

          Flexible(
            child: Column(
              crossAxisAlignment: isVendor
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (senderName != null && senderName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          senderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),

                        if (_isAdmin) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Support',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                Container(
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
                  decoration: BoxDecoration(
                    color: isVendor ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isVendor ? 16 : 4),
                      bottomRight: Radius.circular(isVendor ? 4 : 16),
                    ),
                    border: isVendor
                        ? null
                        : Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.025),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isVendor
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageText.isEmpty ? 'No message' : messageText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isVendor
                              ? AppColors.white
                              : AppColors.textPrimary,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.createdAt),
                            style: AppTextStyles.caption.copyWith(
                              color: isVendor
                                  ? AppColors.white.withValues(alpha: 0.72)
                                  : AppColors.textTertiary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          if (isVendor) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.done_all_rounded,
                              size: 13,
                              color: AppColors.white.withValues(alpha: 0.75),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isVendor) ...[const SizedBox(width: 8), _buildAvatar()],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final isVendor = _isVendor;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isVendor ? AppColors.primaryLight : AppColors.surfaceMuted,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isVendor ? Icons.person_outline_rounded : Icons.support_agent_rounded,
        size: 17,
        color: isVendor ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  String _formatTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    final date = _parseDate(value);

    if (date == null) {
      return value;
    }

    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  DateTime? _parseDate(String value) {
    final normalized = value.trim().replaceFirst(' ', 'T');

    return DateTime.tryParse(normalized);
  }
}
