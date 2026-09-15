import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import 'kyc_status_badge.dart';

class KycHeader extends StatelessWidget {
  const KycHeader({
    super.key,
    required this.status,
    this.onBack,
    this.title = 'KYC Verification',
    this.subtitle = 'Submit your legal documents for compliance review',
  });

  /// KYC verification status.
  final KycStatus status;

  /// Called when the user taps the back button.
  ///
  /// If null, the widget will automatically try to pop
  /// the current route.
  final VoidCallback? onBack;

  /// Header title.
  final String title;

  /// Header subtitle.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        // HEADER ROW
        // ============================================================
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --------------------------------------------------------
            // BACK BUTTON
            // --------------------------------------------------------
            _HeaderIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
            ),

            const SizedBox(width: 12),

            // --------------------------------------------------------
            // TITLE + SUBTITLE
            // --------------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineSmall,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ============================================================
        // KYC STATUS
        // ============================================================
        Align(
          alignment: Alignment.centerLeft,
          child: KycStatusBadge(status: status),
        ),
      ],
    );
  }
}

// ============================================================
// Header Icon Button
// ============================================================

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 21, color: AppColors.iconPrimary),
        ),
      ),
    );
  }
}
