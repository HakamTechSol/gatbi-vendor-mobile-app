// lib/features/chat/presentation/widgets/chat_list_item.dart
import 'package:flutter/material.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChatListItem extends StatelessWidget {
  final String customerName;
  final String customerEmail;
  final String? customerAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final String productName;
  final int unreadCount;
  final bool isOnline;
  final String status;
  final VoidCallback onTap;
  final bool isHighlighted;
  final String searchQuery;

  const ChatListItem({
    super.key,
    required this.customerName,
    required this.customerEmail,
    this.customerAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.productName,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = 'read',
    required this.onTap,
    this.isHighlighted = false,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.primaryLight.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isHighlighted
                ? Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildHighlightedText(
                            customerName,
                            unreadCount > 0
                                ? AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )
                                : AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          ),
                        ),
                        if (isOnline) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      productName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHighlightedText(
                            lastMessage,
                            unreadCount > 0
                                ? AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  )
                                : AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          lastMessageTime,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: AppTextStyles.statusBadge.copyWith(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, TextStyle style) {
    if (!isHighlighted || searchQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final endIndex = startIndex + searchQuery.length;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: style.copyWith(
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (customerAvatar != null) {
      return CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage(customerAvatar!),
        backgroundColor: AppColors.primaryLight,
      );
    }

    final initials = customerName
        .split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join('');

    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        initials.isNotEmpty ? initials : '?',
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
