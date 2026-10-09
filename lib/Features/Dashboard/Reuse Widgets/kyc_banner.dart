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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 390;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withValues(alpha: 0.055),
                blurRadius: 24,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: isSmallScreen ? _buildSmallLayout() : _buildLargeLayout(),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LARGE LAYOUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLargeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildIcon(),
        const SizedBox(width: 12),
        Expanded(child: _buildContent()),
        const SizedBox(width: 14),
        _buildViewButton(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SMALL LAYOUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSmallLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(size: 42),
            const SizedBox(width: 11),
            Expanded(child: _buildContent()),
          ],
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: _buildViewButton(fullWidth: true),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildIcon({double size = 46}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Icon(
        Icons.verified_user_outlined,
        size: size * 0.48,
        color: AppColors.primary,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.navy,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(width: 7),
            _buildPendingBadge(),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 9.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PENDING BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPendingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Pending',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.warning,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VIEW BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildViewButton({bool fullWidth = false}) {
    return CustomButton(
      text: 'Complete KYC',
      type: CustomButtonType.outlined,
      onPressed: onView,
      width: fullWidth ? double.infinity : 108,
      height: 38,
      borderRadius: 11,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      textStyle: AppTextStyles.buttonOutlined.copyWith(
        color: AppColors.primary,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
