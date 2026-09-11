import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class DashboardHeader extends StatefulWidget {
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
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // RESET HEADER
  // ============================================================

  /// Header ko default/closed state mein reset karta hai.
  ///
  /// Dashboard par wapas aane par parent screen is method ko call
  /// karegi through GlobalKey.
  void resetHeader() {
    if (!_isExpanded) return;

    setState(() {
      _isExpanded = false;
    });

    _animationController.reverse();
  }

  // ============================================================
  // TOGGLE MENU
  // ============================================================

  void _toggleExpanded() {
    HapticFeedback.selectionClick();

    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  // ============================================================
  // COLLAPSE + ACTION
  // ============================================================

  void _collapseAndRun(VoidCallback action) {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });

      _animationController.reverse();
    }

    action();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 380;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, isSmallScreen: isSmallScreen),

            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? _buildExpandedActions(context, isSmallScreen: isSmallScreen)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context, {required bool isSmallScreen}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 15 : 18,
        isSmallScreen ? 14 : 16,
        isSmallScreen ? 10 : 12,
        isSmallScreen ? 14 : 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(isSmallScreen),

          SizedBox(width: isSmallScreen ? 11 : 14),

          Expanded(child: _buildWelcomeContent(isSmallScreen: isSmallScreen)),

          const SizedBox(width: 8),

          _buildMenuButton(context, isSmallScreen: isSmallScreen),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(bool isSmallScreen) {
    final avatarSize = isSmallScreen ? 46.0 : 52.0;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow.withValues(alpha: 0.22),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.storefront_rounded,
        color: AppColors.white,
        size: isSmallScreen ? 22 : 25,
      ),
    );
  }

  // ============================================================
  // WELCOME CONTENT
  // ============================================================

  Widget _buildWelcomeContent({required bool isSmallScreen}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome back, ${widget.vendorName}!',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.navy,
            fontSize: isSmallScreen ? 17 : 20,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          widget.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 10.5 : 11.5,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENU / CLOSE BUTTON
  // ============================================================

  Widget _buildMenuButton(BuildContext context, {required bool isSmallScreen}) {
    final buttonSize = isSmallScreen ? 40.0 : 44.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleExpanded,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: _isExpanded
                ? AppColors.primary.withValues(alpha: 0.10)
                : AppColors.background,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _isExpanded
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : AppColors.divider.withValues(alpha: 0.8),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              _isExpanded ? Icons.close_rounded : Icons.more_vert_rounded,
              key: ValueKey<bool>(_isExpanded),
              color: _isExpanded ? AppColors.primary : AppColors.textSecondary,
              size: isSmallScreen ? 21 : 23,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EXPANDED ACTIONS
  // ============================================================

  Widget _buildExpandedActions(
    BuildContext context, {
    required bool isSmallScreen,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(
            isSmallScreen ? 12 : 16,
            0,
            isSmallScreen ? 12 : 16,
            isSmallScreen ? 12 : 16,
          ),
          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
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

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: _getButtonWidth(constraints.maxWidth),
                    child: _buildAddProductButton(context),
                  ),
                  SizedBox(
                    width: _getButtonWidth(constraints.maxWidth),
                    child: _buildViewOrdersButton(),
                  ),
                  SizedBox(
                    width: _getButtonWidth(constraints.maxWidth),
                    child: _buildShopSettingsButton(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RESPONSIVE BUTTON WIDTH
  // ============================================================

  double _getButtonWidth(double availableWidth) {
    if (availableWidth < 340) {
      return availableWidth;
    }

    return (availableWidth - 10) / 2;
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Widget _buildAddProductButton(BuildContext context) {
    return CustomButton(
      text: 'Add Product',
      icon: Icons.add_box_outlined,
      onPressed: widget.isStoreApproved
          ? () {
              _collapseAndRun(() {
                if (widget.onAddProduct != null) {
                  widget.onAddProduct!();
                  return;
                }

                context.push(AppRoutes.addProduct);
              });
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

  // ============================================================
  // VIEW ORDERS
  // ============================================================

  Widget _buildViewOrdersButton() {
    return CustomButton(
      text: 'View Orders',
      icon: Icons.receipt_long_outlined,
      onPressed: widget.onViewOrders == null
          ? null
          : () {
              _collapseAndRun(widget.onViewOrders!);
            },
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
      foregroundColor: AppColors.primary,
      borderColor: AppColors.primary,
      backgroundColor: AppColors.white,
    );
  }

  // ============================================================
  // SHOP SETTINGS
  // ============================================================

  Widget _buildShopSettingsButton() {
    return CustomButton(
      text: 'Shop Settings',
      icon: Icons.settings_outlined,
      onPressed: widget.onShopSettings == null
          ? null
          : () {
              _collapseAndRun(widget.onShopSettings!);
            },
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
      foregroundColor: AppColors.primaryShadow,
      borderColor: AppColors.primaryShadow,
      backgroundColor: AppColors.white,
    );
  }
}
