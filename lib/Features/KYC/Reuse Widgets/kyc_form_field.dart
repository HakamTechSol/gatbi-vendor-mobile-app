import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../Core/Custom Widgets/custom_textfield.dart';

class KycFormField extends StatelessWidget {
  const KycFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.fillColor,
    this.textStyle,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final int maxLines;
  final int? minLines;

  final bool readOnly;

  final VoidCallback? onTap;

  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  final List<TextInputFormatter>? inputFormatters;

  final Color? fillColor;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onTap: onTap,
      suffixIcon: suffixIcon,
      validator: validator,
      inputFormatters: inputFormatters,
      fillColor: fillColor,
      textStyle: textStyle,
    );
  }
}