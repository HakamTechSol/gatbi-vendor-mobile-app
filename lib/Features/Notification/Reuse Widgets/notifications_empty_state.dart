import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({
    super.key,
    this.filter = 'all',
    this.onRefresh,
  });

  final String filter;
  final VoidCallback? onRefresh;

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyStateConfig();

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----------------------------------------------------
            // Icon
            // ----------------------------------------------------
            _buildIcon(config),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // Title
            // ----------------------------------------------------
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // ----------------------------------------------------
            // Description
            // ----------------------------------------------------
            Text(
              config.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            // ----------------------------------------------------
            // Refresh
            // ----------------------------------------------------
            if (onRefresh != null) ...[
              const SizedBox(height: 18),

              _buildRefreshButton(),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Icon
  // ============================================================

  Widget _buildIcon(_EmptyStateConfig config) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.09),
        shape: BoxShape.circle,
        border: Border.all(color: config.color.withValues(alpha: 0.12)),
      ),
      alignment: Alignment.center,
      child: Icon(config.icon, size: 32, color: config.color),
    );
  }

  // ============================================================
  // Refresh Button
  // ============================================================

  Widget _buildRefreshButton() {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onRefresh,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderPrimary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: AppColors.primary,
              ),

              const SizedBox(width: 7),

              Text(
                'Refresh',
                style: AppTextStyles.buttonOutlined.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Config
  // ============================================================

  _EmptyStateConfig _getEmptyStateConfig() {
    switch (filter.trim().toLowerCase()) {
      case 'unread':
        return const _EmptyStateConfig(
          icon: Icons.mark_email_read_rounded,
          color: AppColors.success,
          title: "You're all caught up",
          description: "You don't have any unread notifications right now.",
        );

      case 'read':
        return const _EmptyStateConfig(
          icon: Icons.done_all_rounded,
          color: AppColors.info,
          title: 'No read notifications',
          description: 'Notifications you have read will appear here.',
        );

      case 'all':
      default:
        return const _EmptyStateConfig(
          icon: Icons.notifications_none_rounded,
          color: AppColors.primary,
          title: 'No notifications yet',
          description:
              'New notifications and important updates will appear here.',
        );
    }
  }
}

// ================================================================
// Empty State Configuration
// ================================================================

class _EmptyStateConfig {
  const _EmptyStateConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
}
