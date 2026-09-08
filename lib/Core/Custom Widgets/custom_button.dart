import 'package:flutter/material.dart';

import '../../Theme/app_colors.dart';
import '../../Theme/app_text_styles.dart';

enum CustomButtonType { primary, outlined, text }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
    this.height = 52,
    this.borderRadius = 10,
    this.width,
    this.padding,
    this.icon,
    this.iconPosition = CustomButtonIconPosition.leading,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.gradient,
    this.elevation = 0,
  });

  /// Button title.
  final String text;

  /// Button action.
  final VoidCallback? onPressed;

  /// Button visual type.
  ///
  /// primary
  /// outlined
  /// text
  final CustomButtonType type;

  /// Shows loading indicator.
  final bool isLoading;

  /// Allows manually disabling the button.
  final bool isEnabled;

  /// Button height.
  final double height;

  /// Button corner radius.
  final double borderRadius;

  /// Optional fixed width.
  ///
  /// If null, button takes available width.
  final double? width;

  final EdgeInsetsGeometry? padding;

  /// Optional icon.
  final IconData? icon;

  final CustomButtonIconPosition iconPosition;

  final TextStyle? textStyle;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  /// Custom gradient.
  ///
  /// Defaults to AppColors.primaryGradient.
  final Gradient? gradient;

  final double elevation;

  bool get _isDisabled => !isEnabled || isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CustomButtonType.primary:
        return _buildPrimaryButton();

      case CustomButtonType.outlined:
        return _buildOutlinedButton();

      case CustomButtonType.text:
        return _buildTextButton();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _isDisabled ? null : gradient ?? AppColors.primaryGradient,

          color: _isDisabled ? AppColors.disabled : null,

          borderRadius: BorderRadius.circular(borderRadius),

          boxShadow: _isDisabled || elevation == 0
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primaryShadow,
                    blurRadius: elevation + 10,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
              child: _buildButtonContent(
                textColor: _isDisabled
                    ? AppColors.disabledText
                    : foregroundColor ?? AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OUTLINED BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOutlinedButton() {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.primary, width: 1.2),
            ),
            child: _buildButtonContent(textColor: AppColors.primary),
          ),
        ),
      ),
    );
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTextButton() {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
            child: _buildButtonContent(
              textColor: _isDisabled
                  ? AppColors.disabledText
                  : foregroundColor ?? AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUTTON CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildButtonContent({required Color textColor}) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 21,
          height: 21,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    final textWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          textStyle ??
          (type == CustomButtonType.primary
                  ? AppTextStyles.buttonLarge
                  : AppTextStyles.buttonOutlined)
              .copyWith(color: textColor),
    );

    if (icon == null) {
      return Center(child: textWidget);
    }

    final iconWidget = Icon(icon, size: 20, color: textColor);

    if (iconPosition == CustomButtonIconPosition.leading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Flexible(child: textWidget),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: textWidget),
        const SizedBox(width: 8),
        iconWidget,
      ],
    );
  }
}

enum CustomButtonIconPosition { leading, trailing }
