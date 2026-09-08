// lib/features/chat/presentation/widgets/chat_message_bubble.dart
import 'package:flutter/material.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final bool isVendor;
  final String senderName;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isVendor,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isVendor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isVendor) _buildAvatar(),
          if (!isVendor) const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: isVendor
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isVendor) ...[
                  Text(
                    senderName,
                    style: AppTextStyles.captionMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isVendor ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isVendor ? 16 : 4),
                      topRight: Radius.circular(isVendor ? 4 : 16),
                      bottomLeft: const Radius.circular(16),
                      bottomRight: const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: AppTextStyles.chatMessage.copyWith(
                          color: isVendor
                              ? AppColors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timestamp,
                        style: AppTextStyles.chatMessageTime.copyWith(
                          color: isVendor
                              ? AppColors.white.withOpacity(0.7)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isVendor) const SizedBox(width: 10),
          if (isVendor) _buildAvatar(isVendor: true),
        ],
      ),
    );
  }

  Widget _buildAvatar({bool isVendor = false}) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: isVendor ? AppColors.primary : AppColors.primaryLight,
      child: Icon(
        isVendor ? Icons.storefront_rounded : Icons.person_rounded,
        size: 18,
        color: isVendor ? AppColors.white : AppColors.primary,
      ),
    );
  }
}
