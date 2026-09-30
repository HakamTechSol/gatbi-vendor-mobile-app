import 'package:flutter/material.dart';

import '../../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';

class VariantColorField extends StatelessWidget {
  const VariantColorField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onPickColor,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onPickColor;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller,
          focusNode: focusNode,
          label: 'Color Code',
          hintText: '#000000',
          prefixIcon: Icons.palette_outlined,
          prefixIconColor: AppColors.primary,
          suffixIcon: _buildColorPickerButton(),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          maxLength: 7,
          autocorrect: false,
          enableSuggestions: false,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Select a color or enter a 6-digit HEX code.',
                style: AppTextStyles.formHelper.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPickerButton() {
    final color = _parseColor(controller.text);

    return Tooltip(
      message: 'Choose color',
      child: InkWell(
        onTap: enabled ? onPickColor : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.only(right: 6),
          child: Center(
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color ?? AppColors.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderStrong, width: 1),
              ),
              child: color == null
                  ? const Icon(
                      Icons.colorize_outlined,
                      size: 13,
                      color: AppColors.iconSecondary,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Color? _parseColor(String value) {
    final hex = value.trim().replaceFirst('#', '');

    if (hex.length != 6) {
      return null;
    }

    final parsed = int.tryParse(hex, radix: 16);

    if (parsed == null) {
      return null;
    }

    return Color(0xFF000000 | parsed);
  }
}
