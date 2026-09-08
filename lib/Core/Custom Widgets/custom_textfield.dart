import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Theme/app_colors.dart';
import '../../Theme/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
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
    this.textDirection,
    this.prefixText,
  });

  /// Main text controller.
  final TextEditingController controller;

  /// Optional field label.
  ///
  /// Example:
  /// Email Address
  /// Password
  final String? label;

  /// Placeholder text.
  ///
  /// Example:
  /// Enter your email
  /// Enter your password
  final String? hintText;

  /// Leading icon.
  ///
  /// Example:
  /// Icons.email_outlined
  /// Icons.lock_outline_rounded
  final IconData? prefixIcon;

  /// Custom trailing icon.
  ///
  /// For password fields this is automatically handled by the widget.
  final Widget? suffixIcon;

  /// Enables password behavior.
  ///
  /// When true:
  /// - Text is hidden initially.
  /// - Eye icon remains hidden while field is empty.
  /// - Eye icon appears when text is entered.
  /// - Tapping eye toggles password visibility.
  final bool isPassword;

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

  final TextDirection? textDirection;

  final String? prefixText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _hasText = widget.controller.text.isNotEmpty;

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);

      _hasText = widget.controller.text.isNotEmpty;

      widget.controller.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;

    if (hasText != _hasText && mounted) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUFFIX ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget? _buildSuffixIcon() {
    // Password field:
    //
    // Empty:
    // No eye icon
    //
    // Has text:
    // Eye icon appears
    if (widget.isPassword) {
      if (!_hasText) {
        return null;
      }

      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        tooltip: _obscureText ? 'Show password' : 'Hide password',
        splashRadius: 22,
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: widget.suffixIconColor ?? AppColors.iconSecondary,
          size: 21,
        ),
      );
    }

    return widget.suffixIcon;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ?? AppTextStyles.authFieldLabel,
          ),
          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,

          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,

          obscureText: widget.isPassword ? _obscureText : false,

          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,

          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,

          maxLines: widget.isPassword ? 1 : widget.maxLines,

          minLines: widget.minLines,
          maxLength: widget.maxLength,

          textCapitalization: widget.textCapitalization,

          inputFormatters: widget.inputFormatters,

          autocorrect: widget.autocorrect,
          enableSuggestions: widget.isPassword
              ? false
              : widget.enableSuggestions,

          textAlign: widget.textAlign,

          textDirection: widget.textDirection,

          style: widget.textStyle ?? AppTextStyles.authInput,

          cursorColor: AppColors.primary,

          decoration: InputDecoration(
            hintText: widget.hintText,

            prefixText: widget.prefixText,

            hintStyle: widget.hintStyle ?? AppTextStyles.authHint,

            filled: true,

            fillColor: widget.enabled
                ? widget.fillColor ?? AppColors.inputBackground
                : AppColors.inputDisabledBackground,

            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

            prefixIcon: widget.prefixIcon != null ? _buildPrefixIcon() : null,

            suffixIcon: _buildSuffixIcon(),

            prefixIconColor: widget.prefixIconColor ?? AppColors.inputIcon,

            suffixIconColor: widget.suffixIconColor ?? AppColors.iconSecondary,

            border: _buildBorder(AppColors.border, 1),

            enabledBorder: _buildBorder(AppColors.border, 1),

            focusedBorder: _buildBorder(
              widget.focusedBorderColor ?? AppColors.inputFocusedBorder,
              1.5,
            ),

            errorBorder: _buildBorder(
              widget.errorBorderColor ?? AppColors.error,
              1,
            ),

            focusedErrorBorder: _buildBorder(
              widget.errorBorderColor ?? AppColors.error,
              1.5,
            ),

            disabledBorder: _buildBorder(AppColors.border, 1),

            errorStyle: AppTextStyles.formError,

            counterStyle: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PREFIX ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPrefixIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.inputIconBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius - 1),
            bottomLeft: Radius.circular(widget.borderRadius - 1),
          ),
        ),
        child: Icon(
          widget.prefixIcon,
          size: 21,
          color: widget.prefixIconColor ?? AppColors.inputIcon,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER
  // ═══════════════════════════════════════════════════════════════════════════

  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
