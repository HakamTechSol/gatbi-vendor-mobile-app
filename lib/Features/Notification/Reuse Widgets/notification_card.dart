import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Get Notifications/Models/notification_item_model.dart';
import 'notification_icon.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDelete,
    this.isMarkingAsRead = false,
    this.isDeleting = false,
  });

  final NotificationItemModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isMarkingAsRead;
  final bool isDeleting;

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    final isBusy = isMarkingAsRead || isDeleting;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: isBusy ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnread ? AppColors.primarySurface : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isUnread ? AppColors.borderPrimary : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnread
                    ? AppColors.primaryShadow.withValues(alpha: 0.2)
                    : AppColors.shadow,
                blurRadius: isUnread ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // Icon
              // --------------------------------------------------
              NotificationIcon(
                type: notification.type,
                isRead: notification.isRead,
              ),

              const SizedBox(width: 12),

              // --------------------------------------------------
              // Content
              // --------------------------------------------------
              Expanded(child: _buildContent(isUnread)),

              const SizedBox(width: 8),

              // --------------------------------------------------
              // Actions
              // --------------------------------------------------
              _buildActions(isUnread: isUnread, isBusy: isBusy),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================

  Widget _buildContent(bool isUnread) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------
        // Title
        // --------------------------------------------------------
        Text(
          _displayTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
          ),
        ),

        const SizedBox(height: 5),

        // --------------------------------------------------------
        // Message
        // --------------------------------------------------------
        Text(
          _displayMessage,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),

        const SizedBox(height: 9),

        // --------------------------------------------------------
        // Meta
        // --------------------------------------------------------
        Row(
          children: [
            Flexible(child: _buildTypeLabel()),

            const SizedBox(width: 7),

            Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: AppColors.textMuted,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 7),

            Flexible(
              child: Text(
                _formatDateTime(notification.createdAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

  // ============================================================
  // Actions
  // ============================================================

  Widget _buildActions({required bool isUnread, required bool isBusy}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // --------------------------------------------------------
        // Delete Button / Loading
        // --------------------------------------------------------
        _buildDeleteButton(),

        const SizedBox(height: 10),

        // --------------------------------------------------------
        // Read / Unread Status
        // --------------------------------------------------------
        _buildStatus(isUnread, isBusy: isBusy),
      ],
    );
  }

  // ============================================================
  // Delete Button
  // ============================================================

  Widget _buildDeleteButton() {
    if (isDeleting) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.errorBorder),
        ),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.error,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onDelete,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.errorBorder),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.delete_outline_rounded,
            size: 14,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Type
  // ============================================================

  Widget _buildTypeLabel() {
    final type = notification.type?.trim();

    if (type == null || type.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      _formatType(type),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.captionMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ============================================================
  // Status
  // ============================================================

  Widget _buildStatus(bool isUnread, {required bool isBusy}) {
    if (isMarkingAsRead) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      );
    }

    if (!isUnread) {
      return const SizedBox(width: 8, height: 8);
    }

    return Container(
      width: 9,
      height: 9,
      margin: const EdgeInsets.only(top: 3),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  // ============================================================
  // Display Title
  // ============================================================

  String get _displayTitle {
    final title = notification.title?.trim();

    if (title == null || title.isEmpty) {
      return 'Notification';
    }

    return title;
  }

  // ============================================================
  // Display Message
  // ============================================================

  String get _displayMessage {
    final message = notification.message?.trim();

    if (message == null || message.isEmpty) {
      return 'You have a new notification.';
    }

    return message;
  }

  // ============================================================
  // Format Type
  // ============================================================

  String _formatType(String value) {
    return value
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}'
              '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // ============================================================
  // Format Date Time
  // ============================================================

  String _formatDateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Recently';
    }

    final rawValue = value.trim();

    DateTime? dateTime = DateTime.tryParse(rawValue.replaceFirst(' ', 'T'));

    dateTime ??= DateTime.tryParse(rawValue);

    if (dateTime == null) {
      return rawValue;
    }

    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      return _formatDate(dateTime);
    }

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;

      return '$minutes '
          '${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;

      return '$hours '
          '${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;

      return '$days '
          '${days == 1 ? 'day' : 'days'} ago';
    }

    return _formatDate(dateTime);
  }

  // ============================================================
  // Format Date
  // ============================================================

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    return '$day/$month/$year';
  }
}
