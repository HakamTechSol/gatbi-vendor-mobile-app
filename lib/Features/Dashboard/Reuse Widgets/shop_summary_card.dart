import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../../Authentication/Registration/Category/category_controller.dart';
import '../../Authentication/Registration/Category/category_model.dart';

class ShopSummaryCard extends ConsumerStatefulWidget {
  const ShopSummaryCard({
    super.key,
    required this.status,
    required this.kycStatus,
    required this.businessType,
    required this.primaryCategory,
    required this.supportEmail,
    required this.warehouseAddress,
  });

  final String status;
  final String kycStatus;
  final String businessType;
  final String primaryCategory;
  final String supportEmail;
  final String warehouseAddress;

  @override
  ConsumerState<ShopSummaryCard> createState() => _ShopSummaryCardState();
}

class _ShopSummaryCardState extends ConsumerState<ShopSummaryCard> {
  // ===========================================================================
  // CATEGORY STATE
  // ===========================================================================

  String? _categoryName;
  bool _isCategoryLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategoryName();
  }

  // ===========================================================================
  // LOAD CATEGORY
  // ===========================================================================

  Future<void> _loadCategoryName() async {
    final rawCategory = widget.primaryCategory.trim();

    if (rawCategory.isEmpty) {
      return;
    }

    final categoryId = int.tryParse(rawCategory);

    // Agar primaryCategory already name hai, API call ki zaroorat nahi.
    if (categoryId == null) {
      if (mounted) {
        setState(() {
          _categoryName = rawCategory;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isCategoryLoading = true;
      });
    }

    try {
      final controller = ref.read(categoryControllerProvider);

      final result = await controller.getCategories(includeChildren: true);

      final category = _findCategoryById(result.categories, categoryId);

      if (!mounted) return;

      setState(() {
        _categoryName = category?.name?.trim().isNotEmpty == true
            ? category!.name!.trim()
            : rawCategory;
        _isCategoryLoading = false;
      });
    } catch (error) {
      debugPrint('========== SHOP SUMMARY CATEGORY ERROR ==========');
      debugPrint('Category ID: $rawCategory');
      debugPrint('Error: $error');
      debugPrint('=================================================');

      if (!mounted) return;

      // API fail hone ki surat mein original value
      // fallback ke taur par show hogi.
      setState(() {
        _categoryName = rawCategory;
        _isCategoryLoading = false;
      });
    }
  }

  // ===========================================================================
  // FIND CATEGORY
  // ===========================================================================

  CategoryItemModel? _findCategoryById(
    List<CategoryItemModel> categories,
    int categoryId,
  ) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category;
      }
    }

    return null;
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.055),
            blurRadius: 24,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 18),

          _buildStatusOverview(),

          const SizedBox(height: 18),

          _buildSectionLabel(
            icon: Icons.info_outline_rounded,
            title: 'Store Information',
          ),

          const SizedBox(height: 10),

          _buildInfoGroup(
            children: [
              _buildInfoRow(
                icon: Icons.business_outlined,
                label: 'Business Type',
                value: widget.businessType,
              ),

              _buildInfoDivider(),

              _buildCategoryRow(),

              _buildInfoDivider(),

              _buildInfoRow(
                icon: Icons.email_outlined,
                label: 'Support Email',
                value: widget.supportEmail,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildAddressSection(),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: AppColors.primary,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop Summary',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Your store information and verification status',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.store_rounded, size: 12, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                'Store',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STATUS OVERVIEW
  // ===========================================================================

  Widget _buildStatusOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            title: 'Store Status',
            value: widget.status,
            icon: Icons.verified_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatusCard(
            title: 'KYC Status',
            value: widget.kycStatus,
            icon: Icons.fact_check_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final statusStyle = _getStatusStyle(value);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusStyle.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusStyle.color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: statusStyle.color),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusStyle.color,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        value.trim().isEmpty ? 'Not available' : value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: statusStyle.color,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION LABEL
  // ===========================================================================

  Widget _buildSectionLabel({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.navy,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // INFORMATION GROUP
  // ===========================================================================

  Widget _buildInfoGroup({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.45)),
      ),
      child: Column(children: children),
    );
  }

  // ===========================================================================
  // BUSINESS / EMAIL INFO ROW
  // ===========================================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final hasValue = value.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfoIcon(icon),

          const SizedBox(width: 10),

          Expanded(
            flex: 4,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            flex: 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                hasValue ? value : 'Not available',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasValue ? AppColors.navy : AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: hasValue ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CATEGORY ROW
  // ===========================================================================

  Widget _buildCategoryRow() {
    final fallbackValue = widget.primaryCategory.trim();

    final displayValue = _isCategoryLoading
        ? '...'
        : (_categoryName?.trim().isNotEmpty == true
              ? _categoryName!.trim()
              : (fallbackValue.isNotEmpty ? fallbackValue : 'Not available'));

    final hasRealValue =
        !_isCategoryLoading &&
        displayValue != 'Not available' &&
        displayValue.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfoIcon(Icons.category_outlined),

          const SizedBox(width: 10),

          Expanded(
            flex: 4,
            child: Text(
              'Primary Category',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            flex: 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                displayValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasRealValue
                      ? AppColors.navy
                      : AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: _isCategoryLoading
                      ? FontWeight.w600
                      : (hasRealValue ? FontWeight.w700 : FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ADDRESS SECTION
  // ===========================================================================

  Widget _buildAddressSection() {
    final hasAddress = widget.warehouseAddress.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warehouse Address',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  hasAddress ? widget.warehouseAddress : 'Not available',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: hasAddress
                        ? AppColors.navy
                        : AppColors.textSecondary,
                    fontSize: 10.5,
                    fontWeight: hasAddress ? FontWeight.w700 : FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // INFO ICON
  // ===========================================================================

  Widget _buildInfoIcon(IconData icon) {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Icon(icon, color: AppColors.primary, size: 16),
    );
  }

  // ===========================================================================
  // DIVIDER
  // ===========================================================================

  Widget _buildInfoDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 53),
      child: Container(
        height: 1,
        color: AppColors.divider.withValues(alpha: 0.45),
      ),
    );
  }

  // ===========================================================================
  // STATUS STYLE
  // ===========================================================================

  _StatusStyle _getStatusStyle(String value) {
    final normalized = value.trim().toLowerCase();

    final isApproved =
        normalized == 'approved' ||
        normalized == 'verified' ||
        normalized == 'complete' ||
        normalized == 'completed';

    final isPending =
        normalized == 'pending' ||
        normalized == 'under review' ||
        normalized == 'under_review';

    if (isApproved) {
      return _StatusStyle(
        color: AppColors.success,
        backgroundColor: AppColors.success.withValues(alpha: 0.07),
      );
    }

    if (isPending) {
      return _StatusStyle(
        color: AppColors.warning,
        backgroundColor: AppColors.warning.withValues(alpha: 0.08),
      );
    }

    return _StatusStyle(
      color: AppColors.error,
      backgroundColor: AppColors.error.withValues(alpha: 0.07),
    );
  }
}

// =============================================================================
// STATUS STYLE MODEL
// =============================================================================

class _StatusStyle {
  const _StatusStyle({required this.color, required this.backgroundColor});

  final Color color;
  final Color backgroundColor;
}
