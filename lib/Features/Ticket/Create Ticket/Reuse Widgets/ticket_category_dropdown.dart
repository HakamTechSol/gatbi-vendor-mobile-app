import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketCategoryDropdown extends StatelessWidget {
  const TicketCategoryDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.validator,
  });

  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool enabled;
  final String? Function(String?)? validator;

  static const List<String> categories = [
    'General',
    'Order',
    'Product',
    'Payment',
    'Technical',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      style: AppTextStyles.bodyMedium,
      dropdownColor: AppColors.surface,
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Select ticket category',
        prefixIcon: const Icon(
          Icons.category_outlined,
          color: AppColors.iconSecondary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: AppTextStyles.formLabel,
        hintStyle: AppTextStyles.authHint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category, style: AppTextStyles.bodyMedium),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
    );
  }
}
