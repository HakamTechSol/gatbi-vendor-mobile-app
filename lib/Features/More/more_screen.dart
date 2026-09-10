import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../Features/Authentication/Logout/Controller/logout_controller.dart';
import '../../../Routes/app_route.dart';
import '../../../Services/api_exception.dart';
import '../../../Services/dio.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({
    super.key,

    // Sales
    this.onOrders,
    this.onPayouts,

    // Products
    this.onBulkProducts,

    // Account
    this.onChangePassword,
    this.onSettings,
    this.onKycVerification,

    // Support
    this.onTickets,
    this.onReviewsAndQuestions,
    this.onSupport,

    // Growth
    this.onAnalytics,
    this.onCampaigns,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SALES
  // ═══════════════════════════════════════════════════════════════════════════

  final VoidCallback? onOrders;
  final VoidCallback? onPayouts;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  final VoidCallback? onBulkProducts;

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT
  // ═══════════════════════════════════════════════════════════════════════════

  final VoidCallback? onChangePassword;
  final VoidCallback? onSettings;
  final VoidCallback? onKycVerification;

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT
  // ═══════════════════════════════════════════════════════════════════════════

  final VoidCallback? onTickets;
  final VoidCallback? onReviewsAndQuestions;
  final VoidCallback? onSupport;

  // ═══════════════════════════════════════════════════════════════════════════
  // GROWTH
  // ═══════════════════════════════════════════════════════════════════════════

  final VoidCallback? onAnalytics;
  final VoidCallback? onCampaigns;

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  bool _isLoggingOut = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGOUT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    final shouldLogout = await _showLogoutConfirmation();

    if (!mounted || shouldLogout != true) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      final dioClient = ref.read(dioProvider);

      final controller = LogoutController(dioClient: dioClient);

      final result = await controller.logout();

      if (!mounted) return;

      if (result.success == true) {
        // Replace current navigation stack with Login.
        context.go(AppRoutes.login);
      }
    } on ApiException catch (error) {
      if (!mounted) return;

      _showError(error.message);
    } catch (_) {
      if (!mounted) return;

      _showError('Something went wrong. Please try again.');
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGOUT CONFIRMATION
  // ═══════════════════════════════════════════════════════════════════════════

  Future<bool?> _showLogoutConfirmation() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==========================================================
                // ICON
                // ==========================================================
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 16),

                // ==========================================================
                // TITLE
                // ==========================================================
                Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authTitle.copyWith(
                    fontSize: 21,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 9),

                // ==========================================================
                // MESSAGE
                // ==========================================================
                Text(
                  'Are you sure you want to logout from your account?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authSubtitle.copyWith(
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 22),

                // ==========================================================
                // ACTIONS
                // ==========================================================
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.buttonOutlined.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: AppTextStyles.buttonLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR
  // ═══════════════════════════════════════════════════════════════════════════

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          backgroundColor: AppColors.errorDark,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),

            SliverToBoxAdapter(child: _buildQuickSummary(context)),

            SliverToBoxAdapter(child: _buildSalesSection()),

            SliverToBoxAdapter(child: _buildProductSection()),

            SliverToBoxAdapter(child: _buildAccountSection()),

            SliverToBoxAdapter(child: _buildSupportSection()),

            SliverToBoxAdapter(child: _buildGrowthSection()),

            // ==============================================================
            // LOGOUT
            // ==============================================================
            SliverToBoxAdapter(child: _buildLogoutSection()),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'More',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Manage your store, account and growth',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // QUICK SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildQuickSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryShadow.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: AppColors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vendor Center',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Everything you need to manage your store',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.82),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SALES
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSalesSection() {
    return _buildSection(
      title: 'Sales',
      subtitle: 'Manage your orders and payouts',
      icon: Icons.point_of_sale_rounded,
      children: [
        _buildMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'Orders',
          subtitle: 'View and manage customer orders',
          onTap: widget.onOrders,
        ),
        _buildMenuItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Payouts',
          subtitle: 'Track your earnings and payouts',
          onTap: widget.onPayouts,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductSection() {
    return _buildSection(
      title: 'Products',
      subtitle: 'Manage your product catalogue',
      icon: Icons.inventory_2_outlined,
      children: [
        _buildMenuItem(
          icon: Icons.file_upload_outlined,
          title: 'Bulk Products',
          subtitle: 'Import or manage products in bulk',
          onTap: widget.onBulkProducts,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      subtitle: 'Store and verification settings',
      icon: Icons.manage_accounts_outlined,
      children: [
        _buildMenuItem(
          icon: Icons.lock_outlined,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: widget.onChangePassword,
        ),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'Manage your store preferences',
          onTap: widget.onSettings,
        ),
        _buildMenuItem(
          icon: Icons.verified_user_outlined,
          title: 'KYC Verification',
          subtitle: 'View your verification status',
          onTap: widget.onKycVerification,
          trailing: _buildStatusBadge('Verification'),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSupportSection() {
    return _buildSection(
      title: 'Support',
      subtitle: 'Get help and manage customer feedback',
      icon: Icons.support_agent_rounded,
      children: [
        _buildMenuItem(
          icon: Icons.confirmation_number_outlined,
          title: 'Tickets',
          subtitle: 'Create and track support tickets',
          onTap: widget.onTickets,
        ),
        _buildMenuItem(
          icon: Icons.rate_review_outlined,
          title: 'Reviews & Q&A',
          subtitle: 'Manage product reviews and questions',
          onTap: widget.onReviewsAndQuestions,
        ),
        _buildMenuItem(
          icon: Icons.headset_mic_outlined,
          title: 'Support',
          subtitle: 'Contact the Gatbi support team',
          onTap: widget.onSupport,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GROWTH
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildGrowthSection() {
    return _buildSection(
      title: 'Growth',
      subtitle: 'Improve your store performance',
      icon: Icons.trending_up_rounded,
      children: [
        _buildMenuItem(
          icon: Icons.analytics_outlined,
          title: 'Analytics',
          subtitle: 'Track sales and store performance',
          onTap: widget.onAnalytics,
        ),
        _buildMenuItem(
          icon: Icons.campaign_outlined,
          title: 'Campaigns',
          subtitle: 'Create and manage promotional campaigns',
          onTap: widget.onCampaigns,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGOUT SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLogoutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sign out of your vendor account',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isLoggingOut ? null : _handleLogout,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: _isLoggingOut
                            ? const SizedBox(
                                width: 21,
                                height: 21,
                                child: Padding(
                                  padding: EdgeInsets.all(11),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.logout_rounded,
                                size: 21,
                                color: AppColors.error,
                              ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLoggingOut ? 'Logging out...' : 'Logout',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: _isLoggingOut
                                    ? AppColors.textSecondary
                                    : AppColors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              _isLoggingOut
                                  ? 'Please wait while we sign you out'
                                  : 'Sign out from your vendor account',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: _isLoggingOut
                            ? AppColors.border
                            : AppColors.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(children: _addDividers(children)),
          ),
        ],
      ),
    );
  }

  List<Widget> _addDividers(List<Widget> children) {
    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);

      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 70,
            endIndent: 16,
            color: AppColors.border.withValues(alpha: 0.7),
          ),
        );
      }
    }

    return result;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MENU ITEM
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final enabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: enabled ? AppColors.primary : AppColors.textSecondary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: enabled
                            ? AppColors.navy
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              if (trailing != null) ...[const SizedBox(width: 8), trailing],

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: enabled ? AppColors.textSecondary : AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 9.5,
        ),
      ),
    );
  }
}
