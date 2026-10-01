import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class NotificationsUnreadBanner extends StatelessWidget {
  const NotificationsUnreadBanner({
    super.key,
    required this.unreadCount,
    this.onMarkAllRead,
    this.isLoading = false,
  });

  final int unreadCount;
  final VoidCallback? onMarkAllRead;
  final bool isLoading;

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (unreadCount <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(),

          const SizedBox(width: 12),

          Expanded(child: _buildContent()),

          const SizedBox(width: 10),

          _buildAction(),
        ],
      ),
    );
  }

  // ============================================================
  // Icon
  // ============================================================

  Widget _buildIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.mark_email_unread_rounded,
        size: 21,
        color: AppColors.primary,
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================

  Widget _buildContent() {
    final notificationText = unreadCount == 1
        ? '1 unread notification'
        : '$unreadCount unread notifications';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notificationText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Mark all notifications as read',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ============================================================
  // Action
  // ============================================================

  Widget _buildAction() {
    final enabled = !isLoading && onMarkAllRead != null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onMarkAllRead : null,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: enabled ? AppColors.primary : AppColors.disabled,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Icon(
                  Icons.done_all_rounded,
                  size: 19,
                  color: AppColors.white,
                ),
        ),
      ),
    );
  }
}
