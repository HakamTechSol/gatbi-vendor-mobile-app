import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/edit_attributes_controller.dart';

class EditAttributeScreen extends ConsumerStatefulWidget {
  const EditAttributeScreen({
    super.key,
    required this.attributeId,
    required this.initialName,
    required this.initialInputType,
    this.initialIsActive,
    this.initialSlug,
  });

  // ============================================================
  // Initial Attribute Data
  // ============================================================

  final int attributeId;
  final String initialName;
  final String initialInputType;
  final bool? initialIsActive;
  final String? initialSlug;

  @override
  ConsumerState<EditAttributeScreen> createState() =>
      _EditAttributeScreenState();
}

class _EditAttributeScreenState extends ConsumerState<EditAttributeScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  final TextEditingController _nameController = TextEditingController();

  // ============================================================
  // Form
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // State
  // ============================================================

  String? _selectedInputType;

  bool _isActive = true;
  bool _isSubmitting = false;

  // ============================================================
  // Input Type Options
  // ============================================================

  static const List<_InputTypeOption> _inputTypes = [
    _InputTypeOption(label: 'Text', value: 'text'),
    _InputTypeOption(label: 'Swatch', value: 'swatch'),
  ];

  // ============================================================
  // Init State
  // ============================================================

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.initialName;

    _selectedInputType = _normalizeInputType(widget.initialInputType);

  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 900
                  ? 32.0
                  : 20.0;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPageHeader(),

                        const SizedBox(height: 22),

                        _buildFormCard(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        tooltip: 'Back',
        onPressed: _isSubmitting
            ? null
            : () {
                Navigator.of(context).pop();
              },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: _isSubmitting ? AppColors.iconMuted : AppColors.iconPrimary,
        ),
      ),
      title: Text(
        'Edit Attribute',
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.divider),
      ),
    );
  }

  // ============================================================
  // PAGE HEADER
  // ============================================================

  Widget _buildPageHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderIcon(),

                const SizedBox(height: 15),

                _buildHeaderText(),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderIcon(),

              const SizedBox(width: 16),

              Expanded(child: _buildHeaderText()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
      ),
      child: const Icon(Icons.edit_rounded, color: AppColors.white, size: 26),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit attribute details',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.white,
            fontSize: 21,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Update the attribute name, input type, or active status.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.86),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFormHeader(),

          const Divider(height: 1, thickness: 1, color: AppColors.divider),

          _buildFormContent(),

          const Divider(height: 1, thickness: 1, color: AppColors.divider),

          _buildFooter(),
        ],
      ),
    );
  }

  // ============================================================
  // FORM HEADER
  // ============================================================

  Widget _buildFormHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
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
                  'Attribute Details',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Update the information for this attribute.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
  // FORM CONTENT
  // ============================================================

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionIntro(),

          const SizedBox(height: 24),

          // ======================================================
          // ATTRIBUTE NAME
          // ======================================================
          CustomTextField(
            controller: _nameController,
            label: 'Attribute Name',
            hintText: 'e.g. Color',
            prefixIcon: Icons.label_outline_rounded,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            maxLength: 100,
            showCounter: false,
            validator: _validateName,
            enabled: !_isSubmitting,
          ),

          const SizedBox(height: 20),

          // ======================================================
          // INPUT TYPE
          // ======================================================
          _buildInputTypeDropdown(),

          const SizedBox(height: 8),

          _buildHelperText(
            icon: Icons.info_outline_rounded,
            text:
                'Choose how this attribute value should be displayed for products.',
          ),

          // ======================================================
          // SLUG INFORMATION
          // ======================================================
          if ((widget.initialSlug ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 20),

            _buildSlugInfo(),
          ],

          const SizedBox(height: 24),

          // ======================================================
          // ACTIVE
          // ======================================================
          _buildActiveCard(),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION INTRO
  // ============================================================

  Widget _buildSectionIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Update the attribute details below. The changes will be saved to your vendor account.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT TYPE DROPDOWN
  // ============================================================

  Widget _buildInputTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedInputType,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.iconSecondary,
      ),
      dropdownColor: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Input Type',
        hintText: 'Select input type',
        labelStyle: AppTextStyles.formLabel.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),
        prefixIcon: const Icon(
          Icons.input_rounded,
          color: AppColors.iconSecondary,
        ),
        filled: true,
        fillColor: AppColors.white,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.4),
        ),
      ),
      validator: _validateInputType,
      onChanged: _isSubmitting
          ? null
          : (value) {
              setState(() {
                _selectedInputType = value;
              });
            },
      items: _inputTypes.map((option) {
        return DropdownMenuItem<String>(
          value: option.value,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // SLUG INFORMATION
  // ============================================================

  Widget _buildSlugInfo() {
    final slug = widget.initialSlug?.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.link_rounded,
              size: 18,
              color: AppColors.iconSecondary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Slug',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  slug!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Slug is managed by the server and is not changed by this update.',
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.lock_outline_rounded,
            size: 17,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPER TEXT
  // ============================================================

  Widget _buildHelperText({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.textTertiary),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              text,
              style: AppTextStyles.formHelper.copyWith(fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVE CARD
  // ============================================================

  Widget _buildActiveCard() {
    final active = _isActive;

    final background = active ? AppColors.successLight : AppColors.surfaceMuted;

    final borderColor = active ? AppColors.successBorder : AppColors.border;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: active ? AppColors.success : AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: active ? AppColors.success : AppColors.border,
              ),
            ),
            child: Icon(
              active
                  ? Icons.check_circle_outline_rounded
                  : Icons.pause_circle_outline_rounded,
              size: 21,
              color: active ? AppColors.white : AppColors.textTertiary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attribute Active',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  active
                      ? 'This attribute is available for products.'
                      : 'This attribute will remain inactive.',
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Switch.adaptive(
            value: _isActive,
            activeTrackColor: AppColors.success,
            activeThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.disabled,
            inactiveThumbColor: AppColors.textMuted,
            onChanged: _isSubmitting
                ? null
                : (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
      decoration: const BoxDecoration(color: AppColors.surfaceSoft),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 500;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomButton(
                  text: 'Update Attribute',
                  icon: Icons.save_rounded,
                  height: 52,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                  onPressed: _isSubmitting ? null : _submit,
                ),

                const SizedBox(height: 10),

                CustomButton(
                  text: 'Cancel',
                  type: CustomButtonType.outlined,
                  height: 50,
                  isEnabled: !_isSubmitting,
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  type: CustomButtonType.outlined,
                  height: 52,
                  isEnabled: !_isSubmitting,
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Update Attribute',
                  icon: Icons.save_rounded,
                  height: 52,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                  onPressed: _isSubmitting ? null : _submit,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // NAME VALIDATION
  // ============================================================

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Attribute name is required.';
    }

    if (text.length < 2) {
      return 'Attribute name must be at least 2 characters.';
    }

    if (text.length > 100) {
      return 'Attribute name cannot exceed 100 characters.';
    }

    return null;
  }

  // ============================================================
  // INPUT TYPE VALIDATION
  // ============================================================

  String? _validateInputType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select an input type.';
    }

    final exists = _inputTypes.any((option) => option.value == value);

    if (!exists) {
      return 'Please select a valid input type.';
    }

    return null;
  }

  // ============================================================
  // NORMALIZE INPUT TYPE
  // ============================================================

  String? _normalizeInputType(String value) {
    final normalized = value.trim().toLowerCase();

    final exists = _inputTypes.any((option) => option.value == normalized);

    if (!exists) {
      return null;
    }

    return normalized;
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSubmitting) {
      return;
    }

    final name = _nameController.text.trim();

    final inputType = _selectedInputType;

    if (inputType == null || inputType.isEmpty) {
      _showErrorSnackBar('Please select a valid input type.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // --------------------------------------------------------
      // Controller
      // --------------------------------------------------------

      final controller = ref.read(editAttributesControllerProvider);

      // --------------------------------------------------------
      // API
      // --------------------------------------------------------

      final result = await controller.editAttribute(
        id: widget.attributeId,
        name: name,
        inputType: inputType,
        isActive: _isActive ? '1' : '0',
      );

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // API SUCCESS VALIDATION
      // --------------------------------------------------------

      if (!result.success) {
        throw ApiException(
          message: result.message?.trim().isNotEmpty == true
              ? result.message!.trim()
              : 'Unable to update attribute.',
          code: 'ATTRIBUTE_UPDATE_FAILED',
        );
      }

      // --------------------------------------------------------
      // RESET SUBMITTING
      // --------------------------------------------------------

      setState(() {
        _isSubmitting = false;
      });

      // --------------------------------------------------------
      // RETURN UPDATED RESULT
      // --------------------------------------------------------

      Navigator.of(context).pop(result);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showErrorSnackBar(_extractErrorMessage(error));
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showErrorSnackBar(_extractErrorMessage(error));
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _extractErrorMessage(Object error) {
    final message = error.toString().trim();

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }

  // ============================================================
  // ERROR SNACKBAR
  // ============================================================

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
          elevation: 6,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

// ============================================================
// INPUT TYPE OPTION MODEL
// ============================================================

class _InputTypeOption {
  const _InputTypeOption({required this.label, required this.value});

  final String label;
  final String value;
}
