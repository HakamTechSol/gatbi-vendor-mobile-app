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

  final Future<dynamic> Function()? onEdit;

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  // ============================================================
  // State
  // ============================================================

  late Future<VendorSettingsModel> _profileFuture;

  bool _isRefreshing = false;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    _profileFuture = _getProfile();
  }

  // ============================================================
  // GET PROFILE API
  // ============================================================

  Future<VendorSettingsModel> _getProfile() async {
    debugPrint('');
    debugPrint('==================================================');
    debugPrint('VENDOR PROFILE - GET PROFILE API');
    debugPrint('==================================================');
    debugPrint('API CALL STARTED');
    debugPrint('==================================================');
    debugPrint('');

    try {
      final result = await ref
          .read(vendorSettingsControllerProvider)
          .getVendorSettings();

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('VENDOR PROFILE - GET PROFILE SUCCESS');
      debugPrint('==================================================');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MERCHANT ID: ${result.merchant?.id ?? 'N/A'}');
      debugPrint('MERCHANT NAME: ${result.merchant?.name ?? 'N/A'}');
      debugPrint('PHONE: ${result.merchant?.phone ?? 'N/A'}');
      debugPrint('LOGO: ${result.merchant?.logo ?? 'N/A'}');
      debugPrint(
        'CATEGORY ID: '
        '${result.merchant?.primaryCategoryId ?? 'N/A'}',
      );
      debugPrint(
        'WAREHOUSE: '
        '${result.merchant?.warehouseAddress ?? 'N/A'}',
      );
      debugPrint('==================================================');
      debugPrint('');

      return result;
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('==================================================');
      debugPrint('VENDOR PROFILE - GET PROFILE ERROR');
      debugPrint('==================================================');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('==================================================');
      debugPrint('');

      rethrow;
    }
  }

  // ============================================================
  // REFRESH PROFILE
  // ============================================================

  Future<void> _refreshProfile() async {
    if (_isRefreshing) {
      debugPrint('VENDOR PROFILE - Refresh already in progress.');
      return;
    }

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('VENDOR PROFILE - FORCE REFRESH');
    debugPrint('==================================================');
    debugPrint('OLD PROFILE WILL BE REPLACED');
    debugPrint('SHIMMER WILL BE SHOWN');
    debugPrint('==================================================');
    debugPrint('');

    final future = _getProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      _isRefreshing = true;
      _profileFuture = future;
    });

    try {
      await future;

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('VENDOR PROFILE - REFRESH SUCCESS');
      debugPrint('==================================================');
      debugPrint('Fresh profile data received.');
      debugPrint('==================================================');
      debugPrint('');
    } catch (error) {
      debugPrint('');
      debugPrint('==================================================');
      debugPrint('VENDOR PROFILE - REFRESH ERROR');
      debugPrint('==================================================');
      debugPrint('ERROR: $error');
      debugPrint('==================================================');
      debugPrint('');
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isRefreshing = false;
      });

      debugPrint('VENDOR PROFILE - REFRESH LOADING FINISHED');
    }
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  Future<void> _handleEdit() async {
    if (widget.onEdit == null || _isRefreshing) {
      return;
    }

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('VENDOR PROFILE - EDIT PROFILE');
    debugPrint('==================================================');
    debugPrint('Opening Edit Profile...');
    debugPrint('==================================================');
    debugPrint('');

    try {
      final result = await widget.onEdit!();

      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('VENDOR PROFILE - RETURNED FROM EDIT');
      debugPrint('==================================================');
      debugPrint('RESULT: $result');
      debugPrint('RESULT TYPE: ${result.runtimeType}');
      debugPrint('==================================================');
      debugPrint('');

      // ----------------------------------------------------------
      // IMPORTANT:
      //
      // Edit Profile success ke baad result aayega.
      //
      // Lekin agar user simply Back bhi kare,
      // hum profile refresh karenge.
      // ----------------------------------------------------------

      await _refreshProfile();
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('==================================================');
      debugPrint('VENDOR PROFILE - EDIT NAVIGATION ERROR');
      debugPrint('==================================================');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('==================================================');
      debugPrint('');
    }
  }

  // ============================================================
  // BACK
  // ============================================================

  void _handleBack() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ======================================================
            // HEADER
            // ======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: VendorProfileHeader(
                onBack: _handleBack,
                onEdit: widget.onEdit == null ? null : _handleEdit,
              ),
            ),

            const SizedBox(height: 8),

            // ======================================================
            // CONTENT
            // ======================================================
            Expanded(child: _buildProfileBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE BODY
  // ============================================================

  Widget _buildProfileBody() {
    // ------------------------------------------------------------
    // FORCE REFRESH LOADING
    //
    // Ye sabse important hai.
    // Edit se wapas aane ke baad _isRefreshing true hoga,
    // isliye old profile temporarily hide hogi aur shimmer
    // immediately show hoga.
    // ------------------------------------------------------------

    if (_isRefreshing) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: VendorProfileLoading(),
      );
    }

    return FutureBuilder<VendorSettingsModel>(
      future: _profileFuture,
      builder: (context, snapshot) {
        // --------------------------------------------------------
        // INITIAL LOADING
        // --------------------------------------------------------

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: VendorProfileLoading(),
          );
        }

        // --------------------------------------------------------
        // ERROR
        // --------------------------------------------------------

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VendorProfileError(
              message: _getErrorMessage(snapshot.error),
              onRetry: _refreshProfile,
            ),
          );
        }

        // --------------------------------------------------------
        // DATA
        // --------------------------------------------------------

        final profile = snapshot.data;

        if (profile == null || profile.merchant == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VendorProfileEmpty(onRefresh: _refreshProfile),
          );
        }

        // --------------------------------------------------------
        // SUCCESS
        // --------------------------------------------------------

        return _ProfileContent(
          merchant: profile.merchant!,
          onRefresh: _refreshProfile,
        );
      },
    );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(Object? error) {
    if (error == null) {
      return 'We couldn’t load your profile information.';
    }

    try {
      final dynamic apiError = error;

      final dynamic apiMessage = apiError.message;

      if (apiMessage is String && apiMessage.trim().isNotEmpty) {
        return apiMessage.trim();
      }
    } catch (_) {
      // Fallback below.
    }

    return 'Something went wrong while loading your profile.';
  }
}

// ================================================================
// PROFILE CONTENT
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
            VendorProfileHeroCard(merchant: merchant),

            const SizedBox(height: 16),

            VendorProfileInfoCard(merchant: merchant),

            const SizedBox(height: 16),

            VendorProfileAboutCard(about: merchant.about),

            const SizedBox(height: 16),

            VendorProfileWarehouseCard(address: merchant.warehouseAddress),

            const SizedBox(height: 16),

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
// MERCHANT STATUS CARD
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

          _StatusRow(title: 'Account Status', status: status),

          const SizedBox(height: 10),

          _StatusRow(title: 'KYC Status', status: kycStatus),
        ],
      ),
    );
  }
}

// ================================================================
// STATUS ROW
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
