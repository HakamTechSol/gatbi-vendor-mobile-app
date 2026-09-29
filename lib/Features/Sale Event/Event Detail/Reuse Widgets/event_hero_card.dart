import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';
import 'event_status_badge.dart';

class EventHeroCard extends StatelessWidget {
  const EventHeroCard({super.key, required this.event});

  final EventDetailItemModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildBanner(context), _buildEventSummary()],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final desktopBanner = event.bannerUrl?.trim();
    final mobileBanner = event.bannerMobileUrl?.trim();

    return AspectRatio(
      aspectRatio: 16 / 8.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 500;

          final imageUrl = isCompact
              ? (mobileBanner?.isNotEmpty == true
                    ? mobileBanner
                    : desktopBanner)
              : (desktopBanner?.isNotEmpty == true
                    ? desktopBanner
                    : mobileBanner);

          if (imageUrl == null || imageUrl.isEmpty) {
            return _buildBannerPlaceholder();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildBannerPlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _buildBannerLoading();
                },
              ),

              // ----------------------------------------------------
              // Bottom gradient
              // ----------------------------------------------------
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x66000000)],
                  ),
                ),
              ),

              // ----------------------------------------------------
              // Event badge
              // ----------------------------------------------------
              Positioned(
                top: 14,
                left: 14,
                child: _EventImageBadge(
                  text: 'EVENT',
                  icon: Icons.local_activity_outlined,
                ),
              ),

              // ----------------------------------------------------
              // Discount badge
              // ----------------------------------------------------
              if (event.minDiscountPercentage != null)
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: _DiscountOverlayBadge(
                    percentage: event.minDiscountPercentage!,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBannerPlaceholder() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -35,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.event_available_rounded,
              size: 58,
              color: AppColors.textOnPrimarySecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerLoading() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.softGradient),
      child: const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildEventSummary() {
    final name = event.name?.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name?.isNotEmpty == true ? name! : 'Event Details',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              EventStatusBadge(status: event.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _buildDateRange(),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _buildDateRange() {
    final start = event.startDate?.trim();
    final end = event.endDate?.trim();

    if (start?.isNotEmpty == true && end?.isNotEmpty == true) {
      if (start == end) {
        return _formatDate(start!);
      }

      return '${_formatDate(start!)} – ${_formatDate(end!)}';
    }

    if (start?.isNotEmpty == true) {
      return _formatDate(start!);
    }

    if (end?.isNotEmpty == true) {
      return _formatDate(end!);
    }

    return 'Event dates unavailable';
  }

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);

    if (parsed == null) {
      return value;
    }

    return '${_monthName(parsed.month)} '
        '${parsed.day}, '
        '${parsed.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }
}

// ============================================================
// IMAGE BADGE
// ============================================================

class _EventImageBadge extends StatelessWidget {
  const _EventImageBadge({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.navy.withOpacity(0.78),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.white),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyles.statusBadge.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DISCOUNT OVERLAY
// ============================================================

class _DiscountOverlayBadge extends StatelessWidget {
  const _DiscountOverlayBadge({required this.percentage});

  final num percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '${_formatPercentage(percentage)}% min discount',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPercentage(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }
}
