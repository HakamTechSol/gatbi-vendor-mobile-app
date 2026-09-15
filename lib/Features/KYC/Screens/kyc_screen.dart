import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/kyc_document_file.dart';
import '../Reuse Widgets/kyc_document_upload_card.dart';
import '../Reuse Widgets/kyc_guidelines_card.dart';
import '../Reuse Widgets/kyc_header.dart';
import '../Reuse Widgets/kyc_help_card.dart';
import '../Reuse Widgets/kyc_section_card.dart';
import '../Reuse Widgets/kyc_status_badge.dart';
import '../Reuse Widgets/kyc_timeline_card.dart';
import '../Reuse Widgets/kyc_validators.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final _formKey = GlobalKey<FormState>();

  final _storeNameController = TextEditingController(
    text: 'Zanawar',
  );

  final _storeEmailController = TextEditingController(
    text: 'mdsamama999@gmail.com',
  );

  final _ownerNameController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _tradeLicenseController = TextEditingController();
  final _tradeLicenseExpiryController = TextEditingController();
  final _trnController = TextEditingController();
  final _websiteController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCountryCode = '+971';

  KycDocumentFile? _tradeLicenseFile;
  KycDocumentFile? _authorizedIdFile;
  KycDocumentFile? _vatFile;
  KycDocumentFile? _additionalFile;

  String? _tradeLicenseError;
  String? _authorizedIdError;
  String? _vatError;
  String? _additionalError;

  int _currentStep = 0;

  bool _isSubmitting = false;
  bool _isPickingDocument = false;

  final ImagePicker _imagePicker = ImagePicker();

  static const int _maxFileSizeBytes = 8 * 1024 * 1024;

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeEmailController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _ownerPhoneController.dispose();
    _designationController.dispose();
    _tradeLicenseController.dispose();
    _tradeLicenseExpiryController.dispose();
    _trnController.dispose();
    _websiteController.dispose();
    _businessAddressController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth >= 600 ? 24.0 : 16.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KycHeader(
                        status: KycStatus.pending,
                      ),

                      const SizedBox(height: 20),

                      _buildStepIndicator(),

                      const SizedBox(height: 20),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: _currentStep == 0
                            ? _buildInformationStep()
                            : _buildDocumentsStep(),
                      ),

                      if (_currentStep == 1) ...[
                        const SizedBox(height: 16),
                        const KycTimelineCard(),
                        const SizedBox(height: 16),
                        const KycHelpCard(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP INDICATOR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStepIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          _buildStepCircle(
            number: 1,
            title: 'Business Details',
            active: _currentStep == 0,
            completed: _currentStep > 0,
          ),

          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              color: _currentStep > 0
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),

          _buildStepCircle(
            number: 2,
            title: 'Documents',
            active: _currentStep == 1,
            completed: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required int number,
    required String title,
    required bool active,
    required bool completed,
  }) {
    final selected = active || completed;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 19,
                  )
                : Text(
                    '$number',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: selected
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
          ),
        ),

        const SizedBox(width: 8),

        if (MediaQuery.sizeOf(context).width >= 430)
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              color: active
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 1
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildInformationStep() {
    return Form(
      key: _formKey,
      child: KycSectionCard(
        title: 'Business & Owner Details',
        subtitle:
            'Provide accurate information for compliance verification.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResponsiveFields(
              first: CustomTextField(
                controller: _storeNameController,
                label: 'Store Name',
                hintText: 'Enter store name',
                readOnly: true,
                fillColor: AppColors.inputDisabledBackground,
                textStyle: AppTextStyles.authInput.copyWith(
                  color: AppColors.textSecondary,
                ),
                validator: KycValidators.storeName,
              ),
              second: CustomTextField(
                controller: _storeEmailController,
                label: 'Store Email',
                hintText: 'Enter store email',
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                fillColor: AppColors.inputDisabledBackground,
                textStyle: AppTextStyles.authInput.copyWith(
                  color: AppColors.textSecondary,
                ),
                validator: KycValidators.storeEmail,
              ),
            ),

            const SizedBox(height: 18),

            _buildResponsiveFields(
              first: CustomTextField(
                controller: _ownerNameController,
                label: 'Owner Full Name *',
                hintText: 'Enter owner full name',
                textInputAction: TextInputAction.next,
                validator: KycValidators.ownerName,
              ),
              second: CustomTextField(
                controller: _ownerEmailController,
                label: 'Owner Email',
                hintText: 'Enter owner email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: KycValidators.ownerEmail,
              ),
            ),

            const SizedBox(height: 18),

            _buildResponsiveFields(
              first: _buildPhoneField(),
              second: CustomTextField(
                controller: _designationController,
                label: 'Designation / Role',
                hintText: 'e.g. Owner, Director, Manager',
                textInputAction: TextInputAction.next,
                validator: KycValidators.designation,
              ),
            ),

            const SizedBox(height: 18),

            _buildResponsiveFields(
              first: CustomTextField(
                controller: _tradeLicenseController,
                label: 'Trade License Number *',
                hintText: 'Enter trade license number',
                textInputAction: TextInputAction.next,
                validator: KycValidators.tradeLicense,
              ),
              second: _buildExpiryField(),
            ),

            const SizedBox(height: 18),

            _buildResponsiveFields(
              first: CustomTextField(
                controller: _trnController,
                label: 'Tax Registration Number (TRN)',
                hintText: 'Enter 15 digit TRN',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: KycValidators.trnFormatters,
                validator: KycValidators.trn,
              ),
              second: CustomTextField(
                controller: _websiteController,
                label: 'Company Website',
                hintText: 'https://example.com',
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                validator: KycValidators.website,
              ),
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: _businessAddressController,
              label: 'Registered Business Address *',
              hintText:
                  'Enter complete registered business address',
              maxLines: 4,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              validator: KycValidators.businessAddress,
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: _notesController,
              label: 'Notes for Compliance Team',
              hintText:
                  'Any important remarks about your business or documents',
              maxLines: 4,
              minLines: 3,
              textInputAction: TextInputAction.newline,
              validator: KycValidators.notes,
            ),

            const SizedBox(height: 24),

            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE FIELDS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildResponsiveFields({
    required Widget first,
    required Widget second,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              first,
              const SizedBox(height: 18),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 14),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Owner Phone *',
          style: AppTextStyles.authFieldLabel,
        ),

        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCountryCodeSelector(),

            const SizedBox(width: 8),

            Expanded(
              child: TextFormField(
                controller: _ownerPhoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: KycValidators.phoneFormatters,
                style: AppTextStyles.authInput,
                cursorColor: AppColors.primary,
                validator: (value) {
                  return KycValidators.phone(
                    value,
                    countryCode: _selectedCountryCode,
                  );
                },
                decoration: InputDecoration(
                  hintText: '501234567',
                  hintStyle: AppTextStyles.authHint,
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.5,
                    ),
                  ),
                  errorStyle: AppTextStyles.formError,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Text(
          'Choose your country code and enter the remaining number.',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildCountryCodeSelector() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountryCode,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 19,
            color: AppColors.iconSecondary,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: AppColors.surface,
          style: AppTextStyles.authInput,
          items: const [
            DropdownMenuItem(
              value: '+971',
              child: Text('🇦🇪  +971'),
            ),
            DropdownMenuItem(
              value: '+92',
              child: Text('🇵🇰  +92'),
            ),
            DropdownMenuItem(
              value: '+91',
              child: Text('🇮🇳  +91'),
            ),
            DropdownMenuItem(
              value: '+966',
              child: Text('🇸🇦  +966'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              _selectedCountryCode = value;
            });
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EXPIRY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildExpiryField() {
    return CustomTextField(
      controller: _tradeLicenseExpiryController,
      label: 'Trade License Expiry *',
      hintText: 'mm/dd/yyyy',
      readOnly: true,
      suffixIcon: const Icon(
        Icons.calendar_today_outlined,
        size: 19,
      ),
      onTap: _selectExpiryDate,
      validator: KycValidators.tradeLicenseExpiry,
    );
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: today.add(
        const Duration(days: 30),
      ),
      firstDate: today.add(
        const Duration(days: 1),
      ),
      lastDate: DateTime(
        today.year + 20,
      ),
      helpText: 'Select Trade License Expiry',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(
                  primary: AppColors.primary,
                  surface: AppColors.surface,
                ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) return;

    final month = selectedDate.month.toString().padLeft(2, '0');
    final day = selectedDate.day.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();

    setState(() {
      _tradeLicenseExpiryController.text =
          '$month/$day/$year';
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NEXT
  // ═══════════════════════════════════════════════════════════════════════════

  void _goToDocuments() {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      _showMessage(
        'Please complete the highlighted fields.',
        isError: true,
      );

      return;
    }

    setState(() {
      _currentStep = 1;
    });
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Continue to Documents',
        icon: Icons.arrow_forward_rounded,
        height: 52,
        borderRadius: 12,
        elevation: 1,
        onPressed: _goToDocuments,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 2
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDocumentsStep() {
    return KycSectionCard(
      title: 'Legal Document Uploads',
      subtitle:
          'Upload clear and valid documents. Maximum 8 MB per document.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentGrid(),

          const SizedBox(height: 18),

          const KycGuidelinesCard(),

          const SizedBox(height: 24),

          _buildStepNavigation(),
        ],
      ),
    );
  }

  Widget _buildDocumentGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        final cards = [
          KycDocumentUploadCard(
            title: 'Trade License Copy',
            required: true,
            file: _tradeLicenseFile,
            errorText: _tradeLicenseError,
            onUpload: () => _pickDocument(
              type: _DocumentType.tradeLicense,
            ),
            onRemove: _tradeLicenseFile == null
                ? null
                : () => _removeDocument(
                    type: _DocumentType.tradeLicense,
                  ),
          ),
          KycDocumentUploadCard(
            title: 'Authorized Person ID',
            required: true,
            file: _authorizedIdFile,
            errorText: _authorizedIdError,
            onUpload: () => _pickDocument(
              type: _DocumentType.authorizedId,
            ),
            onRemove: _authorizedIdFile == null
                ? null
                : () => _removeDocument(
                    type: _DocumentType.authorizedId,
                  ),
          ),
          KycDocumentUploadCard(
            title: 'VAT / Tax Registration',
            file: _vatFile,
            errorText: _vatError,
            onUpload: () => _pickDocument(
              type: _DocumentType.vat,
            ),
            onRemove: _vatFile == null
                ? null
                : () => _removeDocument(
                    type: _DocumentType.vat,
                  ),
          ),
          KycDocumentUploadCard(
            title: 'Additional Supporting Document',
            file: _additionalFile,
            errorText: _additionalError,
            onUpload: () => _pickDocument(
              type: _DocumentType.additional,
            ),
            onRemove: _additionalFile == null
                ? null
                : () => _removeDocument(
                    type: _DocumentType.additional,
                  ),
          ),
        ];

        if (!isWide) {
          return Column(
            children: [
              cards[0],
              const SizedBox(height: 14),
              cards[1],
              const SizedBox(height: 14),
              cards[2],
              const SizedBox(height: 14),
              cards[3],
            ],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 14),
                Expanded(child: cards[1]),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[2]),
                const SizedBox(width: 14),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStepNavigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isSubmitting
                ? null
                : () {
                    setState(() {
                      _currentStep = 0;
                    });
                  },
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 2,
          child: CustomButton(
            text: 'Submit KYC',
            icon: Icons.verified_user_outlined,
            height: 52,
            borderRadius: 12,
            elevation: 1,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting
                ? null
                : _submitKyc,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DOCUMENT PICKER
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _pickDocument({
    required _DocumentType type,
  }) async {
    if (_isPickingDocument) return;

    final source = await showModalBottomSheet<_DocumentSource>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.upload_file_rounded,
                  size: 38,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 10),

                Text(
                  'Upload Document',
                  style: AppTextStyles.titleLarge,
                ),

                const SizedBox(height: 5),

                Text(
                  'Choose how you want to add your document.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),

                const SizedBox(height: 20),

                _buildUploadOption(
                  icon: Icons.folder_outlined,
                  title: 'Choose from Files',
                  subtitle: 'PDF, JPG, PNG or WEBP',
                  onTap: () {
                    Navigator.pop(
                      context,
                      _DocumentSource.files,
                    );
                  },
                ),

                const SizedBox(height: 10),

                _buildUploadOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a Photo',
                  subtitle: 'Capture your document',
                  onTap: () {
                    Navigator.pop(
                      context,
                      _DocumentSource.camera,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null || !mounted) return;

    setState(() {
      _isPickingDocument = true;
    });

    try {
      KycDocumentFile? selectedFile;

      if (source == _DocumentSource.files) {
        selectedFile = await _pickFromFiles();
      } else {
        selectedFile = await _pickFromCamera();
      }

      if (selectedFile == null || !mounted) return;

      if (selectedFile.sizeBytes > _maxFileSizeBytes) {
        _showMessage(
          'File size must not exceed 8 MB.',
          isError: true,
        );
        return;
      }

      setState(() {
        _setDocument(
          type: type,
          file: selectedFile!,
        );

        _clearDocumentError(type);
      });
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Unable to select the document. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingDocument = false;
        });
      }
    }
  }

  Future<KycDocumentFile?> _pickFromFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'pdf',
      ],
    );

    if (result.isEmpty) {
      return null;
    }

    final selected = result.single;

    final path = selected.path;

    if (path == null || path.isEmpty) {
      return null;
    }

    final extension = selected.extension?.toLowerCase() ?? '';
    final sizeBytes = File(path).lengthSync();

    return KycDocumentFile(
      path: path,
      name: selected.name,
      sizeBytes: sizeBytes,
      isImage: _isImageExtension(extension),
    );
  }

  Future<KycDocumentFile?> _pickFromCamera() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (image == null) return null;

    final file = File(image.path);

    final exists = await file.exists();

    if (!exists) return null;

    final size = await file.length();

    return KycDocumentFile(
      path: image.path,
      name: 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
      sizeBytes: size,
      isImage: true,
    );
  }

  bool _isImageExtension(String extension) {
    return extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'png' ||
        extension == 'webp';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DOCUMENT STATE
  // ═══════════════════════════════════════════════════════════════════════════

  void _setDocument({
    required _DocumentType type,
    required KycDocumentFile file,
  }) {
    switch (type) {
      case _DocumentType.tradeLicense:
        _tradeLicenseFile = file;

      case _DocumentType.authorizedId:
        _authorizedIdFile = file;

      case _DocumentType.vat:
        _vatFile = file;

      case _DocumentType.additional:
        _additionalFile = file;
    }
  }

  void _removeDocument({
    required _DocumentType type,
  }) {
    setState(() {
      switch (type) {
        case _DocumentType.tradeLicense:
          _tradeLicenseFile = null;
          _tradeLicenseError = null;

        case _DocumentType.authorizedId:
          _authorizedIdFile = null;
          _authorizedIdError = null;

        case _DocumentType.vat:
          _vatFile = null;
          _vatError = null;

        case _DocumentType.additional:
          _additionalFile = null;
          _additionalError = null;
      }
    });
  }

  void _clearDocumentError(_DocumentType type) {
    switch (type) {
      case _DocumentType.tradeLicense:
        _tradeLicenseError = null;

      case _DocumentType.authorizedId:
        _authorizedIdError = null;

      case _DocumentType.vat:
        _vatError = null;

      case _DocumentType.additional:
        _additionalError = null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPLOAD OPTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.border,
            ),
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
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _submitKyc() async {
    FocusScope.of(context).unfocus();

    _validateDocuments();

    final documentsValid =
        _tradeLicenseError == null &&
        _authorizedIdError == null &&
        _vatError == null &&
        _additionalError == null;

    if (!documentsValid) {
      _showMessage(
        'Please upload the required documents.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Temporary UI-only submission.
    //
    // API integration will be connected later.
    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    _showMessage(
      'KYC information is ready. API submission will be connected next.',
    );
  }

  void _validateDocuments() {
    setState(() {
      _tradeLicenseError =
          _tradeLicenseFile == null
              ? 'Trade License Copy is required.'
              : null;

      _authorizedIdError =
          _authorizedIdFile == null
              ? 'Authorized Person ID is required.'
              : null;

      _vatError = null;
      _additionalError = null;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError
              ? AppColors.error
              : AppColors.textPrimary,
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ENUMS
// ═════════════════════════════════════════════════════════════════════════════

enum _DocumentType {
  tradeLicense,
  authorizedId,
  vat,
  additional,
}

enum _DocumentSource {
  files,
  camera,
}