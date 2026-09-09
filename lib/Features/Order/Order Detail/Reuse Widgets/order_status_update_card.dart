import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Order List/Models/order_model.dart';
import 'order_status_dropdown.dart';
import 'order_status_fields.dart';

class OrderStatusUpdateCard extends StatelessWidget {
  const OrderStatusUpdateCard({
    super.key,
    required this.status,
    required this.onStatusChanged,
    required this.onUpdate,
    this.trackingController,
    this.carrierController,
    this.noteController,
    this.isLoading = false,
  });

  final OrderStatus status;
  final ValueChanged<OrderStatus> onStatusChanged;
  final VoidCallback? onUpdate;

  final TextEditingController? trackingController;
  final TextEditingController? carrierController;
  final TextEditingController? noteController;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final showTrackingFields =
        status == OrderStatus.shipped || status == OrderStatus.delivered;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
          Row(
            children: [
              const Icon(
                Icons.sync_alt_rounded,
                size: 20,
                color: AppColors.iconPrimary,
              ),
              const SizedBox(width: 9),
              Text(
                'Update Order Status',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          OrderStatusDropdown(value: status, onChanged: onStatusChanged),

          const SizedBox(height: 14),

          OrderStatusFields(
            trackingController: trackingController,
            carrierController: carrierController,
            noteController: noteController,
            showTrackingFields: showTrackingFields,
            enabled: !isLoading,
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onUpdate,
              icon: isLoading
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: Text(isLoading ? 'Updating...' : 'Update Order Status'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: AppTextStyles.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
