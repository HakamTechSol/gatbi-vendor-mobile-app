import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/business_change_controller.dart';
import '../Models/business_change_model.dart';

class BusinessChangeScreen extends ConsumerStatefulWidget {
  const BusinessChangeScreen({super.key});

  @override
  ConsumerState<BusinessChangeScreen> createState() =>
      _BusinessChangeScreenState();
}

class _BusinessChangeScreenState extends ConsumerState<BusinessChangeScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  final TextEditingController _requestedValueController =
      TextEditingController();

  final TextEditingController _reasonController = TextEditingController();

  // ============================================================
  // Focus Nodes
  // ============================================================

  final FocusNode _requestedValueFocusNode = FocusNode();

  final FocusNode _reasonFocusNode = FocusNode();

  // ============================================================
  // Form
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // Image Picker
  // ============================================================

  final ImagePicker _imagePicker = ImagePicker();

  // ============================================================
  // State
  // ============================================================

  String? _selectedField;

  String? _selectedBusinessType;

  File? _selectedDocument;

  bool _isSubmitting = false;

  String? _errorMessage;

  // ============================================================
  // Field Options
  // ============================================================

  static const List<String> _fieldOptions = [
    'business_type',
    'trade_license_number',
    'store_name',
  ];

  // ============================================================
  // Business Type Options
  // ============================================================

  static const List<_BusinessTypeOption> _businessTypeOptions = [
    _BusinessTypeOption(value: 'individual', label: 'Individual'),
    _BusinessTypeOption(value: 'llc', label: 'LLC'),
    _BusinessTypeOption(value: 'corporation', label: 'Corporation'),
  ];

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void dispose() {
    _requestedValueController.dispose();
    _reasonController.dispose();

    _requestedValueFocusNode.dispose();
    _reasonFocusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // Helpers
  // ============================================================

  bool get _isTradeLicenseSelected => _selectedField == 'trade_license_number';

  bool get _isBusinessTypeSelected => _selectedField == 'business_type';

  // ============================================================
  // Field Display Label
  // ============================================================

  String _getFieldLabel(String field) {
    switch (field) {
      case 'business_type':
        return 'Business Type';

      case 'trade_license_number':
        return 'Trade License Number';

      case 'store_name':
        return 'Store Name';

      default:
        return field;
    }
  }

  // ============================================================
  // Business Type Display Label
  // ============================================================

  String _getBusinessTypeLabel(String value) {
    switch (value) {
      case 'individual':
        return 'Individual';

      case 'llc':
        return 'LLC';

      case 'corporation':
        return 'Corporation';

      default:
        return value;
    }
  }

  // ============================================================
  // Field Selection
  // ============================================================

  void _onFieldChanged(String? value) {
    if (_isSubmitting) return;

    setState(() {
      _selectedField = value;

      // ----------------------------------------------------------
      // Clear requested value when changing field.
      // ----------------------------------------------------------

      _requestedValueController.clear();

      // ----------------------------------------------------------
      // Clear business type selection when another field selected.
      // ----------------------------------------------------------

      _selectedBusinessType = null;

      // ----------------------------------------------------------
      // Image sirf trade_license_number ke liye allowed hai.
      // ----------------------------------------------------------

      if (value != 'trade_license_number') {
        _selectedDocument = null;
      }

      // ----------------------------------------------------------
      // Clear previous error.
      // ----------------------------------------------------------

      _errorMessage = null;
    });

    debugPrint('');
    debugPrint('========== BUSINESS CHANGE FIELD ==========');
    debugPrint('SELECTED FIELD: ${value ?? 'N/A'}');
    debugPrint(
      'DISPLAY LABEL: ${value == null ? 'N/A' : _getFieldLabel(value)}',
    );
    debugPrint('IMAGE ALLOWED: ${value == 'trade_license_number'}');
    debugPrint('IMAGE REQUIRED: ${value == 'trade_license_number'}');
    debugPrint('============================================');
    debugPrint('');
  }

  // ============================================================
  // Business Type Selection
  // ============================================================

  void _onBusinessTypeChanged(String? value) {
    if (_isSubmitting) return;

    setState(() {
      _selectedBusinessType = value;

      _requestedValueController.text = value ?? '';

      _errorMessage = null;
    });

    debugPrint('');
    debugPrint('========== BUSINESS TYPE SELECTED ==========');
    debugPrint('API VALUE: ${value ?? 'N/A'}');
    debugPrint(
      'DISPLAY VALUE: '
      '${value == null ? 'N/A' : _getBusinessTypeLabel(value)}',
    );
    debugPrint('=============================================');
    debugPrint('');
  }

  // ============================================================
  // Pick Image
  // ============================================================

  Future<void> _pickDocument() async {
    if (_isSubmitting) return;

    try {
      debugPrint('');
      debugPrint('========== PICK TRADE LICENSE DOCUMENT ==========');

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        debugPrint('IMAGE PICKING CANCELLED');
        debugPrint('===============================================');
        debugPrint('');
        return;
      }

      final file = File(pickedFile.path);

      // ----------------------------------------------------------
      // File size validation
      // ----------------------------------------------------------

      final fileSize = await file.length();

      const maxFileSize = 8 * 1024 * 1024;

      if (fileSize > maxFileSize) {
        if (!mounted) return;

        _showErrorSnackBar('Image size must be less than 8 MB.');

        debugPrint(
          'IMAGE REJECTED: File size is '
          '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB',
        );

        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedDocument = file;
        _errorMessage = null;
      });

      debugPrint('IMAGE SELECTED: ${file.path}');
      debugPrint(
        'IMAGE SIZE: '
        '${(fileSize / 1024).toStringAsFixed(2)} KB',
      );
      debugPrint('=================================================');
      debugPrint('');
    } catch (error) {
      debugPrint('');
      debugPrint('========== IMAGE PICK ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('======================================');
      debugPrint('');

      if (!mounted) return;

      _showErrorSnackBar('Unable to select image. Please try again.');
    }
  }

  // ============================================================
  // Remove Image
  // ============================================================

  void _removeDocument() {
    if (_isSubmitting) return;

    setState(() {
      _selectedDocument = null;
    });

    debugPrint('BUSINESS CHANGE DOCUMENT REMOVED');
  }

  // ============================================================
  // Submit
  // ============================================================

  Future<void> _submitChangeRequest() async {
    FocusScope.of(context).unfocus();

    // ----------------------------------------------------------
    // Clear previous error
    // ----------------------------------------------------------

    setState(() {
      _errorMessage = null;
    });

    // ----------------------------------------------------------
    // Form Validation
    // ----------------------------------------------------------

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // ----------------------------------------------------------
    // Field validation
    // ----------------------------------------------------------

    if (_selectedField == null || _selectedField!.trim().isEmpty) {
      _showErrorSnackBar('Please select the field you want to change.');

      return;
    }

    // ----------------------------------------------------------
    // Business Type validation
    // ----------------------------------------------------------

    if (_isBusinessTypeSelected) {
      if (_selectedBusinessType == null ||
          _selectedBusinessType!.trim().isEmpty) {
        _showErrorSnackBar('Please select a valid business type.');

        return;
      }

      if (!_businessTypeOptions.any(
        (item) => item.value == _selectedBusinessType,
      )) {
        _showErrorSnackBar('Please select a valid business type.');

        return;
      }
    }

    // ----------------------------------------------------------
    // Trade License requires image
    // ----------------------------------------------------------

    if (_isTradeLicenseSelected && _selectedDocument == null) {
      _showErrorSnackBar(
        'Please upload an image for trade license number change.',
      );

      return;
    }

    // ----------------------------------------------------------
    // Request Values
    // ----------------------------------------------------------

    final fieldName = _selectedField!.trim();

    final requestedValue = _requestedValueController.text.trim();

    final reason = _reasonController.text.trim();

    debugPrint('');
    debugPrint('========== SUBMIT BUSINESS CHANGE ==========');
    debugPrint('FIELD NAME: $fieldName');
    debugPrint('FIELD LABEL: ${_getFieldLabel(fieldName)}');
    debugPrint('REQUESTED VALUE: $requestedValue');
    debugPrint(
      'BUSINESS TYPE DISPLAY: '
      '${_isBusinessTypeSelected ? _getBusinessTypeLabel(requestedValue) : 'N/A'}',
    );
    debugPrint('REASON: ${reason.isEmpty ? 'N/A' : reason}');
    debugPrint(
      'DOCUMENT: '
      '${_selectedDocument?.path ?? 'NO DOCUMENT'}',
    );
    debugPrint('============================================');
    debugPrint('');

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(businessChangeControllerProvider)
          .submitBusinessChange(
            fieldName: fieldName,
            requestedValue: requestedValue,
            reason: reason,
            document: _selectedDocument,
          );

      if (!mounted) return;

      // --------------------------------------------------------
      // API Success
      // --------------------------------------------------------

      if (result.success) {
        _handleSuccess(result);

        if (!mounted) return;

        context.pop(true);
      } else {
        final message =
            result.message ?? 'Unable to submit your change request.';

        setState(() {
          _errorMessage = message;
        });

        _showErrorSnackBar(message);
      }
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint('========== BUSINESS CHANGE API ERROR ==========');
      debugPrint('MESSAGE: ${error.message}');
      debugPrint('CODE: ${error.code}');
      debugPrint('===============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _errorMessage = error.message;
      });

      _showErrorSnackBar(error.message);
    } catch (error) {
      debugPrint('');
      debugPrint('========== BUSINESS CHANGE UNKNOWN ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('====================================================');
      debugPrint('');

      if (!mounted) return;

      const message = 'Something went wrong. Please try again.';

      setState(() {
        _errorMessage = message;
      });

      _showErrorSnackBar(message);
    } finally {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // ============================================================
  // Success Handler
  // ============================================================

  void _handleSuccess(BusinessChangeModel result) {
    final message = result.message ?? 'Change request submitted successfully.';

    debugPrint('');
    debugPrint('========== BUSINESS CHANGE SUCCESS ==========');
    debugPrint('MESSAGE: $message');
    debugPrint('REQUEST ID: ${result.request?.id ?? 'N/A'}');
    debugPrint('STATUS: ${result.request?.status ?? 'N/A'}');
    debugPrint('=============================================');
    debugPrint('');

    _showSuccessSnackBar(message);

    // ----------------------------------------------------------
    // Clear form after successful submission
    // ----------------------------------------------------------

    setState(() {
      _selectedField = null;
      _selectedBusinessType = null;
      _selectedDocument = null;

      _requestedValueController.clear();
      _reasonController.clear();

      _errorMessage = null;
    });
  }
  // ============================================================
  // Success Snackbar
  // ============================================================

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
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

  // ============================================================
  // Error Snackbar
  // ============================================================

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // Header
            // ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: _buildHeader(),
            ),

            // ----------------------------------------------------
            // Content
            // ----------------------------------------------------
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: _isSubmitting
                ? null
                : () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 21,
                color: _isSubmitting
                    ? AppColors.iconMuted
                    : AppColors.iconPrimary,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Change',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineSmall,
              ),

              const SizedBox(height: 3),

              Text(
                'Submit a request to update your business information.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Center(child: _buildFormCard()),
          ),
        );
      },
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------
            // Card Header
            // ----------------------------------------------------
            _buildCardHeader(),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // Error
            // ----------------------------------------------------
            if (_errorMessage != null) ...[
              _buildErrorBox(),
              const SizedBox(height: 18),
            ],

            // ----------------------------------------------------
            // Field To Change
            // ----------------------------------------------------
            _buildFieldDropdown(),

            const SizedBox(height: 18),

            // ----------------------------------------------------
            // Requested Value
            // ----------------------------------------------------
            if (_isBusinessTypeSelected)
              _buildBusinessTypeDropdown()
            else
              CustomTextField(
                controller: _requestedValueController,
                focusNode: _requestedValueFocusNode,
                label: 'Requested Value',
                hintText: 'Enter requested value',
                prefixIcon: Icons.edit_outlined,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                validator: _validateRequestedValue,
                enabled: !_isSubmitting,
              ),

            // ----------------------------------------------------
            // Trade License Document
            // ----------------------------------------------------
            if (_isTradeLicenseSelected) ...[
              const SizedBox(height: 20),
              _buildDocumentSection(),
            ],

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // Reason
            // ----------------------------------------------------
            CustomTextField(
              controller: _reasonController,
              focusNode: _reasonFocusNode,
              label: 'Reason',
              hintText: 'Enter reason (optional)',
              prefixIcon: Icons.notes_outlined,
              textInputAction: TextInputAction.done,
              maxLines: 4,
              minLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              validator: _validateReason,
              enabled: !_isSubmitting,
              showCounter: true,
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------
            // Submit
            // ----------------------------------------------------
            CustomButton(
              text: 'Submit Change Request',
              icon: Icons.send_rounded,
              iconPosition: CustomButtonIconPosition.trailing,
              isLoading: _isSubmitting,
              isEnabled: !_isSubmitting,
              onPressed: _isSubmitting ? null : _submitChangeRequest,
              height: 52,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CARD HEADER
  // ============================================================

  Widget _buildCardHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.business_center_outlined,
            color: AppColors.primary,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request a Business Change',
                style: AppTextStyles.titleLarge,
              ),

              const SizedBox(height: 5),

              Text(
                'Choose the information you want to update and submit a request for review.',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FIELD DROPDOWN
  // ============================================================

  Widget _buildFieldDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Field to Change', style: AppTextStyles.authFieldLabel),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: _selectedField,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconSecondary,
          ),
          decoration: InputDecoration(
            hintText: 'Select field to change',
            hintStyle: AppTextStyles.authHint,
            filled: true,
            fillColor: _isSubmitting
                ? AppColors.inputDisabledBackground
                : AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: const BoxDecoration(
                  color: AppColors.inputIconBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                  ),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 21,
                  color: AppColors.inputIcon,
                ),
              ),
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
              borderSide: const BorderSide(
                color: AppColors.inputFocusedBorder,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: AppTextStyles.formError,
          ),
          style: AppTextStyles.authInput,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select a field.';
            }

            return null;
          },
          onChanged: _isSubmitting ? null : _onFieldChanged,
          items: _fieldOptions.map((field) {
            return DropdownMenuItem<String>(
              value: field,
              child: Text(
                _getFieldLabel(field),
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.authInput,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // BUSINESS TYPE DROPDOWN
  // ============================================================

  Widget _buildBusinessTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Type', style: AppTextStyles.authFieldLabel),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: _selectedBusinessType,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconSecondary,
          ),
          decoration: InputDecoration(
            hintText: 'Select business type',
            hintStyle: AppTextStyles.authHint,
            filled: true,
            fillColor: _isSubmitting
                ? AppColors.inputDisabledBackground
                : AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: const BoxDecoration(
                  color: AppColors.inputIconBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                  ),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  size: 21,
                  color: AppColors.inputIcon,
                ),
              ),
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
              borderSide: const BorderSide(
                color: AppColors.inputFocusedBorder,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: AppTextStyles.formError,
          ),
          style: AppTextStyles.authInput,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select a business type.';
            }

            return null;
          },
          onChanged: _isSubmitting ? null : _onBusinessTypeChanged,
          items: _businessTypeOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(
                option.label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.authInput,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 7),

        Text(
          'Available options: individual | llc | corporation',
          style: AppTextStyles.formHelper,
        ),
      ],
    );
  }

  // ============================================================
  // DOCUMENT SECTION
  // ============================================================

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Supporting Image', style: AppTextStyles.authFieldLabel),

            const SizedBox(width: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Required',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Upload a supporting image for the trade license number change. Maximum size: 8 MB.',
          style: AppTextStyles.formHelper,
        ),

        const SizedBox(height: 12),

        if (_selectedDocument == null)
          _buildUploadBox()
        else
          _buildSelectedImage(),
      ],
    );
  }

  // ============================================================
  // UPLOAD BOX
  // ============================================================

  Widget _buildUploadBox() {
    return Material(
      color: AppColors.primarySurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _isSubmitting ? null : _pickDocument,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderPrimary),
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Upload Image',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 4),

              Text('JPG, JPEG or PNG', style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SELECTED IMAGE
  // ============================================================

  Widget _buildSelectedImage() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _selectedDocument!,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Image selected',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall,
                ),

                const SizedBox(height: 4),

                Text(
                  _selectedDocument!.path.split(Platform.pathSeparator).last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: _isSubmitting ? null : _removeDocument,
            tooltip: 'Remove image',
            icon: const Icon(Icons.close_rounded, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR BOX
  // ============================================================

  Widget _buildErrorBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateRequestedValue(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Requested value is required.';
    }

    if (text.length < 2) {
      return 'Please enter a valid requested value.';
    }

    if (text.length > 255) {
      return 'Requested value cannot exceed 255 characters.';
    }

    return null;
  }

  String? _validateReason(String? value) {
    final text = value?.trim() ?? '';

    // ----------------------------------------------------------
    // Reason is optional
    // ----------------------------------------------------------

    if (text.isEmpty) {
      return null;
    }

    if (text.length < 5) {
      return 'Reason must contain at least 5 characters.';
    }

    if (text.length > 500) {
      return 'Reason cannot exceed 500 characters.';
    }

    return null;
  }
}

// ============================================================
// BUSINESS TYPE OPTION MODEL
// ============================================================

class _BusinessTypeOption {
  const _BusinessTypeOption({required this.value, required this.label});

  final String value;
  final String label;
}
