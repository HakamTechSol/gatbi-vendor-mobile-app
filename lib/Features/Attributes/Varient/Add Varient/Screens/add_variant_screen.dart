import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../../Services/api_exception.dart';
import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';
import '../../../Get Attributes/Models/get_attributes_model.dart';
import '../Controller/add_variant_controller.dart';
import '../Reuse Widgets/add_variant_header.dart';
import '../Reuse Widgets/variant_active_switch.dart';
import '../Reuse Widgets/variant_color_field.dart';
import '../Reuse Widgets/variant_form_card.dart';

class AddVariantScreen extends ConsumerStatefulWidget {
  const AddVariantScreen({super.key, required this.attribute});

  final GetAttributeModel attribute;

  @override
  ConsumerState<AddVariantScreen> createState() => _AddVariantScreenState();
}

class _AddVariantScreenState extends ConsumerState<AddVariantScreen> {
  // ============================================================
  // Form
  // ============================================================

  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // Controllers
  // ============================================================

  late final TextEditingController _valueController;
  late final TextEditingController _colorController;
  late final TextEditingController _sortOrderController;

  // ============================================================
  // Focus Nodes
  // ============================================================

  late final FocusNode _valueFocusNode;
  late final FocusNode _colorFocusNode;
  late final FocusNode _sortOrderFocusNode;

  // ============================================================
  // State
  // ============================================================

  bool _isActive = true;
  bool _isSubmitting = false;

  Color? _selectedColor;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    _valueController = TextEditingController();
    _colorController = TextEditingController();
    _sortOrderController = TextEditingController();

    _valueFocusNode = FocusNode();
    _colorFocusNode = FocusNode();
    _sortOrderFocusNode = FocusNode();

    _colorController.addListener(_handleColorTextChanged);
  }

  @override
  void dispose() {
    _colorController.removeListener(_handleColorTextChanged);

    _valueController.dispose();
    _colorController.dispose();
    _sortOrderController.dispose();

    _valueFocusNode.dispose();
    _colorFocusNode.dispose();
    _sortOrderFocusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // Color Text Listener
  // ============================================================

  void _handleColorTextChanged() {
    final parsedColor = _parseHexColor(_colorController.text);

    if (parsedColor == _selectedColor) {
      return;
    }

    if (mounted) {
      setState(() {
        _selectedColor = parsedColor;
      });
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AddVariantHeader(attribute: widget.attribute),
                        const SizedBox(height: 20),
                        _buildAttributeInfo(),
                        const SizedBox(height: 20),
                        _buildFormCard(),
                        const SizedBox(height: 20),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ============================================================
  // Attribute Info
  // ============================================================

  Widget _buildAttributeInfo() {
    final attributeName = widget.attribute.name?.trim().isNotEmpty == true
        ? widget.attribute.name!.trim()
        : 'Attribute';

    final attributeId = widget.attribute.id;

    final attributeType = widget.attribute.inputType?.trim().isNotEmpty == true
        ? widget.attribute.inputType!.trim()
        : 'variant';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adding value to',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  attributeName,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Type: $attributeType'
                  '${attributeId != null ? ' • ID: $attributeId' : ''}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _buildOwnBadge(),
        ],
      ),
    );
  }

  Widget _buildOwnBadge() {
    final isOwn = widget.attribute.isOwn;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: isOwn ? AppColors.successLight : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOwn ? AppColors.successBorder : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOwn ? Icons.edit_outlined : Icons.lock_outline,
            size: 13,
            color: isOwn ? AppColors.successDark : AppColors.iconSecondary,
          ),
          const SizedBox(width: 5),
          Text(
            isOwn ? 'Editable' : 'System',
            style: AppTextStyles.labelSmall.copyWith(
              color: isOwn ? AppColors.successDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Form Card
  // ============================================================

  Widget _buildFormCard() {
    return VariantFormCard(
      children: [
        _buildValueField(),
        VariantColorField(
          controller: _colorController,
          focusNode: _colorFocusNode,
          enabled: !_isSubmitting,
          validator: _validateColor,
          onChanged: (_) {
            // The controller listener updates the color preview.
          },
          onPickColor: _openColorPicker,
        ),
        _buildSortOrderField(),
        VariantActiveSwitch(
          value: _isActive,
          enabled: !_isSubmitting,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
      ],
    );
  }

  // ============================================================
  // Variant Value
  // ============================================================

  Widget _buildValueField() {
    return CustomTextField(
      controller: _valueController,
      focusNode: _valueFocusNode,
      label: 'Variant Value',
      hintText: 'e.g. 512GB, Black',
      prefixIcon: Icons.sell_outlined,
      prefixIconColor: AppColors.primary,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      validator: _validateValue,
      enabled: !_isSubmitting,
      maxLength: 255,
      autocorrect: true,
      enableSuggestions: true,
      onSubmitted: (_) {
        _colorFocusNode.requestFocus();
      },
    );
  }

  // ============================================================
  // Sort Order
  // ============================================================

  Widget _buildSortOrderField() {
    return CustomTextField(
      controller: _sortOrderController,
      focusNode: _sortOrderFocusNode,
      label: 'Sort Order',
      hintText: 'e.g. 10',
      prefixIcon: Icons.format_list_numbered_rounded,
      prefixIconColor: AppColors.primary,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      validator: _validateSortOrder,
      enabled: !_isSubmitting,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: (_) {
        _submit();
      },
    );
  }

  // ============================================================
  // Action Buttons
  // ============================================================

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 500;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddButton(),
              const SizedBox(height: 10),
              _buildCancelButton(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _buildCancelButton()),
            const SizedBox(width: 12),
            Expanded(child: _buildAddButton()),
          ],
        );
      },
    );
  }

  Widget _buildAddButton() {
    return CustomButton(
      text: 'Add Variant',
      onPressed: _submit,
      isLoading: _isSubmitting,
      isEnabled: !_isSubmitting,
      height: 52,
      borderRadius: 12,
      icon: Icons.add_rounded,
      iconPosition: CustomButtonIconPosition.leading,
      elevation: 2,
    );
  }

  Widget _buildCancelButton() {
    return CustomButton(
      text: 'Cancel',
      type: CustomButtonType.outlined,
      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
      isEnabled: !_isSubmitting,
      height: 52,
      borderRadius: 12,
      icon: Icons.close_rounded,
      iconPosition: CustomButtonIconPosition.leading,
    );
  }

  // ============================================================
  // Validation
  // ============================================================

  String? _validateValue(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Variant value is required.';
    }

    if (text.length < 2) {
      return 'Variant value must be at least 2 characters.';
    }

    if (text.length > 255) {
      return 'Variant value cannot exceed 255 characters.';
    }

    return null;
  }

  String? _validateColor(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Color code is required.';
    }

    final hexPattern = RegExp(r'^#[0-9A-Fa-f]{6}$');

    if (!hexPattern.hasMatch(text)) {
      return 'Enter a valid HEX color, e.g. #000000.';
    }

    return null;
  }

  String? _validateSortOrder(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Sort order is required.';
    }

    final sortOrder = int.tryParse(text);

    if (sortOrder == null) {
      return 'Sort order must be a valid number.';
    }

    if (sortOrder < 0) {
      return 'Sort order cannot be negative.';
    }

    return null;
  }

  // ============================================================
  // Submit
  // ============================================================

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_isSubmitting) {
      return;
    }

    final attributeId = widget.attribute.id;

    if (attributeId == null) {
      _showErrorMessage(
        'Unable to add variant because the attribute ID is missing.',
      );
      return;
    }

    if (attributeId <= 0) {
      _showErrorMessage(
        'Unable to add variant because the attribute ID is invalid.',
      );
      return;
    }

    // Only own attributes can be modified.
    if (!widget.attribute.isOwn) {
      _showErrorMessage('System attributes cannot be modified.');
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final value = _valueController.text.trim();
    final colorCode = _colorController.text.trim();
    final sortOrder = int.parse(_sortOrderController.text.trim());

    setState(() {
      _isSubmitting = true;
    });

    try {
      final controller = ref.read(addVariantControllerProvider);

      final result = await controller.addVariant(
        attributeId: attributeId,
        value: value,
        code: colorCode,
        sortOrder: sortOrder,
        isActive: _isActive ? '1' : '0',
      );

      if (!mounted) {
        return;
      }

      if (!result.success) {
        _showErrorMessage(
          result.message ?? 'Unable to add variant. Please try again.',
        );
        return;
      }

      _showSuccessMessage(result.message ?? 'Variant added successfully.');

      Navigator.of(context).pop(result);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage(
        error.message.isNotEmpty
            ? error.message
            : 'Unable to add variant. Please try again.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ============================================================
  // Color Picker
  // ============================================================

  Future<void> _openColorPicker() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    final initialColor = _selectedColor ?? AppColors.primary;

    final selectedColor = await showDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return _ColorPickerDialog(initialColor: initialColor);
      },
    );

    if (!mounted || selectedColor == null) {
      return;
    }

    final hexCode = _colorToHex(selectedColor);

    setState(() {
      _selectedColor = selectedColor;
      _colorController.text = hexCode;
    });
  }

  // ============================================================
  // Color Helpers
  // ============================================================

  String _colorToHex(Color color) {
    final rgb = color.value & 0xFFFFFF;

    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Color? _parseHexColor(String value) {
    final hex = value.trim();

    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(hex)) {
      return null;
    }

    final parsed = int.tryParse(hex.substring(1), radix: 16);

    if (parsed == null) {
      return null;
    }

    return Color(0xFF000000 | parsed);
  }

  // ============================================================
  // Snackbar
  // ============================================================

  void _showSuccessMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  void _showErrorMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}

// ============================================================================
// Color Picker Dialog
// ============================================================================

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({required this.initialColor});

  final Color initialColor;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildSelectedColorPreview(),
                const SizedBox(height: 20),
                _buildColorPalette(),
                const SizedBox(height: 20),
                _buildDialogActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.palette_outlined,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Color',
                style: AppTextStyles.dialogTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Select a color for this variant.',
                style: AppTextStyles.dialogDescription.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Preview
  // ============================================================

  Widget _buildSelectedColorPreview() {
    final hexCode = _colorToHex(_selectedColor);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _selectedColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderStrong, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Color',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hexCode,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Palette
  // ============================================================

  Widget _buildColorPalette() {
    final colors = <Color>[
      // Grayscale
      const Color(0xFFFFFFFF),
      const Color(0xFFF5F5F5),
      const Color(0xFFE0E0E0),
      const Color(0xFFBDBDBD),
      const Color(0xFF757575),
      const Color(0xFF424242),
      const Color(0xFF212121),
      const Color(0xFF000000),

      // Reds
      const Color(0xFFFFEBEE),
      const Color(0xFFFFCDD2),
      const Color(0xFFEF5350),
      const Color(0xFFE53935),
      const Color(0xFFC62828),

      // Pinks
      const Color(0xFFFCE4EC),
      const Color(0xFFF48FB1),
      const Color(0xFFEC407A),
      const Color(0xFFD81B60),
      const Color(0xFFAD1457),

      // Purple
      const Color(0xFFF3E5F5),
      const Color(0xFFCE93D8),
      const Color(0xFFAB47BC),
      const Color(0xFF8E24AA),
      const Color(0xFF6A1B9A),

      // Deep Purple / Indigo
      const Color(0xFFEDE7F6),
      const Color(0xFFB39DDB),
      const Color(0xFF7E57C2),
      const Color(0xFF5E35B1),
      const Color(0xFF4527A0),

      // Blue
      const Color(0xFFE3F2FD),
      const Color(0xFF90CAF9),
      const Color(0xFF42A5F5),
      const Color(0xFF1E88E5),
      const Color(0xFF1565C0),

      // Cyan
      const Color(0xFFE0F7FA),
      const Color(0xFF80DEEA),
      const Color(0xFF26C6DA),
      const Color(0xFF00ACC1),
      const Color(0xFF00838F),

      // Teal
      const Color(0xFFE0F2F1),
      const Color(0xFF80CBC4),
      const Color(0xFF26A69A),
      const Color(0xFF00897B),
      const Color(0xFF00695C),

      // Green
      const Color(0xFFE8F5E9),
      const Color(0xFFA5D6A7),
      const Color(0xFF66BB6A),
      const Color(0xFF43A047),
      const Color(0xFF2E7D32),

      // Lime
      const Color(0xFFF1F8E9),
      const Color(0xFFC5E1A5),
      const Color(0xFF9CCC65),
      const Color(0xFF7CB342),
      const Color(0xFF558B2F),

      // Yellow
      const Color(0xFFFFFDE7),
      const Color(0xFFFFF59D),
      const Color(0xFFFFEE58),
      const Color(0xFFFDD835),
      const Color(0xFFF9A825),

      // Orange
      const Color(0xFFFFF3E0),
      const Color(0xFFFFCC80),
      const Color(0xFFFFA726),
      const Color(0xFFFB8C00),
      const Color(0xFFEF6C00),

      // Brown
      const Color(0xFFEFEBE9),
      const Color(0xFFBCAAA4),
      const Color(0xFF8D6E63),
      const Color(0xFF6D4C41),
      const Color(0xFF4E342E),

      // Blue Grey
      const Color(0xFFECEFF1),
      const Color(0xFFB0BEC5),
      const Color(0xFF78909C),
      const Color(0xFF546E7A),
      const Color(0xFF37474F),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemSize = (width - 44) / 8;

        return Wrap(
          spacing: 6,
          runSpacing: 8,
          children: colors.map((color) {
            return _buildColorOption(color, itemSize.clamp(28.0, 42.0));
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // Color Option
  // ============================================================

  Widget _buildColorOption(Color color, double size) {
    final isSelected = _selectedColor.value == color.value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check_rounded,
                size: size * 0.55,
                color: _getContrastColor(color),
              )
            : null,
      ),
    );
  }

  // ============================================================
  // Dialog Actions
  // ============================================================

  Widget _buildDialogActions() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Cancel',
            type: CustomButtonType.outlined,
            onPressed: () {
              Navigator.of(context).pop();
            },
            height: 46,
            borderRadius: 10,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: 'Select Color',
            onPressed: () {
              Navigator.of(context).pop(_selectedColor);
            },
            height: 46,
            borderRadius: 10,
            icon: Icons.check_rounded,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Contrast
  // ============================================================

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();

    return luminance > 0.55 ? AppColors.navyDark : AppColors.white;
  }

  // ============================================================
  // HEX
  // ============================================================

  String _colorToHex(Color color) {
    final rgb = color.value & 0xFFFFFF;

    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
