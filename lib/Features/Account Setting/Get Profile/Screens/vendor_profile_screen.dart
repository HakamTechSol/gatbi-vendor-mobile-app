import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/get_profile_controller.dart';
import '../Models/get_profile_model.dart';

import '../Reuse Widgets/vendor_profile_about_card.dart';
import '../Reuse Widgets/vendor_profile_empty.dart';
import '../Reuse Widgets/vendor_profile_error.dart';
import '../Reuse Widgets/vendor_profile_header.dart';
import '../Reuse Widgets/vendor_profile_hero_card.dart';
import '../Reuse Widgets/vendor_profile_info_card.dart';
import '../Reuse Widgets/vendor_profile_loading.dart';
import '../Reuse Widgets/vendor_profile_status_badge.dart';
import '../Reuse Widgets/vendor_profile_warehouse_card.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  // ============================================================
  // State
  // ============================================================

  late Future<VendorSettingsModel> _profileFuture;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    _profileFuture = _getProfile();
  }

  // ============================================================
  // API
  // ============================================================

  Future<VendorSettingsModel> _getProfile() {
    return ref.read(vendorSettingsControllerProvider).getVendorSettings();
  }

  Future<void> _refreshProfile() async {
    final future = _getProfile();

    setState(() {
      _profileFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // FutureBuilder already handles and displays the error.
      // Swallowing here prevents RefreshIndicator from throwing.
    }
  }

  // ============================================================
  // Navigation
  // ============================================================

  void _handleBack() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  void _handleEdit() {
    if (widget.onEdit == null) {
      return;
    }

    widget.onEdit!();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: VendorProfileHeader(
                onBack: _handleBack,
                onEdit: widget.onEdit == null ? null : _handleEdit,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<VendorSettingsModel>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  // ------------------------------------------------
                  // Loading
                  // ------------------------------------------------

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: VendorProfileLoading(),
                    );
                  }

                  // ------------------------------------------------
                  // Error
                  // ------------------------------------------------

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: VendorProfileError(
                        message: _getErrorMessage(snapshot.error),
                        onRetry: _refreshProfile,
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // No Data
                  // ------------------------------------------------

                  final profile = snapshot.data;

                  if (profile == null || profile.merchant == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: VendorProfileEmpty(onRefresh: _refreshProfile),
                    );
                  }

                  // ------------------------------------------------
                  // Success
                  // ------------------------------------------------

                  return _ProfileContent(
                    merchant: profile.merchant!,
                    onRefresh: _refreshProfile,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Error Message
  // ============================================================

  String _getErrorMessage(Object? error) {
    if (error == null) {
      return 'We couldn’t load your profile information.';
    }

    final message = error.toString().trim();

    if (message.isEmpty) {
      return 'Something went wrong while loading your profile.';
    }

    // ApiException ka useful message show karne ke liye.
    //
    // Agar ApiException.toString() mein extra technical
    // information ho to usko UI mein directly show nahi karenge.
    try {
      final dynamic apiError = error;

      final dynamic apiMessage = apiError.message;

      if (apiMessage is String && apiMessage.trim().isNotEmpty) {
        return apiMessage.trim();
      }
    } catch (_) {
      // Fallback neeche handle hoga.
    }

    return 'Something went wrong while loading your profile.';
  }
}

// ================================================================
// Profile Content
// ================================================================

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.merchant, required this.onRefresh});

  final VendorSettingsMerchantModel merchant;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.white,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // Merchant Hero
            // ======================================================
            VendorProfileHeroCard(merchant: merchant),

            const SizedBox(height: 16),

            // ======================================================
            // Merchant Contact / Status
            // ======================================================
            VendorProfileInfoCard(merchant: merchant),

            const SizedBox(height: 16),

            // ======================================================
            // About Merchant
            // ======================================================
            VendorProfileAboutCard(about: merchant.about),

            const SizedBox(height: 16),

            // ======================================================
            // Warehouse Address
            // ======================================================
            VendorProfileWarehouseCard(address: merchant.warehouseAddress),

            const SizedBox(height: 16),

            // ======================================================
            // Merchant Status
            // ======================================================
            _MerchantStatusCard(
              status: merchant.status,
              kycStatus: merchant.kycStatus,
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// Merchant Status Card
// ================================================================

class _MerchantStatusCard extends StatelessWidget {
  const _MerchantStatusCard({required this.status, required this.kycStatus});

  final String? status;
  final String? kycStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  size: 21,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Merchant Status', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      'Current business verification status',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.settingsSubtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // --------------------------------------------------------
          // Merchant Status
          // --------------------------------------------------------
          _StatusRow(title: 'Account Status', status: status),

          const SizedBox(height: 10),

          // --------------------------------------------------------
          // KYC Status
          // --------------------------------------------------------
          _StatusRow(title: 'KYC Status', status: kycStatus),
        ],
      ),
    );
  }
}

// ================================================================
// Status Row
// ================================================================

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.title, required this.status});

  final String title;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          VendorProfileStatusBadge(status: status, large: true),
        ],
      ),
    );
  }
}
