import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';

class EventDiscountCard extends StatelessWidget {
  const EventDiscountCard({super.key, required this.event});

  final EventDetailItemModel event;

  @override
  Widget build(BuildContext context) {
    final discount = event.minDiscountPercentage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildBackgroundDecorations(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDiscountIcon(),
              const SizedBox(width: 14),
              Expanded(child: _buildContent(discount)),
              const SizedBox(width: 12),
              _buildPercentage(discount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(num? discount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Discount',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textOnPrimarySecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          discount != null
              ? 'Offer at least ${_formatPercentage(discount)}% off'
              : 'Discount information unavailable',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Apply the minimum discount required for this event.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textOnPrimarySecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withOpacity(0.18)),
      ),
      child: const Icon(
        Icons.local_offer_rounded,
        color: AppColors.white,
        size: 24,
      ),
    );
  }

  Widget _buildPercentage(num? discount) {
    return Container(
      constraints: const BoxConstraints(minWidth: 68),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            discount != null ? _formatPercentage(discount) : '—',
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 25,
              height: 1,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '% OFF',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.purple,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -45,
              right: -30,
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -45,
              child: Container(
                width: 135,
                height: 135,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
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
