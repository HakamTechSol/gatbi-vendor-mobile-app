import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/courier_shipment_model.dart';


// ============================================================
//  COURIER SHIPMENT CARD (Vendor)
//  Handles both EMX + internal. Null-safe, terminal-aware.
// ============================================================

class CourierShipmentCard extends StatelessWidget {
  const CourierShipmentCard({super.key, required this.shipment});

  final VendorCourierShipmentModel shipment;

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
              label: 'Tracking №',
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

          // ── Booking failed neutral note ──
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
          if (shipment.isInternal &&
              (shipment.riderName ?? '').isNotEmpty) ...[
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
                      ),
                      if ((shipment.riderPhone ?? '').isNotEmpty)
                        Text(
                          shipment.riderPhone!,
                          style: AppTextStyles.bodySmall,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
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
                      emx
                          ? 'COD — EMX collects at door'
                          : 'Cash on delivery',
                      style: AppTextStyles.bodySmall,
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
        ],
      ),
    );
  }

  // ── small helpers ──

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

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool monospace = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              const SizedBox(height: 1),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.navy,
                  fontFamily: monospace ? 'monospace' : null,
                  letterSpacing: monospace ? 0.6 : null,
                ),
              ),
            ],
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