import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class OrderStatusDropdown extends StatelessWidget {
  const OrderStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label = 'Order Status',
  });

  final String value;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String label;

  static const List<String> availableStatuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // VALUE ALREADY COMES FROM PARENT
    //
    // OrderDetailScreen already calculates the NEXT status.
    //
    // Example:
    // API status = shipped
    // Parent value = delivered
    //
    // So yahan dobara next status calculate nahi karna.
    // ============================================================

    final safeValue = availableStatuses.contains(value)
        ? value
        : availableStatuses.first;

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

        DropdownButtonFormField<String>(
          initialValue: safeValue,
          onChanged: enabled
              ? (String? newValue) {
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
            return DropdownMenuItem<String>(
              value: status,
              child: Text(_statusLabel(status)),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS LABEL
  // ============================================================

  String _statusLabel(String status) {
    return status
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
        )
        .join(' ');
  }
}
