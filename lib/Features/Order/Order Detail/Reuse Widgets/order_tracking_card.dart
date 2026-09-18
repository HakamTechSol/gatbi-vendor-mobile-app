import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/order_tracking_model.dart';

class OrderTrackingCard extends StatelessWidget {
  const OrderTrackingCard({super.key, required this.tracking});

  final VendorOrderTrackingModel tracking;

  @override
  Widget build(BuildContext context) {
    final trackingNumber = tracking.trackingNumber?.trim();
    final carrier = tracking.carrier?.trim();

    // ============================================================
    // Hide card when tracking data is incomplete
    // ============================================================

    if (trackingNumber == null ||
        trackingNumber.isEmpty ||
        carrier == null ||
        carrier.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER
            // ======================================================
            const _Header(),

            const SizedBox(height: 16),

            // ======================================================
            // TRACKING SUMMARY
            // ======================================================
            _TrackingSummary(trackingNumber: trackingNumber, carrier: carrier),

            const SizedBox(height: 14),

            // ======================================================
            // TRACKING NUMBER
            // ======================================================
            _InfoRow(
              icon: Icons.tag_outlined,
              label: 'Tracking Number',
              value: trackingNumber,
            ),

            const SizedBox(height: 10),

            // ======================================================
            // CARRIER
            // ======================================================
            _InfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Carrier',
              value: carrier,
            ),

            // ======================================================
            // TRACKING URL
            // ======================================================
            if (_hasValue(tracking.trackingUrl)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.link_outlined,
                label: 'Tracking URL',
                value: tracking.trackingUrl!.trim(),
              ),
            ],

            // ======================================================
            // ESTIMATED DELIVERY
            // ======================================================
            if (_hasValue(tracking.estimatedDelivery)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Estimated Delivery',
                value: tracking.estimatedDelivery!.trim(),
              ),
            ],

            // ======================================================
            // LAST LOCATION
            // ======================================================
            if (_hasValue(tracking.lastLocation)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Last Location',
                value: tracking.lastLocation!.trim(),
              ),
            ],

            // ======================================================
            // LAST UPDATE
            // ======================================================
            if (_hasValue(tracking.lastUpdate)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.update_outlined,
                label: 'Last Update',
                value: tracking.lastUpdate!.trim(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            size: 21,
            color: AppColors.white,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Tracking',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Shipment and delivery details',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TRACKING SUMMARY
// ============================================================================

class _TrackingSummary extends StatelessWidget {
  const _TrackingSummary({required this.trackingNumber, required this.carrier});

  final String trackingNumber;
  final String carrier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ========================================================
          // Tracking Icon
          // ========================================================
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 11),

          // ========================================================
          // Tracking Information
          // ========================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipment',
                  style: AppTextStyles.orderMeta.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  carrier,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // Active Status
          // ========================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  'Active',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INFO ROW
// ============================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ========================================================
          // Icon
          // ========================================================
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),

          const SizedBox(width: 10),

          // ========================================================
          // Label
          // ========================================================
          Expanded(
            flex: 5,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.orderMeta.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // Value
          // ========================================================
          Expanded(
            flex: 6,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
