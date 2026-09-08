import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ProductDropdownItem<T> {
  const ProductDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final bool enabled;
}

class ProductDropdownField<T> extends StatelessWidget {
  const ProductDropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hintText = 'Select an option',
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.prefixIconColor,
    this.fillColor,
    this.borderRadius = 12,
    this.contentPadding,
    this.menuMaxHeight = 320,
    this.emptyMessage = 'No options available',
  });

  final List<ProductDropdownItem<T>> items;

  final T? value;

  final ValueChanged<T?>? onChanged;

  final String? label;

  final String hintText;

  final String? Function(T?)? validator;

  final bool enabled;

  final IconData? prefixIcon;

  final Color? prefixIconColor;

  final Color? fillColor;

  final double borderRadius;

  final EdgeInsetsGeometry? contentPadding;

  final double menuMaxHeight;

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final selectedItem = _findSelectedItem();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.formLabel),
          const SizedBox(height: 8),
        ],

        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,

          onChanged: enabled ? onChanged : null,

          validator: validator,

          menuMaxHeight: menuMaxHeight,

          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled ? AppColors.iconSecondary : AppColors.iconMuted,
            size: 22,
          ),

          style: AppTextStyles.authInput,

          dropdownColor: AppColors.surface,

          decoration: InputDecoration(
            filled: true,

            fillColor: enabled
                ? fillColor ?? AppColors.inputBackground
                : AppColors.inputDisabledBackground,

            hintText: hintText,

            hintStyle: AppTextStyles.authHint,

            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 21,
                    color: prefixIconColor ?? AppColors.inputIcon,
                  )
                : null,

            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

            border: _buildBorder(AppColors.border, 1),

            enabledBorder: _buildBorder(AppColors.border, 1),

            focusedBorder: _buildBorder(AppColors.inputFocusedBorder, 1.5),

            errorBorder: _buildBorder(AppColors.error, 1),

            focusedErrorBorder: _buildBorder(AppColors.error, 1.5),

            disabledBorder: _buildBorder(AppColors.border, 1),

            errorStyle: AppTextStyles.formError,
          ),

          items: items.isEmpty
              ? null
              : items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item.value,
                    enabled: item.enabled,
                    child: _buildMenuItem(item),
                  );
                }).toList(),

          selectedItemBuilder: items.isEmpty
              ? null
              : (context) {
                  return items.map((item) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.authInput,
                      ),
                    );
                  }).toList();
                },
        ),

        if (items.isEmpty && enabled) ...[
          const SizedBox(height: 6),
          Text(emptyMessage, style: AppTextStyles.formHelper),
        ],

        if (selectedItem != null && selectedItem.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(selectedItem.subtitle!, style: AppTextStyles.formHelper),
        ],
      ],
    );
  }

  ProductDropdownItem<T>? _findSelectedItem() {
    for (final item in items) {
      if (item.value == value) {
        return item;
      }
    }

    return null;
  }

  Widget _buildMenuItem(ProductDropdownItem<T> item) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: item.enabled
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),

              if (item.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  item.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
