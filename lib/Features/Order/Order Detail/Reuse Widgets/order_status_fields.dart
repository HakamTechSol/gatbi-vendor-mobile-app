import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Theme/app_colors.dart';

class OrderStatusFields extends StatelessWidget {
  const OrderStatusFields({
    super.key,
    this.trackingController,
    this.carrierController,
    this.noteController,
    this.showTrackingFields = false,
    this.enabled = true,
  });

  final TextEditingController? trackingController;
  final TextEditingController? carrierController;
  final TextEditingController? noteController;

  final bool showTrackingFields;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTrackingFields) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: trackingController ?? TextEditingController(),
                  label: 'Tracking Number',
                  hintText: 'Enter tracking number',
                  prefixIcon: Icons.local_shipping_outlined,
                  enabled: enabled,
                  borderRadius: 10,
                  prefixIconColor: AppColors.iconSecondary,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: CustomTextField(
                  controller: carrierController ?? TextEditingController(),
                  label: 'Carrier',
                  hintText: 'e.g. DHL',
                  prefixIcon: Icons.business_outlined,
                  enabled: enabled,
                  borderRadius: 10,
                  prefixIconColor: AppColors.iconSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
        ],

        CustomTextField(
          controller: noteController ?? TextEditingController(),
          label: 'Note',
          hintText: 'Add a note about this status update...',
          enabled: enabled,
          maxLines: 3,
          minLines: 3,
          borderRadius: 10,
          prefixIconColor: AppColors.iconSecondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      ],
    );
  }
}
