import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Services/api_exception.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../../Settings/settings_controller.dart';
import '../../Settings/settings_model.dart';

import '../Reuse Widgets/support_contact_card.dart';
import '../Reuse Widgets/support_header.dart';
import '../Reuse Widgets/support_help_card.dart';
import '../Reuse Widgets/support_quick_action_card.dart';
import '../Reuse Widgets/support_shimmar.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({
    super.key,
    this.onBack,
    this.onCustomerChatTap,
    this.onCampaignsTap,
    this.onOrdersTap,
    this.onCampaignRequestTap,
    this.onAnalyticsTap,
    this.onProductsTap,
    this.onSettingsTap,
    this.onCreateTicketTap,
  });

  final VoidCallback? onBack;

  final VoidCallback? onCustomerChatTap;
  final VoidCallback? onCampaignsTap;

  final VoidCallback? onOrdersTap;
  final VoidCallback? onCampaignRequestTap;

  final VoidCallback? onAnalyticsTap;
  final VoidCallback? onProductsTap;
  final VoidCallback? onSettingsTap;

  final VoidCallback? onCreateTicketTap;

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen>
    with WidgetsBindingObserver {
  // ============================================================
  // Settings State
  // ============================================================

  SettingsVendorSupportModel? _vendorSupport;

  bool _isLoadingSupport = true;
  String? _supportError;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVendorSupport();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ============================================================
  // App Lifecycle
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshVendorSupport();
    }
  }

  // ============================================================
  // Initial / Refresh
  // ============================================================

  Future<void> _loadVendorSupport() async {
    if (!mounted) return;

    setState(() {
      _isLoadingSupport = true;
      _supportError = null;
    });

    try {
      final result = await ref.read(settingsControllerProvider).getSettings();

      if (!mounted) return;

      setState(() {
        _vendorSupport = result.data?.vendorSupport;
        _isLoadingSupport = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingSupport = false;
        _supportError = error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Unable to load support information.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingSupport = false;
        _supportError = 'Unable to load support information.';
      });
    }
  }

  Future<void> _refreshVendorSupport() async {
    if (!mounted) return;

    await _loadVendorSupport();
  }

  // ============================================================
  // Pull To Refresh
  // ============================================================

  Future<void> _onRefresh() async {
    await _refreshVendorSupport();
  }

  // ============================================================
  // Help Item
  // ============================================================

  void _handleHelpItemTap(String routeKey) {
    switch (routeKey) {
      case 'product':
        widget.onProductsTap?.call();
        break;

      case 'orders':
        widget.onOrdersTap?.call();
        break;

      case 'campaigns':
        widget.onCampaignRequestTap?.call();
        break;
    }
  }

  // ============================================================
  // Email
  // ============================================================

  Future<void> _openEmail() async {
    final email = _vendorSupport?.email.trim();

    if (email == null || email.isEmpty) {
      _showMessage('Support email is not available.');
      return;
    }

    final uri = Uri(scheme: 'mailto', path: email);

    await _launchSupportUri(
      uri,
      errorMessage: 'Unable to open email application.',
    );
  }

  // ============================================================
  // Phone
  // ============================================================

  Future<void> _openPhone() async {
    final phone = _vendorSupport?.phone.trim();

    if (phone == null || phone.isEmpty) {
      _showMessage('Support phone number is not available.');
      return;
    }

    final uri = Uri(scheme: 'tel', path: phone);

    await _launchSupportUri(
      uri,
      errorMessage: 'Unable to open phone application.',
    );
  }

  // ============================================================
  // WhatsApp
  // ============================================================

  Future<void> _openWhatsApp() async {
    final whatsappLink = _vendorSupport?.whatsappLink.trim();

    if (whatsappLink == null || whatsappLink.isEmpty) {
      final whatsapp = _vendorSupport?.whatsapp.trim();

      if (whatsapp == null || whatsapp.isEmpty) {
        _showMessage('WhatsApp number is not available.');
        return;
      }

      final phoneNumber = whatsapp.replaceAll(RegExp(r'[^0-9]'), '');

      if (phoneNumber.isEmpty) {
        _showMessage('Invalid WhatsApp number.');
        return;
      }

      final fallbackUri = Uri.parse('https://wa.me/$phoneNumber');

      await _launchSupportUri(
        fallbackUri,
        errorMessage: 'Unable to open WhatsApp.',
      );

      return;
    }

    final uri = Uri.tryParse(whatsappLink);

    if (uri == null) {
      _showMessage('Invalid WhatsApp link.');
      return;
    }

    await _launchSupportUri(uri, errorMessage: 'Unable to open WhatsApp.');
  }

  // ============================================================
  // Launch URI
  // ============================================================

  Future<void> _launchSupportUri(
    Uri uri, {
    required String errorMessage,
  }) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage(errorMessage);
      }
    } catch (_) {
      if (!mounted) return;

      _showMessage(errorMessage);
    }
  }

  // ============================================================
  // Snackbar
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: _onRefresh,
          child: _isLoadingSupport ? SupportScreenShimmer() : _buildContent(),
        ),
      ),
    );
  }

  // ============================================================
  // Main Content
  // ============================================================

  Widget _buildContent() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        // ========================================================
        // Header
        // ========================================================
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          sliver: SliverToBoxAdapter(
            child: SupportHeader(onBack: widget.onBack),
          ),
        ),

        // ========================================================
        // Quick Actions
        // ========================================================
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
          sliver: SliverToBoxAdapter(child: _buildQuickActions()),
        ),

        // ========================================================
        // Quick Help
        // ========================================================
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(child: _buildQuickHelp()),
        ),

        // ========================================================
        // Payments
        // ========================================================
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(child: _buildPaymentsCard()),
        ),

        // ========================================================
        // Contact Support
        // ========================================================
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(child: _buildSupportContact()),
        ),

        // ========================================================
        // Create Ticket
        // ========================================================
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
          sliver: SliverToBoxAdapter(child: _buildCreateTicketCard()),
        ),
      ],
    );
  }

  // ============================================================
  // Quick Actions
  // ============================================================

  Widget _buildQuickActions() {
    return SizedBox(
      height: 178,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SupportQuickActionCard(
              title: 'Customer Chat',
              description: 'Chat with our support team and get help quickly.',
              icon: Icons.chat_bubble_outline_rounded,
              onTap: widget.onCustomerChatTap ?? () {},
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SupportQuickActionCard(
              title: 'Campaigns',
              description:
                  'Get help with your campaigns and promotional tools.',
              icon: Icons.campaign_outlined,
              onTap: widget.onCampaignsTap ?? () {},
              gradient: AppColors.heroGradient,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Quick Help
  // ============================================================

  Widget _buildQuickHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Help', style: AppTextStyles.labelMedium),

        const SizedBox(height: 4),

        Text(
          'Find quick answers for common vendor questions.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 14),

        _buildHelpItem(
          title: 'Product Support',
          description: 'Get help with products, stock, pricing and listings.',
          icon: Icons.inventory_2_outlined,
          routeKey: 'product',
        ),

        _buildHelpItem(
          title: 'Order Support',
          description: 'Get help with orders, fulfilment and delivery issues.',
          icon: Icons.receipt_long_outlined,
          routeKey: 'orders',
        ),

        _buildHelpItem(
          title: 'Campaign Support',
          description: 'Get help with campaigns and promotional requests.',
          icon: Icons.campaign_outlined,
          routeKey: 'campaigns',
        ),
      ],
    );
  }

  // ============================================================
  // Help Item
  // ============================================================

  Widget _buildHelpItem({
    required String title,
    required String description,
    required IconData icon,
    required String routeKey,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SupportHelpCard(
        title: title,
        description: description,
        icon: icon,
        onTap: () => _handleHelpItemTap(routeKey),
      ),
    );
  }

  // ============================================================
  // Payments Card
  // ============================================================

  Widget _buildPaymentsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.iconPrimary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Payments & Wallet',
                  style: AppTextStyles.labelMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'Need help with wallet balance, payments, transactions '
            'or payout-related issues? Contact our support team.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.support_agent_outlined,
                  size: 19,
                  color: AppColors.iconSecondary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'For payment-related issues, please contact vendor support.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Support Contact
  // ============================================================

  Widget _buildSupportContact() {
    if (_supportError != null) {
      return _buildSupportContactError();
    }

    final support = _vendorSupport;

    if (support == null) {
      return _buildSupportContactError(
        message: 'Support information is not available.',
      );
    }

    return SupportContactCard(
      email: support.email,
      phone: support.phone,
      whatsapp: support.whatsapp,
      supportHours: support.supportHours,
      onEmailTap: _openEmail,
      onPhoneTap: _openPhone,
      onWhatsAppTap: _openWhatsApp,
    );
  }

  // ============================================================
  // Contact Error
  // ============================================================

  Widget _buildSupportContactError({String? message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.support_agent_outlined,
              color: AppColors.iconPrimary,
              size: 24,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Unable to load support information',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium,
          ),

          const SizedBox(height: 5),

          Text(
            message ?? _supportError ?? 'Please try again.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 14),

          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: _loadVendorSupport,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Create Ticket Card
  // ============================================================

  Widget _buildCreateTicketCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: AppColors.iconPrimary,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Still need help?', style: AppTextStyles.labelMedium),

                const SizedBox(height: 4),

                Text(
                  'Create a support ticket and tell us what is happening.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              onTap: widget.onCreateTicketTap,
              borderRadius: BorderRadius.circular(11),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
