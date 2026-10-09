import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class DashboardHeader extends StatelessWidget implements PreferredSizeWidget {
  const DashboardHeader({
    super.key,
    required this.vendorName,
    this.subtitle =
        'Manage your catalogue, orders, and store performance from one place.',
    this.onAddProduct,
    this.onViewOrders,
    this.onShopSettings,
    this.isStoreApproved = true,
  });

  final String vendorName;
  final String subtitle;

  final VoidCallback? onAddProduct;
  final VoidCallback? onViewOrders;
  final VoidCallback? onShopSettings;

  /// Store approved hai ya abhi review/pending mein hai.
  final bool isStoreApproved;

  // ===========================================================================
  // PREFERRED SIZE
  // ===========================================================================

  @override
  Size get preferredSize => const Size.fromHeight(86);

  // ===========================================================================
  // ADD PRODUCT
  // ===========================================================================

  void _handleAddProduct(BuildContext context) {
    HapticFeedback.selectionClick();

    if (!isStoreApproved) return;

    if (onAddProduct != null) {
      onAddProduct!();
      return;
    }

    context.push(AppRoutes.addProduct);
  }

  // ===========================================================================
  // VIEW ORDERS
  // ===========================================================================

  void _handleViewOrders() {
    HapticFeedback.selectionClick();
    onViewOrders?.call();
  }

  // ===========================================================================
  // SHOP SETTINGS
  // ===========================================================================

  void _handleShopSettings() {
    HapticFeedback.selectionClick();
    onShopSettings?.call();
  }

  // ===========================================================================
  // QUICK ACTIONS SHEET
  // ===========================================================================

  Future<void> _showActionsMenu(BuildContext context) async {
    HapticFeedback.selectionClick();

    final selectedAction = await showModalBottomSheet<_DashboardAction>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      useSafeArea: true,
      builder: (_) {
        return _DashboardActionsSheet(
          isStoreApproved: isStoreApproved,
        );
      },
    );

    if (selectedAction == null || !context.mounted) return;

    switch (selectedAction) {
      case _DashboardAction.addProduct:
        _handleAddProduct(context);
        break;

      case _DashboardAction.viewOrders:
        _handleViewOrders();
        break;

      case _DashboardAction.shopSettings:
        _handleShopSettings();
        break;
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final bool isVerySmall = width < 360;
    final bool isSmall = width < 430;
    final bool showDirectAddButton = width >= 600 && isStoreApproved;

    return AppBar(
      automaticallyImplyLeading: false,

      toolbarHeight: 85,

      elevation: 0,
      scrolledUnderElevation: 0,

      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,

      titleSpacing: 0,

      title: Padding(
        padding: EdgeInsets.only(
          left: isVerySmall ? 12 : 16,
          right: 8,
        ),
        child: Row(
          children: [
            // -----------------------------------------------------------------
            // STORE AVATAR
            // -----------------------------------------------------------------
            _StoreAvatar(
              compact: isVerySmall,
            ),

            SizedBox(
              width: isVerySmall ? 9 : 12,
            ),

            // -----------------------------------------------------------------
            // STORE INFORMATION
            // -----------------------------------------------------------------
            Expanded(
              child: _HeaderInformation(
                vendorName: vendorName,
                subtitle: subtitle,
                isStoreApproved: isStoreApproved,
                compact: isVerySmall,
                small: isSmall,
              ),
            ),
          ],
        ),
      ),

      actions: [
        // ---------------------------------------------------------------------
        // DESKTOP/TABLET ADD PRODUCT
        // ---------------------------------------------------------------------
        if (showDirectAddButton)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _AddProductButton(
              onTap: () => _handleAddProduct(context),
            ),
          ),

        // ---------------------------------------------------------------------
        // QUICK ACTIONS
        // ---------------------------------------------------------------------
        Padding(
          padding: EdgeInsets.only(
            right: isVerySmall ? 10 : 14,
          ),
          child: _HeaderMenuButton(
            compact: isVerySmall,
            onTap: () => _showActionsMenu(context),
          ),
        ),
      ],

      // -----------------------------------------------------------------------
      // BOTTOM BORDER
      // -----------------------------------------------------------------------
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.divider.withValues(alpha: 0.65),
        ),
      ),
    );
  }
}

// =============================================================================
// STORE AVATAR
// =============================================================================

class _StoreAvatar extends StatelessWidget {
  const _StoreAvatar({
    required this.compact,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 42.0 : 48.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow.withValues(alpha: 0.20),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.storefront_rounded,
            color: AppColors.white,
            size: compact ? 20 : 23,
          ),

          // Small decorative shine.
          Positioned(
            top: compact ? 7 : 8,
            right: compact ? 7 : 9,
            child: Container(
              width: compact ? 6 : 7,
              height: compact ? 6 : 7,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// HEADER INFORMATION
// =============================================================================

class _HeaderInformation extends StatelessWidget {
  const _HeaderInformation({
    required this.vendorName,
    required this.subtitle,
    required this.isStoreApproved,
    required this.compact,
    required this.small,
  });

  final String vendorName;
  final String subtitle;
  final bool isStoreApproved;

  final bool compact;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------------------------------------------------
        // TOP ROW
        // ---------------------------------------------------------------------
        Row(
          children: [
            Flexible(
              child: Text(
                'Welcome back, $vendorName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.navy,
                  fontSize: compact
                      ? 15.5
                      : small
                          ? 17
                          : 19,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            // -----------------------------------------------------------------
            // APPROVAL BADGE
            // -----------------------------------------------------------------
            if (!compact) ...[
              const SizedBox(width: 8),
              _StoreStatusBadge(
                isApproved: isStoreApproved,
              ),
            ],
          ],
        ),

        const SizedBox(height: 5),

        // ---------------------------------------------------------------------
        // SUBTITLE
        // ---------------------------------------------------------------------
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: compact ? 9.5 : 10.5,
            fontWeight: FontWeight.w500,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// STORE STATUS BADGE
// =============================================================================

class _StoreStatusBadge extends StatelessWidget {
  const _StoreStatusBadge({
    required this.isApproved,
  });

  final bool isApproved;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isApproved
        ? AppColors.success.withValues(alpha: 0.10)
        : AppColors.warning.withValues(alpha: 0.11);

    final foregroundColor =
        isApproved ? AppColors.success : AppColors.warning;

    final icon =
        isApproved ? Icons.verified_rounded : Icons.schedule_rounded;

    final text = isApproved ? 'Approved' : 'Under Review';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: foregroundColor.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: foregroundColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: foregroundColor,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ADD PRODUCT BUTTON
// =============================================================================

class _AddProductButton extends StatelessWidget {
  const _AddProductButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          height: 42,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                color: AppColors.white,
                size: 19,
              ),
              const SizedBox(width: 6),
              Text(
                'Add Product',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER MENU BUTTON
// =============================================================================

class _HeaderMenuButton extends StatelessWidget {
  const _HeaderMenuButton({
    required this.compact,
    required this.onTap,
  });

  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 40.0 : 44.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.divider.withValues(alpha: 0.85),
            ),
          ),
          child: Icon(
            Icons.more_horiz_rounded,
            color: AppColors.navy.withValues(alpha: 0.75),
            size: compact ? 21 : 23,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DASHBOARD ACTIONS
// =============================================================================

enum _DashboardAction {
  addProduct,
  viewOrders,
  shopSettings,
}

// =============================================================================
// ACTIONS BOTTOM SHEET
// =============================================================================

class _DashboardActionsSheet extends StatelessWidget {
  const _DashboardActionsSheet({
    required this.isStoreApproved,
  });

  final bool isStoreApproved;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        10,
      ),
      padding: EdgeInsets.fromLTRB(
        14,
        9,
        14,
        14 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.75),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.14),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------------------------------------------------------------------
          // HANDLE
          // -------------------------------------------------------------------
          Container(
            width: 38,
            height: 4,
            margin: const EdgeInsets.only(
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // -------------------------------------------------------------------
          // SHEET HEADER
          // -------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              2,
              0,
              2,
              15,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryShadow.withValues(
                          alpha: 0.18,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.dashboard_customize_rounded,
                    color: AppColors.white,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Manage your store quickly',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // -------------------------------------------------------------------
          // ADD PRODUCT
          // -------------------------------------------------------------------
          _ActionButton(
            text: 'Add Product',
            subtitle: isStoreApproved
                ? 'Create a new product'
                : 'Available after store approval',
            icon: Icons.add_box_rounded,
            enabled: isStoreApproved,
            onPressed: () {
              Navigator.of(context).pop(
                _DashboardAction.addProduct,
              );
            },
          ),

          const SizedBox(height: 9),

          // -------------------------------------------------------------------
          // VIEW ORDERS
          // -------------------------------------------------------------------
          _ActionButton(
            text: 'View Orders',
            subtitle: 'Manage customer orders',
            icon: Icons.receipt_long_rounded,
            enabled: true,
            onPressed: () {
              Navigator.of(context).pop(
                _DashboardAction.viewOrders,
              );
            },
          ),

          const SizedBox(height: 9),

          // -------------------------------------------------------------------
          // SHOP SETTINGS
          // -------------------------------------------------------------------
          _ActionButton(
            text: 'Shop Settings',
            subtitle: 'Manage your store settings',
            icon: Icons.settings_rounded,
            enabled: true,
            iconBackground: AppColors.primaryShadow.withValues(alpha: 0.10),
            iconColor: AppColors.primaryShadow,
            onPressed: () {
              Navigator.of(context).pop(
                _DashboardAction.shopSettings,
              );
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ACTION BUTTON
// =============================================================================

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.text,
    required this.subtitle,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    this.iconBackground,
    this.iconColor,
  });

  final String text;
  final String subtitle;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  final Color? iconBackground;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final foreground = enabled
        ? AppColors.primary
        : AppColors.textSecondary.withValues(alpha: 0.55);

    final background = enabled
        ? AppColors.primary.withValues(alpha: 0.055)
        : AppColors.background;

    final borderColor = enabled
        ? AppColors.primary.withValues(alpha: 0.14)
        : AppColors.divider.withValues(alpha: 0.7);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              // -----------------------------------------------------------------
              // ICON
              // -----------------------------------------------------------------
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground ??
                      (enabled
                          ? AppColors.primary.withValues(alpha: 0.10)
                          : AppColors.divider.withValues(alpha: 0.35)),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? foreground,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              // -----------------------------------------------------------------
              // TEXT
              // -----------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: enabled
                            ? AppColors.navy
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // -----------------------------------------------------------------
              // ARROW
              // -----------------------------------------------------------------
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: enabled
                    ? AppColors.textSecondary
                    : AppColors.textSecondary.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}