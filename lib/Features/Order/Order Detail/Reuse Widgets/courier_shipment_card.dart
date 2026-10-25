import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/courier_shipment_model.dart';

// ============================================================
//  COURIER SHIPMENT CARD (Vendor)
//  Handles both EMX + internal. Null-safe, terminal-aware.
// ============================================================

class CourierShipmentCard extends StatelessWidget {
  const CourierShipmentCard({
    super.key,
    required this.shipment,
    this.onRetryPickup,
    this.isRetryLoading = false,
  });

  final VendorCourierShipmentModel shipment;

  final VoidCallback? onRetryPickup;

  final bool isRetryLoading;

  @override
  Widget build(BuildContext context) {
    final emx = shipment.isEmx;

    final status = (shipment.status ?? 'pending').trim();
    final sColor = _statusColor(status);
    final sLabel = _statusLabel(status);

    final awb = shipment.awbNumber ?? '';
    final carrierStatus = shipment.safeCarrierStatus;
    final codAmount = (shipment.codAmount ?? 0).toDouble();
    final codCollected = shipment.codCollected;

    final pickupScheduledAt = shipment.pickupScheduledAt ?? '';
    final pickedUpAt = shipment.pickedUpAt ?? '';
    final deliveredAt = shipment.deliveredAt ?? '';
    final receiverName = shipment.receiverName ?? '';

    final hasTimeline =
        pickupScheduledAt.isNotEmpty ||
        pickedUpAt.isNotEmpty ||
        deliveredAt.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.backgroundSecondary),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  emx
                      ? Icons.local_post_office_rounded
                      : Icons.sports_motorsports_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shipment.displayProvider,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((shipment.shipmentNo ?? '').isNotEmpty)
                      Text(
                        shipment.shipmentNo!,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _badge(sLabel, sColor),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.backgroundSecondary),
          const SizedBox(height: 12),

          // ── EMX-specific: warehouse note ──
          if (emx) ...[
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'EMX (Emirates Post) will collect this parcel — '
                      'keep it packed & ready.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // ── AWB + Carrier status ──
          if (awb.isNotEmpty)
            _infoRow(
              icon: Icons.qr_code_2_rounded,
              label: 'Tracking No',
              value: awb,
              monospace: true,
            ),

          if (carrierStatus.isNotEmpty && !shipment.isBookingFailed) ...[
            const SizedBox(height: 8),
            _infoRow(
              icon: Icons.info_outline_rounded,
              label: 'Last update',
              value: carrierStatus,
            ),
          ],

          // ── Booking failed neutral note + Retry button ──
          if (shipment.isBookingFailed) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.30),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.hourglass_top_rounded,
                    size: 15,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Booking issue — support has been notified. '
                      'AWB will appear on retry.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.navy,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (onRetryPickup != null) ...[
              const SizedBox(height: 10),
              CustomButton(
                text: 'Retry Pickup',
                icon: Icons.refresh_rounded,
                height: 44,
                borderRadius: 10,
                isLoading: isRetryLoading,
                isEnabled: !isRetryLoading,
                onPressed: onRetryPickup,
                gradient: const LinearGradient(
                  colors: [AppColors.warning, AppColors.warning],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],

          // ── Failure reason (internal, if any) ──
          if ((shipment.failureReason ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoRow(
              icon: Icons.error_outline_rounded,
              label: 'Failure reason',
              value: shipment.failureReason!,
              valueColor: AppColors.error,
            ),
          ],

          // ── Rider (internal only) ──
          if (shipment.isInternal && (shipment.riderName ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment.riderName!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if ((shipment.riderPhone ?? '').isNotEmpty)
                        Text(
                          shipment.riderPhone!,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // ── COD row ──
          if (codAmount > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      emx ? 'COD — EMX collects at door' : 'Cash on delivery',
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'AED ${codAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── COD collected info (post-delivery) ──
          if (codCollected != null && codCollected > 0) ...[
            const SizedBox(height: 8),
            _infoRow(
              icon: Icons.check_circle_outline_rounded,
              label: 'COD collected',
              value: 'AED ${codCollected.toStringAsFixed(2)}',
              valueColor: AppColors.success,
            ),
          ],

          // ── Shipment Timeline (pickup → delivered) ──
          if (hasTimeline || receiverName.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.backgroundSecondary),
            const SizedBox(height: 12),
            _timelineSection(
              pickupScheduledAt: pickupScheduledAt,
              pickedUpAt: pickedUpAt,
              deliveredAt: deliveredAt,
              receiverName: receiverName,
            ),
          ],
        ],
      ),
    );
  }

  // ── small helpers ──

  Widget _timelineSection({
    required String pickupScheduledAt,
    required String pickedUpAt,
    required String deliveredAt,
    required String receiverName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipment Timeline',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (pickupScheduledAt.isNotEmpty)
          _timelineRow(
            icon: Icons.event_available_outlined,
            label: 'Pickup scheduled',
            value: pickupScheduledAt,
          ),
        if (pickedUpAt.isNotEmpty) ...[
          if (pickupScheduledAt.isNotEmpty) const SizedBox(height: 6),
          _timelineRow(
            icon: Icons.inventory_2_outlined,
            label: 'Picked up',
            value: pickedUpAt,
          ),
        ],
        if (deliveredAt.isNotEmpty) ...[
          if (pickupScheduledAt.isNotEmpty || pickedUpAt.isNotEmpty)
            const SizedBox(height: 6),
          _timelineRow(
            icon: Icons.check_circle_outline_rounded,
            label: 'Delivered',
            value: deliveredAt,
            valueColor: AppColors.success,
            iconColor: AppColors.success,
          ),
        ],
        if (receiverName.isNotEmpty) ...[
          const SizedBox(height: 6),
          _timelineRow(
            icon: Icons.person_pin_circle_outlined,
            label: 'Received by',
            value: receiverName,
          ),
        ],
      ],
    );
  }

  // 🔥 FIXED: Timeline Row (Value Right Aligned, 1 Line)
  Widget _timelineRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    Color? iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: iconColor ?? AppColors.textSecondary),
        const SizedBox(width: 7),
        // Label
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        // Value (Right Aligned & Ellipsis)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 FIXED: Info Row (Value Right Aligned, 1 Line)
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool monospace = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 7),
        // Label
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(width: 12),
        // Value (Right Aligned & Ellipsis)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.navy,
              fontFamily: monospace ? 'monospace' : null,
              letterSpacing: monospace ? 0.6 : null,
            ),
          ),
        ),
      ],
    );
  }

  // ── status → color / label (§4 of guide) ──
  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF16A34A);
      case 'picked_up':
      case 'in_transit':
        return const Color(0xFF0891B2);
      case 'out_for_delivery':
        return const Color(0xFF0EA5E9);
      case 'pickup_scheduled':
        return const Color(0xFF6366F1);
      case 'rider_assigned':
        return const Color(0xFF7C3AED);
      case 'pending':
        return const Color(0xFFD97706);
      case 'failed':
        return const Color(0xFFDC2626);
      case 'returned':
        return const Color(0xFF78350F);
      case 'cancelled':
        return const Color(0xFF6B7280);
      default:
        return AppColors.textMuted;
    }
  }

  static String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Waiting';
      case 'pickup_scheduled':
        return 'Scheduled';
      case 'rider_assigned':
        return 'Assigned';
      case 'picked_up':
      case 'in_transit':
        return 'In Transit';
      case 'out_for_delivery':
        return 'Arriving';
      case 'delivered':
        return 'Delivered';
      case 'failed':
        return 'Failed';
      case 'returned':
        return 'Returned';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.isEmpty ? 'Unknown' : status;
    }
  }
}
