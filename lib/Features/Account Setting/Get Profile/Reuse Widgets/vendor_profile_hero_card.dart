import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/get_profile_model.dart';
import 'vendor_profile_avatar.dart';

class VendorProfileHeroCard extends StatelessWidget {
  const VendorProfileHeroCard({super.key, required this.merchant});

  final VendorSettingsMerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ==========================================================
          // DECORATIVE CIRCLES
          // ==========================================================
          Positioned(
            top: -55,
            right: -40,
            child: _DecorationCircle(size: 150, opacity: 0.10),
          ),

          Positioned(
            bottom: -65,
            left: -45,
            child: _DecorationCircle(size: 140, opacity: 0.08),
          ),

          // ==========================================================
          // CONTENT
          // ==========================================================
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VendorProfileAvatar(
                imageUrl: merchant.logo,
                name: merchant.name,
                size: 94,
              ),

              const SizedBox(height: 16),

              // ======================================================
              // MERCHANT NAME
              // ======================================================
              Text(
                _displayValue(merchant.name, fallback: 'Merchant'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              // ======================================================
              // EMAIL
              // ======================================================
              if (_hasValue(merchant.email))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 15,
                      color: AppColors.textOnPrimarySecondary,
                    ),

                    const SizedBox(width: 6),

                    Flexible(
                      child: Text(
                        merchant.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textOnPrimarySecondary,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 14),

              // ======================================================
              // STATUS
              // ======================================================
              _HeroStatusBadge(status: merchant.status),
            ],
          ),
        ],
      ),
    );
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  String _displayValue(String? value, {required String fallback}) {
    if (!_hasValue(value)) {
      return fallback;
    }

    return value!.trim();
  }
}

// ================================================================
// DECORATION CIRCLE
// ================================================================

class _DecorationCircle extends StatelessWidget {
  const _DecorationCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: opacity),
      ),
    );
  }
}

// ================================================================
// HERO STATUS BADGE
// ================================================================

class _HeroStatusBadge extends StatelessWidget {
  const _HeroStatusBadge({this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final normalized = status?.trim().toLowerCase();

    final label = _getLabel(normalized);
    final icon = _getIcon(normalized);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.statusBadge.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  String _getLabel(String? value) {
    switch (value) {
      case 'approved':
        return 'Approved';

      case 'pending':
        return 'Pending';

      case 'rejected':
        return 'Rejected';

      case 'suspended':
        return 'Suspended';

      case 'active':
        return 'Active';

      default:
        if (value == null || value.isEmpty) {
          return 'Status unavailable';
        }

        return _capitalize(value);
    }
  }

  IconData _getIcon(String? value) {
    switch (value) {
      case 'approved':
      case 'active':
        return Icons.verified_rounded;

      case 'pending':
        return Icons.schedule_rounded;

      case 'rejected':
        return Icons.cancel_outlined;

      case 'suspended':
        return Icons.block_rounded;

      default:
        return Icons.info_outline_rounded;
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
