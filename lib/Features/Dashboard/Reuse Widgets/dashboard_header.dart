import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
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

  /// Pending store ke case mein Add Product disable rahega.
  final bool isStoreApproved;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  void _handleAddProduct(BuildContext context) {
    HapticFeedback.selectionClick();

    if (!isStoreApproved) return;

    if (onAddProduct != null) {
      onAddProduct!();
      return;
    }

    context.push(AppRoutes.addProduct);
  }

  // ============================================================
  // VIEW ORDERS
  // ============================================================

  void _handleViewOrders() {
    HapticFeedback.selectionClick();

    onViewOrders?.call();
  }

  // ============================================================
  // SHOP SETTINGS
  // ============================================================

  void _handleShopSettings() {
    HapticFeedback.selectionClick();

    onShopSettings?.call();
  }

  // ============================================================
  // ACTION SHEET
  // ============================================================

  Future<void> _showActionsMenu(BuildContext context) async {
    HapticFeedback.selectionClick();

    final selectedAction = await showModalBottomSheet<_DashboardAction>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      useSafeArea: true,
      builder: (sheetContext) {
        return _DashboardActionsSheet(isStoreApproved: isStoreApproved);
      },
    );

    if (selectedAction == null) return;

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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 380;

    return AppBar(
      automaticallyImplyLeading: false,

      toolbarHeight: 76,

      elevation: 0,
      scrolledUnderElevation: 0,

      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,

      titleSpacing: 0,

      title: Padding(
        padding: EdgeInsets.only(left: isSmallScreen ? 14 : 18, right: 4),
        child: Row(
          children: [
            _buildAvatar(isSmallScreen: isSmallScreen),

            SizedBox(width: isSmallScreen ? 10 : 13),

            Expanded(child: _buildWelcomeContent(isSmallScreen: isSmallScreen)),
          ],
        ),
      ),

      actions: [
        Padding(
          padding: EdgeInsets.only(right: isSmallScreen ? 10 : 14),
          child: _buildMenuButton(context, isSmallScreen: isSmallScreen),
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.divider.withValues(alpha: 0.65),
        ),
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar({required bool isSmallScreen}) {
    final avatarSize = isSmallScreen ? 44.0 : 48.0;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: AppColors.white,
        size: isSmallScreen ? 21 : 23,
      ),
    );
  }

  // ============================================================
  // WELCOME CONTENT
  // ============================================================

  Widget _buildWelcomeContent({required bool isSmallScreen}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $vendorName!',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.navy,
            fontSize: isSmallScreen ? 16.5 : 19,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 10 : 11,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENU BUTTON
  // ============================================================

  Widget _buildMenuButton(BuildContext context, {required bool isSmallScreen}) {
    final buttonSize = isSmallScreen ? 40.0 : 44.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showActionsMenu(context),
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
          ),
          child: Icon(
            Icons.more_vert_rounded,
            color: AppColors.textSecondary,
            size: isSmallScreen ? 21 : 23,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DASHBOARD ACTIONS
// ============================================================================

enum _DashboardAction { addProduct, viewOrders, shopSettings }

// ============================================================================
// ACTIONS SHEET
// ============================================================================

class _DashboardActionsSheet extends StatelessWidget {
  const _DashboardActionsSheet({required this.isStoreApproved});

  final bool isStoreApproved;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(12, 10, 12, 12 + bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.12),
            blurRadius: 25,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ========================================================
          // HANDLE
          // ========================================================
          Container(
            width: 38,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // ========================================================
          // HEADER
          // ========================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryShadow.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.dashboard_customize_outlined,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manage your store',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ========================================================
          // ADD PRODUCT
          // ========================================================
          CustomButton(
            text: 'Add Product',
            icon: Icons.add_box_outlined,
            onPressed: isStoreApproved
                ? () {
                    Navigator.of(context).pop(_DashboardAction.addProduct);
                  }
                : null,
            type: CustomButtonType.outlined,
            height: 46,
            borderRadius: 12,
            foregroundColor: AppColors.primary,
            borderColor: AppColors.primary,
            backgroundColor: AppColors.white,
          ),

          const SizedBox(height: 9),

          // ========================================================
          // VIEW ORDERS
          // ========================================================
          CustomButton(
            text: 'View Orders',
            icon: Icons.receipt_long_outlined,
            onPressed: () {
              Navigator.of(context).pop(_DashboardAction.viewOrders);
            },
            type: CustomButtonType.outlined,
            height: 46,
            borderRadius: 12,
            foregroundColor: AppColors.primary,
            borderColor: AppColors.primary,
            backgroundColor: AppColors.white,
          ),

          const SizedBox(height: 9),

          // ========================================================
          // SHOP SETTINGS
          // ========================================================
          CustomButton(
            text: 'Shop Settings',
            icon: Icons.settings_outlined,
            onPressed: () {
              Navigator.of(context).pop(_DashboardAction.shopSettings);
            },
            type: CustomButtonType.outlined,
            height: 46,
            borderRadius: 12,
            foregroundColor: AppColors.primaryShadow,
            borderColor: AppColors.primaryShadow,
            backgroundColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
