import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
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

  /// Pending store ke case mein Add Product disable/hide karne ke liye.
  final bool isStoreApproved;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final isSmallScreen = size.width < 380;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome content
          _buildWelcomeSection(isSmallScreen),

          const SizedBox(height: 18),

          /// Quick actions
          _buildQuickActions(isSmallScreen),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WELCOME SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildWelcomeSection(bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(isSmallScreen),

        SizedBox(width: isSmallScreen ? 12 : 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, $vendorName!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.navy,
                  fontSize: isSmallScreen ? 19 : 22,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isSmallScreen ? 11 : 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATAR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAvatar(bool isSmallScreen) {
    final avatarSize = isSmallScreen ? 46.0 : 54.0;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: AppColors.white,
        size: isSmallScreen ? 23 : 27,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // QUICK ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildQuickActions(bool isSmallScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// Wide mobile/tablet
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              Expanded(child: _buildAddProductButton(context)),

              const SizedBox(width: 10),

              Expanded(child: _buildViewOrdersButton()),

              const SizedBox(width: 10),

              Expanded(child: _buildShopSettingsButton()),
            ],
          );
        }

        /// Mobile
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: _getButtonWidth(constraints.maxWidth, isSmallScreen),
              child: _buildAddProductButton(context),
            ),

            SizedBox(
              width: _getButtonWidth(constraints.maxWidth, isSmallScreen),
              child: _buildViewOrdersButton(),
            ),

            SizedBox(
              width: _getButtonWidth(constraints.maxWidth, isSmallScreen),
              child: _buildShopSettingsButton(),
            ),
          ],
        );
      },
    );
  }

  double _getButtonWidth(double availableWidth, bool isSmallScreen) {
    /// Very small screens par full width buttons.
    if (availableWidth < 340) {
      return availableWidth;
    }

    /// Normal mobile par approximately 2 buttons per row.
    if (isSmallScreen) {
      return (availableWidth - 10) / 2;
    }

    return (availableWidth - 10) / 2;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ADD PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAddProductButton(BuildContext context) {
    return CustomButton(
      text: 'Add Product',
      icon: Icons.add_box_outlined,
      onPressed: isStoreApproved
          ? () {
              context.push(AppRoutes.addProduct);
            }
          : null,
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
      foregroundColor: AppColors.primary,
      borderColor: AppColors.primary,
      backgroundColor: AppColors.white,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VIEW ORDERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildViewOrdersButton() {
    return CustomButton(
      text: 'View Orders',
      icon: Icons.receipt_long_outlined,
      onPressed: onViewOrders,
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
      foregroundColor: AppColors.primary,
      borderColor: AppColors.primary,
      backgroundColor: AppColors.white,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHOP SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildShopSettingsButton() {
    return CustomButton(
      text: 'Shop Settings',
      icon: Icons.settings_outlined,
      onPressed: onShopSettings,
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
      foregroundColor: AppColors.primaryShadow,
      borderColor: AppColors.primaryShadow,
      backgroundColor: AppColors.white,
    );
  }
}
