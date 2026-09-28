import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutListHeader extends StatelessWidget {
  const PayoutListHeader({
    super.key,
    this.onBack,
    this.onRequestPayout,
    this.showRequestButton = true,
    this.isRequestEnabled = true,
  });

  final VoidCallback? onBack;
  final VoidCallback? onRequestPayout;
  final bool showRequestButton;
  final bool isRequestEnabled;

  // ============================================================
  // Back
  // ============================================================

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!.call();
      return;
    }

    Navigator.of(context).maybePop();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // ======================================================
        // Very Small Screens
        // ======================================================

        if (width < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBackButton(context),

                  const SizedBox(width: 10),

                  Expanded(child: _buildTitle()),
                ],
              ),

              if (showRequestButton) ...[
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: _buildRequestButton(fullWidth: true),
                ),
              ],
            ],
          );
        }

        // ======================================================
        // Normal / Wide Screens
        // ======================================================

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackButton(context),

            const SizedBox(width: 12),

            Expanded(child: _buildTitle()),

            if (showRequestButton) ...[
              const SizedBox(width: 12),

              _buildRequestButton(fullWidth: false),
            ],
          ],
        );
      },
    );
  }

  // ============================================================
  // Back Button
  // ============================================================

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleBack(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 22,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payouts',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Manage and track your payouts',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Request Button
  // ============================================================

  Widget _buildRequestButton({required bool fullWidth}) {
    final button = Material(
      color: isRequestEnabled ? AppColors.primary : AppColors.border,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isRequestEnabled ? onRequestPayout : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: fullWidth
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                Icons.add_rounded,
                size: 19,
                color: isRequestEnabled
                    ? AppColors.white
                    : AppColors.textTertiary,
              ),

              const SizedBox(width: 5),

              Text(
                'Request',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: isRequestEnabled
                      ? AppColors.white
                      : AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Give the button a finite width on normal screens.
    if (!fullWidth) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 96, maxWidth: 120),
        child: button,
      );
    }

    return button;
  }
}
