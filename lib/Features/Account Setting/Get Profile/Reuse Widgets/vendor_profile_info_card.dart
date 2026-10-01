import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Authentication/Registration/Category/category_controller.dart';
import '../../../Authentication/Registration/Category/category_model.dart';

import '../Models/get_profile_model.dart';
import 'vendor_profile_info_tile.dart';

class VendorProfileInfoCard extends ConsumerStatefulWidget {
  const VendorProfileInfoCard({super.key, required this.merchant});

  final VendorSettingsMerchantModel merchant;

  @override
  ConsumerState<VendorProfileInfoCard> createState() =>
      _VendorProfileInfoCardState();
}

class _VendorProfileInfoCardState extends ConsumerState<VendorProfileInfoCard> {
  // ============================================================
  // CATEGORY STATE
  // ============================================================

  CategoryItemModel? _selectedCategory;

  bool _isCategoryLoading = true;

  String? _categoryError;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadCategory();
  }

  // ============================================================
  // LOAD CATEGORY
  // ============================================================

  Future<void> _loadCategory() async {
    final categoryId = widget.merchant.primaryCategoryId;

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('VENDOR PROFILE - CATEGORY');
    debugPrint('==========================================');
    debugPrint('Primary Category ID: $categoryId');

    if (categoryId == null) {
      debugPrint('Category ID is null.');

      if (mounted) {
        setState(() {
          _isCategoryLoading = false;
          _categoryError = null;
        });
      }

      return;
    }

    try {
      final result = await ref
          .read(categoryControllerProvider)
          .getCategories(includeChildren: true);

      CategoryItemModel? matchedCategory;

      for (final category in result.categories) {
        if (category.id == categoryId) {
          matchedCategory = category;
          break;
        }
      }

      if (matchedCategory != null) {
        debugPrint('Category Found: ${matchedCategory.name}');
        debugPrint('Category ID: ${matchedCategory.id}');
      } else {
        debugPrint('No category found for ID: $categoryId');
      }

      debugPrint('==========================================');
      debugPrint('');

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedCategory = matchedCategory;
        _isCategoryLoading = false;
      });
    } catch (error) {
      debugPrint('Category API Error: $error');

      debugPrint('==========================================');
      debugPrint('');

      if (!mounted) {
        return;
      }

      setState(() {
        _isCategoryLoading = false;
        _categoryError = 'Unable to load category.';
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return _ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // CARD HEADER
          // ======================================================
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: _SectionHeader(
              icon: Icons.business_center_outlined,
              title: 'Business Information',
              subtitle: 'Your primary merchant contact details',
            ),
          ),

          // ======================================================
          // EMAIL
          // ======================================================
          VendorProfileInfoTile(
            icon: Icons.email_outlined,
            title: 'Email Address',
            value: _value(widget.merchant.email, fallback: 'Not provided'),
            showDivider: true,
          ),

          // ======================================================
          // PHONE
          // ======================================================
          VendorProfileInfoTile(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            value: _value(widget.merchant.phone, fallback: 'Not provided'),
            iconColor: AppColors.success,
            iconBackground: AppColors.successLight,
            showDivider: true,
          ),

          // ======================================================
          // CATEGORY
          // ======================================================
          _buildCategoryTile(),

          // ======================================================
          // STATUS
          // ======================================================
          VendorProfileInfoTile(
            icon: Icons.verified_outlined,
            title: 'Account Status',
            value: _formatStatus(widget.merchant.status),
            iconColor: _statusColor(widget.merchant.status),
            iconBackground: _statusBackground(widget.merchant.status),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY TILE
  // ============================================================

  Widget _buildCategoryTile() {
    String categoryName;

    if (_isCategoryLoading) {
      categoryName = 'Loading category...';
    } else if (_categoryError != null) {
      categoryName = _categoryError!;
    } else if (_selectedCategory != null) {
      categoryName = _value(_selectedCategory!.name, fallback: 'Not provided');
    } else {
      categoryName = 'Not provided';
    }

    return VendorProfileInfoTile(
      icon: Icons.category_outlined,
      title: 'Primary Category',
      value: categoryName,
      iconColor: AppColors.primary,
      iconBackground: AppColors.primaryLight,
      showDivider: true,
    );
  }

  // ============================================================
  // VALUE
  // ============================================================

  String _value(String? value, {required String fallback}) {
    if (value == null || value.trim().isEmpty) {
      return fallback;
    }

    return value.trim();
  }

  // ============================================================
  // STATUS FORMAT
  // ============================================================

  String _formatStatus(String? status) {
    if (status == null || status.trim().isEmpty) {
      return 'Not available';
    }

    final value = status.trim();

    return value[0].toUpperCase() + value.substring(1);
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'approved':
      case 'active':
        return AppColors.success;

      case 'pending':
        return AppColors.warning;

      case 'rejected':
      case 'suspended':
        return AppColors.error;

      default:
        return AppColors.primary;
    }
  }

  // ============================================================
  // STATUS BACKGROUND
  // ============================================================

  Color _statusBackground(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'approved':
      case 'active':
        return AppColors.successLight;

      case 'pending':
        return AppColors.warningLight;

      case 'rejected':
      case 'suspended':
        return AppColors.errorLight;

      default:
        return AppColors.primaryLight;
    }
  }
}

// ============================================================================
// PROFILE CARD
// ============================================================================

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

// ============================================================================
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: AppColors.primary),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),

              const SizedBox(height: 2),

              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.settingsSubtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
