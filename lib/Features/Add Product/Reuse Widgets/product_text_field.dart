import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';

class ProductTextField extends StatelessWidget {
  const ProductTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.fillColor,
    this.borderRadius = 12,
    this.contentPadding,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.isPassword = false,
    this.isRequired = false,
    this.textDirection,
  });

  final TextEditingController controller;

  final String? label;
  final String? hintText;

  final IconData? prefixIcon;

  /// Text shown before the input value.
  ///
  /// Example:
  /// AED
  /// $
  final String? prefixText;

  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final FocusNode? focusNode;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final TextCapitalization textCapitalization;

  final List<TextInputFormatter>? inputFormatters;

  final bool autocorrect;
  final bool enableSuggestions;

  final TextAlign textAlign;

  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  final Color? prefixIconColor;
  final Color? suffixIconColor;

  final Color? fillColor;

  final double borderRadius;

  final EdgeInsetsGeometry? contentPadding;

  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  final bool isPassword;

  /// Shows `*` beside the label when true.
  final bool isRequired;

  /// Useful for Arabic fields.
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    String? displayLabel;

    if (label != null) {
      displayLabel = isRequired ? '$label *' : label;
    }

    return CustomTextField(
      controller: controller,
      label: displayLabel,
      hintText: hintText,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      isPassword: isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      textAlign: textAlign,
      textDirection: textDirection,
      textStyle: textStyle ?? AppTextStyles.authInput,
      hintStyle: hintStyle ?? AppTextStyles.authHint,
      labelStyle: labelStyle ?? AppTextStyles.formLabel,
      prefixIconColor: prefixIconColor ?? AppColors.inputIcon,
      suffixIconColor: suffixIconColor ?? AppColors.iconSecondary,
      fillColor: fillColor ?? AppColors.inputBackground,
      borderRadius: borderRadius,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      focusedBorderColor: focusedBorderColor ?? AppColors.inputFocusedBorder,
      errorBorderColor: errorBorderColor ?? AppColors.error,
    );
  }
}
