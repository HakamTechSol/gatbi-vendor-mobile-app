import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class KycBanner extends StatelessWidget {
  const KycBanner({
    super.key,
    required this.isPending,
    this.onView,
    this.title = 'KYC verification is pending',
    this.message =
        'Complete your KYC verification to unlock all vendor features.',
  });

  /// Whether KYC verification is currently pending.
  final bool isPending;

  /// Opens the KYC verification screen.
  final VoidCallback? onView;

  /// Banner title.
  final String title;

  /// Banner description.
  final String message;

  @override
  Widget build(BuildContext context) {
    if (!isPending) {
      return const SizedBox.shrink();
    }

    return _buildBanner(context);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BANNER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBanner(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isSmallScreen = width < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryShadow.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(isSmallScreen),

          SizedBox(width: isSmallScreen ? 10 : 12),

          Expanded(
            child: _buildContent(isSmallScreen),
          ),

          const SizedBox(width: 8),

          _buildViewButton(isSmallScreen),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildIcon(bool isSmallScreen) {
    final iconSize = isSmallScreen ? 38.0 : 42.0;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.verified_user_outlined,
        size: isSmallScreen ? 19 : 21,
        color: AppColors.primary,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.navy,
            fontSize: isSmallScreen ? 11.5 : 12.5,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 9 : 9.5,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VIEW BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildViewButton(bool isSmallScreen) {
    return CustomButton(
      text: 'View',
      type: CustomButtonType.outlined,
      onPressed: onView,
      width: isSmallScreen ? 54 : 60,
      height: isSmallScreen ? 32 : 34,
      borderRadius: 8,
      padding: EdgeInsets.zero,
      textStyle: AppTextStyles.buttonOutlined.copyWith(
        color: AppColors.primary,
        fontSize: isSmallScreen ? 9 : 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}