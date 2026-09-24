import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class MyProductsKycCard extends StatelessWidget {
  const MyProductsKycCard({
    super.key,
    required this.status,
    required this.statusLabel,
    required this.onPressed,
  });

  // ============================================================
  // PARAMETERS
  // ============================================================

  final String? status;

  final String? statusLabel;

  final VoidCallback onPressed;

  // ============================================================
  // NORMALIZED STATUS
  // ============================================================

  String get _normalizedStatus {
    return (status ?? '').trim().toLowerCase();
  }

  String get _normalizedStatusLabel {
    return (statusLabel ?? '').trim().toLowerCase();
  }

  // ============================================================
  // STATUS HELPERS
  // ============================================================

  bool get isRejected {
    switch (_normalizedStatus) {
      case 'rejected':
      case 'declined':
      case 'denied':
        return true;

      default:
        return false;
    }
  }

  bool get isApproved {
    switch (_normalizedStatus) {
      case 'approved':
      case 'verified':
      case 'accepted':
        return true;

      default:
        return false;
    }
  }

  bool get isUnderReview {
    switch (_normalizedStatus) {
      case 'under_review':
      case 'underreview':
      case 'review':
      case 'in_review':
      case 'in review':
        return true;

      default:
        return false;
    }
  }

  bool get isNotSubmitted {
    switch (_normalizedStatusLabel) {
      case 'not_submitted':
      case 'not-submitted':
      case 'not submitted':
      case 'not submitted yet':
      case 'not submitted yet.':
        return true;

      default:
        return false;
    }
  }

  bool get isPending {
    return _normalizedStatus == 'pending';
  }

  // ============================================================
  // TITLE
  // ============================================================

  String get title {
    if (isRejected) {
      return 'KYC Verification Required';
    }

    if (isUnderReview) {
      return 'KYC Verification Under Review';
    }

    if (isPending) {
      return 'KYC Verification Pending';
    }

    if (isNotSubmitted) {
      return 'Complete Your KYC Verification';
    }

    return 'Complete Your KYC Verification';
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  String get description {
    if (isRejected) {
      return 'Your KYC verification was rejected. Please review your information and update your documents.';
    }

    if (isUnderReview) {
      return 'Your KYC documents are currently being reviewed. We will update your verification status once the review is complete.';
    }

    if (isPending) {
      return 'Your KYC verification is pending. Please complete your verification to continue managing your vendor account.';
    }

    if (isNotSubmitted) {
      return 'Complete your KYC verification to unlock vendor features and continue managing your products.';
    }

    return 'Complete your KYC verification to unlock vendor features and continue managing your products.';
  }

  // ============================================================
  // BUTTON TEXT
  // ============================================================

  String get buttonText {
    if (isRejected) {
      return 'Update KYC';
    }

    if (isUnderReview) {
      return 'View KYC';
    }

    if (isPending) {
      return 'View KYC';
    }

    return 'Complete KYC';
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  String get badgeText {
    if (isRejected) {
      return 'Rejected';
    }

    if (isUnderReview) {
      return 'Under Review';
    }

    if (isPending) {
      return 'KYC Pending';
    }

    if (isNotSubmitted) {
      return 'Not Submitted';
    }

    return 'KYC Pending';
  }

  // ============================================================
  // BADGE COLORS
  // ============================================================

  Color get badgeBackgroundColor {
    if (isRejected) {
      return AppColors.error.withValues(alpha: 0.08);
    }

    if (isUnderReview) {
      return Colors.orange.withValues(alpha: 0.10);
    }

    return AppColors.primaryLight;
  }

  Color get badgeTextColor {
    if (isRejected) {
      return AppColors.error;
    }

    if (isUnderReview) {
      return Colors.orange.shade700;
    }

    return AppColors.primary;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // Approved KYC should not show this card.
    // ----------------------------------------------------------

    if (isApproved) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // TOP SECTION
          // ====================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // ICON
              // ------------------------------------------------
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // ------------------------------------------------
              // TITLE + DESCRIPTION
              // ------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),

                    const SizedBox(height: 5),

                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ====================================================
          // BOTTOM SECTION
          // ====================================================

          //
          // IMPORTANT:
          // Do NOT put an unconstrained ElevatedButton directly
          // inside this Row.
          //
          // The app theme may contain:
          //
          // minimumSize: Size(double.infinity, ...)
          //
          // which causes:
          //
          // BoxConstraints(w=Infinity, ...)
          //
          // Therefore the button is wrapped inside SizedBox
          // with an explicit finite width.
          //
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              // ------------------------------------------------
              // Desktop / tablet
              // ------------------------------------------------

              if (availableWidth >= 500) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ------------------------------------------
                    // STATUS BADGE
                    // ------------------------------------------
                    _buildStatusBadge(),

                    const Spacer(),

                    // ------------------------------------------
                    // BUTTON
                    // ------------------------------------------
                    SizedBox(width: 150, height: 44, child: _buildKycButton()),
                  ],
                );
              }

              // ------------------------------------------------
              // Small mobile width
              // ------------------------------------------------

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------------------------------------
                  // STATUS BADGE
                  // --------------------------------------------
                  _buildStatusBadge(),

                  const SizedBox(height: 12),

                  // --------------------------------------------
                  // BUTTON
                  // --------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: _buildKycButton(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badgeText,
        style: AppTextStyles.caption.copyWith(
          color: badgeTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // KYC BUTTON
  // ============================================================

  Widget _buildKycButton() {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
      label: Text(buttonText, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: ElevatedButton.styleFrom(
        // ------------------------------------------------------
        // Explicitly override any global infinity width.
        // ------------------------------------------------------
        minimumSize: const Size(0, 44),

        fixedSize: const Size.fromHeight(44),

        backgroundColor: AppColors.primary,

        foregroundColor: AppColors.white,

        elevation: 0,

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      ),
    );
  }
}
