import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    required this.type,
    this.isRead = true,
    this.size = 46,
    this.iconSize = 21,
  });

  final String? type;
  final bool isRead;
  final double size;
  final double iconSize;

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final config = _getNotificationConfig();

    final iconColor = isRead
        ? config.color.withValues(alpha: 0.78)
        : config.color;

    final backgroundColor = isRead
        ? config.color.withValues(alpha: 0.08)
        : config.color.withValues(alpha: 0.12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: config.color.withValues(alpha: isRead ? 0.10 : 0.18),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(config.icon, size: iconSize, color: iconColor),
    );
  }

  // ============================================================
  // Configuration
  // ============================================================

  _NotificationIconConfig _getNotificationConfig() {
    final normalizedType = (type ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');

    switch (normalizedType) {
      // --------------------------------------------------------
      // Security
      // --------------------------------------------------------

      case 'security':
      case 'login':
      case 'authentication':
      case 'password':
      case 'account_security':
        return const _NotificationIconConfig(
          icon: Icons.security_rounded,
          color: AppColors.primary,
        );

      // --------------------------------------------------------
      // Orders
      // --------------------------------------------------------

      case 'order':
      case 'orders':
      case 'new_order':
      case 'order_update':
      case 'order_status':
        return const _NotificationIconConfig(
          icon: Icons.shopping_bag_rounded,
          color: AppColors.info,
        );

      // --------------------------------------------------------
      // Products
      // --------------------------------------------------------

      case 'product':
      case 'products':
      case 'product_update':
      case 'stock':
      case 'inventory':
        return const _NotificationIconConfig(
          icon: Icons.inventory_2_rounded,
          color: AppColors.purple,
        );

      // --------------------------------------------------------
      // Payouts
      // --------------------------------------------------------

      case 'payout':
      case 'payouts':
      case 'wallet':
      case 'withdrawal':
        return const _NotificationIconConfig(
          icon: Icons.account_balance_wallet_rounded,
          color: AppColors.success,
        );

      // --------------------------------------------------------
      // Payments
      // --------------------------------------------------------

      case 'payment':
      case 'payments':
      case 'transaction':
        return const _NotificationIconConfig(
          icon: Icons.payments_rounded,
          color: AppColors.success,
        );

      // --------------------------------------------------------
      // Campaigns
      // --------------------------------------------------------

      case 'campaign':
      case 'campaigns':
      case 'promotion':
      case 'promotions':
        return const _NotificationIconConfig(
          icon: Icons.campaign_rounded,
          color: AppColors.purple,
        );

      // --------------------------------------------------------
      // Tickets / Support
      // --------------------------------------------------------

      case 'ticket':
      case 'tickets':
      case 'support':
        return const _NotificationIconConfig(
          icon: Icons.support_agent_rounded,
          color: AppColors.info,
        );

      // --------------------------------------------------------
      // Warning
      // --------------------------------------------------------

      case 'warning':
      case 'alert':
      case 'attention':
        return const _NotificationIconConfig(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
        );

      // --------------------------------------------------------
      // Error
      // --------------------------------------------------------

      case 'error':
      case 'failed':
      case 'failure':
        return const _NotificationIconConfig(
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
        );

      // --------------------------------------------------------
      // Success
      // --------------------------------------------------------

      case 'success':
      case 'approved':
      case 'completed':
        return const _NotificationIconConfig(
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
        );

      // --------------------------------------------------------
      // Info
      // --------------------------------------------------------

      case 'info':
      case 'information':
        return const _NotificationIconConfig(
          icon: Icons.info_outline_rounded,
          color: AppColors.info,
        );

      // --------------------------------------------------------
      // Default
      // --------------------------------------------------------

      default:
        return const _NotificationIconConfig(
          icon: Icons.notifications_rounded,
          color: AppColors.primary,
        );
    }
  }
}

// ================================================================
// Notification Icon Configuration
// ================================================================

class _NotificationIconConfig {
  const _NotificationIconConfig({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
