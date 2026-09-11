import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class ShopSummaryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          _buildDivider(),
          const SizedBox(height: 2),

          // ---------------- ROWS ----------------
          _buildInfoRow(
            icon: Icons.verified_outlined,
            label: 'Store Status',
            value: status,
            valueWidget: _buildStatusBadge(status),
          ),

          _buildInfoDivider(),

          _buildInfoRow(
            icon: Icons.fact_check_outlined,
            label: 'KYC Status',
            value: kycStatus,
            valueWidget: _buildStatusBadge(kycStatus),
          ),

          _buildInfoDivider(),

          _buildInfoRow(
            icon: Icons.business_outlined,
            label: 'Business Type',
            value: businessType,
          ),

          _buildInfoDivider(),

          _buildInfoRow(
            icon: Icons.category_outlined,
            label: 'Primary Category',
            value: primaryCategory,
          ),

          _buildInfoDivider(),

          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Support Email',
            value: supportEmail,
            valueMaxLines: 2,
          ),

          _buildInfoDivider(),

          _buildAddressRow(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 11),
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
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your store information',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INFO ROW  —  Left label  |  Right value (right-aligned)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? valueWidget,
    int valueMaxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT — Icon
          _buildIcon(icon),

          const SizedBox(width: 11),

          // LEFT — Label (fixed-ish width, expands as needed)
          Expanded(
            flex: 3,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // RIGHT — Value (right-aligned, takes remaining space)
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child:
                  valueWidget ??
                  Text(
                    value.isEmpty ? '—' : value,
                    maxLines: valueMaxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.navy,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ADDRESS ROW  —  top-aligned (multi-line)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAddressRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: _buildIcon(Icons.location_on_outlined),
          ),

          const SizedBox(width: 11),

          // Label
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Warehouse Address',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Value (multi-line, right-aligned)
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                warehouseAddress.isEmpty ? '—' : warehouseAddress,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildIcon(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: AppColors.primary, size: 17),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusBadge(String value) {
    final normalized = value.trim().toLowerCase();

    final bool isApproved =
        normalized == 'approved' ||
        normalized == 'verified' ||
        normalized == 'complete' ||
        normalized == 'completed';

    final bool isPending =
        normalized == 'pending' ||
        normalized == 'under review' ||
        normalized == 'under_review';

    final Color badgeColor;
    final Color textColor;
    final IconData icon;

    if (isApproved) {
      badgeColor = AppColors.success.withValues(alpha: 0.10);
      textColor = AppColors.success;
      icon = Icons.check_circle_outline_rounded;
    } else if (isPending) {
      badgeColor = AppColors.warning.withValues(alpha: 0.12);
      textColor = AppColors.warning;
      icon = Icons.schedule_rounded;
    } else {
      badgeColor = AppColors.error.withValues(alpha: 0.10);
      textColor = AppColors.error;
      icon = Icons.error_outline_rounded;
    }

    // Right-aligned badge
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 140),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value.isEmpty ? '—' : value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: textColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIVIDERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.divider.withValues(alpha: 0.7),
    );
  }

  Widget _buildInfoDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 43),
      child: Container(
        height: 1,
        color: AppColors.divider.withValues(alpha: 0.55),
      ),
    );
  }
}
