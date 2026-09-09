import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Order List/Models/order_model.dart';

class OrderStatusDropdown extends StatelessWidget {
  const OrderStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label = 'Order Status',
  });

  final OrderStatus value;
  final ValueChanged<OrderStatus>? onChanged;
  final bool enabled;
  final String label;

  static const List<OrderStatus> availableStatuses = [
    OrderStatus.pending,
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 7),

        DropdownButtonFormField<OrderStatus>(
          initialValue: value,
          onChanged: enabled
              ? (OrderStatus? newValue) {
                  if (newValue != null) {
                    onChanged?.call(newValue);
                  }
                }
              : null,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconSecondary,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? AppColors.white : AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          items: availableStatuses.map((status) {
            return DropdownMenuItem<OrderStatus>(
              value: status,
              child: Text(status.label),
            );
          }).toList(),
        ),
      ],
    );
  }
}
