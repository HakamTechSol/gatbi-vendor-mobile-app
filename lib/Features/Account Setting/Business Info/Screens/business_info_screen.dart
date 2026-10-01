import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Edit Profile/Reuse Widgets/edit_profile_header.dart';
import '../../Get Profile/Controller/get_profile_controller.dart';

class BusinessInfoScreen extends ConsumerStatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  ConsumerState<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends ConsumerState<BusinessInfoScreen> {
  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _businessTypeController = TextEditingController();

  final TextEditingController _tradeLicenseController = TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool _isLoading = true;
  bool _isRefreshing = false;

  String? _errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadBusinessInfo();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _businessTypeController.dispose();
    _tradeLicenseController.dispose();

    super.dispose();
  }

  // ============================================================
  // GET PROFILE / LOAD BUSINESS INFO
  // ============================================================

  Future<void> _loadBusinessInfo({bool isRefresh = false}) async {
    if (!mounted) return;

    if (_isRefreshing) {
      return;
    }

    setState(() {
      if (isRefresh) {
        _isRefreshing = true;
      } else {
        _isLoading = true;
      }

      _errorMessage = null;
    });

    try {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('       BUSINESS INFO - GET PROFILE            ');
      debugPrint('==============================================');
      debugPrint('Fetching merchant business information...');
      debugPrint('');

      final result = await ref
          .read(vendorSettingsControllerProvider)
          .getVendorSettings();

      if (!mounted) return;

      if (result.merchant == null) {
        throw const ApiException(
          message: 'Merchant profile information was not found.',
          code: 'MERCHANT_NOT_FOUND',
        );
      }

      final merchant = result.merchant!;

      final businessType = merchant.businessType?.trim() ?? '';

      final tradeLicenseNumber = merchant.tradeLicenseNumber?.trim() ?? '';

      debugPrint('Business Info GET API Success');
      debugPrint('Merchant ID            : ${merchant.id}');
      debugPrint('Business Type          : $businessType');
      debugPrint('Trade License Number   : $tradeLicenseNumber');
      debugPrint('==============================================');
      debugPrint('');

      // ========================================================
      // SET API VALUES
      // null => empty string
      // ========================================================

      _businessTypeController.text = businessType;

      _tradeLicenseController.text = tradeLicenseNumber;

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('       BUSINESS INFO - GET API ERROR          ');
      debugPrint('==============================================');
      debugPrint('Code    : ${error.code}');
      debugPrint('Message : ${error.message}');
      debugPrint('==============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _errorMessage = error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Unable to load business information.';

        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (error) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('     BUSINESS INFO - GET UNKNOWN ERROR        ');
      debugPrint('==============================================');
      debugPrint('Error: $error');
      debugPrint('==============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';

        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshBusinessInfo() async {
    if (_isRefreshing) {
      return;
    }

    await _loadBusinessInfo(isRefresh: true);
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: EditProfileHeader(
                title: 'Business Information',
                subtitle: 'View your registered business details.',
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (_isLoading) {
      return _buildInitialLoading();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.white,
      onRefresh: _refreshBusinessInfo,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========================================
                      // BUSINESS INFO CARD
                      // ========================================
                      _buildBusinessInfoCard(),

                      const SizedBox(height: 20),

                      // ========================================
                      // REFRESHING INDICATOR
                      // ========================================
                      if (_isRefreshing) ...[
                        _buildRefreshingIndicator(),
                        const SizedBox(height: 16),
                      ],

                      // ========================================
                      // LOCKED BUTTON
                      // ========================================
                      _buildLockedButton(),

                      const SizedBox(height: 12),

                      // ========================================
                      // LOCK NOTE
                      // ========================================
                      _buildLockedNote(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // BUSINESS INFO CARD
  // ============================================================

  Widget _buildBusinessInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // CARD HEADER
          // ==================================================
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Details', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 3),
                    Text(
                      'Your registered business information.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),

              // ==============================================
              // LOCK ICON
              // ==============================================
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 19,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==================================================
          // BUSINESS TYPE
          // ==================================================
          CustomTextField(
            controller: _businessTypeController,
            label: 'Business Type',
            hintText: 'Business type not available',
            prefixIcon: Icons.business_center_outlined,
            enabled: false,
            readOnly: true,
          ),

          const SizedBox(height: 18),

          // ==================================================
          // TRADE LICENSE NUMBER
          // ==================================================
          CustomTextField(
            controller: _tradeLicenseController,
            label: 'Trade License Number',
            hintText: 'Trade license number not available',
            prefixIcon: Icons.badge_outlined,
            enabled: false,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOCKED BUTTON
  // ============================================================

  Widget _buildLockedButton() {
    return CustomButton(
      text: 'Business Information Locked',
      icon: Icons.lock_outline_rounded,
      onPressed: null,
      isEnabled: false,
      backgroundColor: AppColors.disabled,
      foregroundColor: AppColors.textMuted,
    );
  }

  // ============================================================
  // LOCKED NOTE
  // ============================================================

  Widget _buildLockedNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.info,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Business type and trade license number are locked. Contact support to change these.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.infoDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REFRESHING INDICATOR
  // ============================================================

  Widget _buildRefreshingIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            'Refreshing business information...',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INITIAL LOADING
  // ============================================================

  Widget _buildInitialLoading() {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Loading business information',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              'Please wait while we fetch your registered business details.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.errorBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // ==================================================
              // ERROR ICON
              // ==================================================
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // ERROR TITLE
              // ==================================================
              Text(
                'Unable to load business information',
                style: AppTextStyles.errorTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // ==================================================
              // ERROR MESSAGE
              // ==================================================
              Text(
                _errorMessage ?? 'Something went wrong. Please try again.',
                style: AppTextStyles.errorDescription,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // RETRY
              // ==================================================
              CustomButton(
                text: 'Try Again',
                icon: Icons.refresh_rounded,
                onPressed: () {
                  _loadBusinessInfo();
                },
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
