import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import 'order_status_dropdown.dart';
import 'order_status_fields.dart';

class OrderStatusUpdateCard extends StatefulWidget {
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

  final String status;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback? onUpdate;

  final TextEditingController? trackingController;
  final TextEditingController? carrierController;
  final TextEditingController? noteController;

  final bool isLoading;

  @override
  State<OrderStatusUpdateCard> createState() => _OrderStatusUpdateCardState();
}

class _OrderStatusUpdateCardState extends State<OrderStatusUpdateCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get _showTrackingFields =>
      widget.status.trim().toLowerCase() == 'shipped';

  void _handleUpdate() {
    // Tracking + Carrier validation sirf SHIPPED par apply hogi.
    if (_showTrackingFields) {
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }
    }

    widget.onUpdate?.call();
  }

  String? _validateTracking(String? value) {
    final tracking = value?.trim() ?? '';

    if (tracking.isEmpty) {
      return 'Tracking number is required';
    }

    if (tracking.length < 3) {
      return 'Tracking number must be at least 3 characters';
    }

    if (tracking.length > 100) {
      return 'Tracking number must not exceed 100 characters';
    }

    return null;
  }

  String? _validateCarrier(String? value) {
    final carrier = value?.trim() ?? '';

    if (carrier.isEmpty) {
      return 'Carrier is required';
    }

    if (carrier.length < 2) {
      return 'Carrier must be at least 2 characters';
    }

    if (carrier.length > 100) {
      return 'Carrier must not exceed 100 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Form(
        key: _formKey,
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

            // ============================================================
            // Status Dropdown
            // ============================================================
            OrderStatusDropdown(
              value: widget.status,
              onChanged: widget.onStatusChanged,
              enabled: !widget.isLoading,
            ),

            const SizedBox(height: 14),

            // ============================================================
            // Status Fields
            // ============================================================
            OrderStatusFields(
              trackingController: widget.trackingController,
              carrierController: widget.carrierController,
              noteController: widget.noteController,
              showTrackingFields: _showTrackingFields,
              enabled: !widget.isLoading,

              // Agar OrderStatusFields mein validators available hain
              // to ye dono pass kar dein.
              trackingValidator: _showTrackingFields ? _validateTracking : null,
              carrierValidator: _showTrackingFields ? _validateCarrier : null,
            ),

            const SizedBox(height: 16),

            // ============================================================
            // Update Button
            // ============================================================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.isLoading ? null : _handleUpdate,
                icon: widget.isLoading
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text(
                  widget.isLoading ? 'Updating...' : 'Update Order Status',
                ),
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
      ),
    );
  }
}
