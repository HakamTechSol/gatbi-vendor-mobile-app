import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Services/api_exception.dart';
import '../../Account Setting/Get Profile/Controller/get_profile_controller.dart';
import '../../Account Setting/Get Profile/Models/get_profile_model.dart';
import '../../Authentication/Registration/Phone Rule/phone_code_dropdown.dart';

import '../../Authentication/Registration/Phone Rule/phone_rules_controller.dart';
import '../../Authentication/Registration/Phone Rule/phone_rules_model.dart';
import '../Controller/kyc_submit_controller.dart';
import '../Models/kyc_submit_model.dart';
import '../Reuse Widgets/kyc_status_badge.dart';
import '../Reuse Widgets/kyc_submission_status_card.dart';
import '../Services/kyc_document_file.dart';

import '../Reuse Widgets/kyc_document_upload_card.dart';
import '../Reuse Widgets/kyc_guidelines_card.dart';
import '../Reuse Widgets/kyc_header.dart';
import '../Reuse Widgets/kyc_help_card.dart';
import '../Reuse Widgets/kyc_section_card.dart';
import '../Reuse Widgets/kyc_timeline_card.dart';
import '../Reuse Widgets/kyc_validators.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final _storeNameController = TextEditingController();
  final _storeEmailController = TextEditingController();

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

  // ============================================================
  // VENDOR SETTINGS
  // ============================================================

  late Future<VendorSettingsModel> _settingsFuture;

  bool _isSettingsLoading = true;
  String? _settingsError;

  // ============================================================
  // COUNTRY
  // ============================================================

  String? _selectedCountryIsoCode = 'AE';

  String _selectedCountryDialCode = '+971';

  // ============================================================
  // PHONE RULES
  // ============================================================

  late final Future<PhoneRulesModel> _phoneRulesFuture;

  PhoneRuleItemModel? _selectedPhoneRule;

  bool _isPhoneRuleLoading = false;

  int _phoneRuleRequestId = 0;

  // ============================================================
  // DOCUMENTS
  // ============================================================

  KycDocumentFile? _tradeLicenseFile;
  KycDocumentFile? _authorizedIdFile;
  KycDocumentFile? _vatFile;
  KycDocumentFile? _additionalFile;

  String? _tradeLicenseError;
  String? _authorizedIdError;
  String? _vatError;
  String? _additionalError;

  // ============================================================
  // UI STATE
  // ============================================================

  int _currentStep = 0;

  bool _isSubmitting = false;

  KycSubmitModel? _kycSubmitResult;

  bool _isKycSubmitted = false;

  bool _isPickingDocument = false;

  final ImagePicker _imagePicker = ImagePicker();

  static const int _maxFileSizeBytes = 8 * 1024 * 1024;

  // ============================================================
  // INIT
  // ============================================================
  @override
  void initState() {
    super.initState();

    _settingsFuture = ref
        .read(vendorSettingsControllerProvider)
        .getVendorSettings();

    _phoneRulesFuture = ref.read(phoneRulesControllerProvider).getPhoneRules();

    _loadVendorSettings();

    _setPhoneDialCode(_selectedCountryDialCode);

    _loadInitialPhoneRule();
  }
  // ============================================================
  // LOAD INITIAL PHONE RULE
  // ============================================================

  Future<void> _loadInitialPhoneRule() async {
    final countryCode = _selectedCountryIsoCode?.trim();

    if (countryCode == null || countryCode.isEmpty) {
      return;
    }

    final requestId = ++_phoneRuleRequestId;

    setState(() {
      _selectedPhoneRule = null;
      _isPhoneRuleLoading = true;
    });

    try {
      final phoneRules = await _phoneRulesFuture;

      if (!mounted || requestId != _phoneRuleRequestId) {
        return;
      }

      PhoneRuleItemModel? matchedRule;

      for (final rule in phoneRules.phoneRules) {
        final ruleCountryCode = rule.countryCode?.trim().toUpperCase();

        if (ruleCountryCode == countryCode.toUpperCase()) {
          matchedRule = rule;
          break;
        }
      }

      setState(() {
        _selectedPhoneRule = matchedRule;
        _isPhoneRuleLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _phoneRuleRequestId) {
        return;
      }

      setState(() {
        _selectedPhoneRule = null;
        _isPhoneRuleLoading = false;
      });
    }
  }

  // ============================================================
  // UPDATE PHONE RULE FOR COUNTRY
  // ============================================================

  Future<void> _updatePhoneRuleForCountry(String? countryCode) async {
    if (!mounted) {
      return;
    }

    final requestId = ++_phoneRuleRequestId;

    if (countryCode == null || countryCode.trim().isEmpty) {
      setState(() {
        _selectedPhoneRule = null;
        _isPhoneRuleLoading = false;
      });

      return;
    }

    final normalizedCountryCode = countryCode.trim().toUpperCase();

    setState(() {
      _selectedPhoneRule = null;
      _isPhoneRuleLoading = true;
    });

    try {
      final phoneRules = await _phoneRulesFuture;

      if (!mounted || requestId != _phoneRuleRequestId) {
        return;
      }

      PhoneRuleItemModel? matchedRule;

      for (final rule in phoneRules.phoneRules) {
        final ruleCountryCode = rule.countryCode?.trim().toUpperCase();

        if (ruleCountryCode == normalizedCountryCode) {
          matchedRule = rule;
          break;
        }
      }

      setState(() {
        _selectedPhoneRule = matchedRule;
        _isPhoneRuleLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        _formKey.currentState?.validate();
      });
    } catch (_) {
      if (!mounted || requestId != _phoneRuleRequestId) {
        return;
      }

      setState(() {
        _selectedPhoneRule = null;
        _isPhoneRuleLoading = false;
      });
    }
  }

  // ============================================================
  // LOAD VENDOR SETTINGS
  // ============================================================

  Future<void> _loadVendorSettings() async {
    if (mounted) {
      setState(() {
        _isSettingsLoading = true;
        _settingsError = null;
      });
    }

    try {
      final settings = await _settingsFuture;

      if (!mounted) return;

      _fillSettingsData(settings);

      setState(() {
        _isSettingsLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSettingsLoading = false;
        _settingsError = 'Unable to load vendor settings. Please try again.';
      });
    }
  }

  // ============================================================
  // RETRY SETTINGS
  // ============================================================

  Future<void> _retryVendorSettings() async {
    if (!mounted) return;

    setState(() {
      _settingsFuture = ref
          .read(vendorSettingsControllerProvider)
          .getVendorSettings();
    });

    await _loadVendorSettings();
  }

  // ============================================================
  // FILL SETTINGS DATA
  // ============================================================
  //
  // Store Name / Store Email:
  // Auto-filled + read-only.
  //
  // Owner Name / Email / Phone:
  // NOT auto-filled.
  // User enters them manually.
  // ============================================================

  void _fillSettingsData(VendorSettingsModel settings) {
    final merchant = settings.merchant;

    // ============================================================
    // STORE
    // ============================================================

    _storeNameController.text = merchant?.name?.trim() ?? '';
    _storeEmailController.text = merchant?.email?.trim() ?? '';

    // ============================================================
    // OWNER FIELDS
    //
    // Intentionally empty.
    // ============================================================

    _ownerNameController.clear();
    _ownerEmailController.clear();

    // ============================================================
    // DEFAULT COUNTRY
    // ============================================================

    _selectedCountryIsoCode = 'AE';
    _selectedCountryDialCode = '+971';

    // ------------------------------------------------------------
    // Set +971 inside phone field
    // ------------------------------------------------------------

    _setPhoneDialCode(_selectedCountryDialCode);
    _updatePhoneRuleForCountry(_selectedCountryIsoCode);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isSettingsLoading
            ? _buildSettingsLoading()
            : _settingsError != null
            ? _buildSettingsError()
            : LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 600
                      ? 24.0
                      : 16.0;

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
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KycHeader(
                              status: _isKycSubmitted
                                  ? KycStatus.pending
                                  : KycStatus.pending,
                            ),

                            const SizedBox(height: 20),

                            if (_isKycSubmitted)
                              _buildKycSubmittedState()
                            else ...[
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

  // ============================================================
  // KYC SUBMITTED STATE
  // ============================================================

  Widget _buildKycSubmittedState() {
    final result = _kycSubmitResult;

    return KycSubmissionStatusCard(
      status: result?.kycStatus,
      message: result?.message,
    );
  }

  // ============================================================
  // SETTINGS LOADING
  // ============================================================

  Widget _buildSettingsLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(height: 14),
          Text(
            'Loading vendor information...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS ERROR
  // ============================================================

  Widget _buildSettingsError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Unable to Load Information',
                style: AppTextStyles.titleMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                _settingsError ?? 'Something went wrong. Please try again.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 18),

              CustomButton(
                text: 'Try Again',
                icon: Icons.refresh_rounded,
                height: 48,
                borderRadius: 12,
                elevation: 1,
                onPressed: _retryVendorSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP INDICATOR
  // ============================================================

  Widget _buildStepIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: _currentStep > 0 ? AppColors.primary : AppColors.border,
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
            color: selected ? AppColors.primary : AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 19)
                : Text(
                    '$number',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: selected ? Colors.white : AppColors.primary,
                    ),
                  ),
          ),
        ),

        const SizedBox(width: 8),

        if (MediaQuery.sizeOf(context).width >= 430)
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // STEP 1
  // ============================================================

  Widget _buildInformationStep() {
    return Form(
      key: _formKey,
      child: KycSectionCard(
        title: 'Business & Owner Details',
        subtitle:
            'Review your registered information and provide the remaining compliance details.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // STORE NAME + STORE EMAIL
            // ========================================================
            _buildResponsiveFields(
              first: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _storeNameController,
                  label: 'Store Name *',
                  hintText: 'Store name',
                  readOnly: true,
                  fillColor: AppColors.inputDisabledBackground,
                  textStyle: AppTextStyles.authInput.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  validator: KycValidators.storeName,
                ),
                example: 'Example: Beauty Store',
              ),
              second: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _storeEmailController,
                  label: 'Store Email *',
                  hintText: 'Store email',
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  fillColor: AppColors.inputDisabledBackground,
                  textStyle: AppTextStyles.authInput.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  validator: KycValidators.storeEmail,
                ),
                example: 'Example: store@example.com',
              ),
            ),

            const SizedBox(height: 18),

            // ========================================================
            // OWNER NAME + EMAIL
            // ========================================================
            _buildResponsiveFields(
              first: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _ownerNameController,
                  label: 'Owner Full Name *',
                  hintText: 'Enter owner full name',
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.ownerName,
                ),
                example: 'Example: Ahmed Ali',
              ),
              second: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _ownerEmailController,
                  label: 'Owner Email',
                  hintText: 'Enter owner email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.ownerEmail,
                ),
                example: 'Example: ahmed@example.com',
              ),
            ),

            const SizedBox(height: 18),

            // ========================================================
            // PHONE + DESIGNATION
            // ========================================================
            _buildResponsiveFields(
              first: _buildPhoneField(),
              second: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _designationController,
                  label: 'Designation / Role',
                  hintText: 'e.g. Owner, Director, Manager',
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.designation,
                ),
                example: 'Example: Owner / Director / Manager',
              ),
            ),

            const SizedBox(height: 18),

            // ========================================================
            // TRADE LICENSE + EXPIRY
            // ========================================================
            _buildResponsiveFields(
              first: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _tradeLicenseController,
                  label: 'Trade License Number *',
                  hintText: 'Enter trade license number',
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.tradeLicense,
                ),
                example: 'Example: TL-DXB-12345',
              ),
              second: _buildExpiryField(),
            ),

            const SizedBox(height: 18),

            // ========================================================
            // TRN + WEBSITE
            // ========================================================
            _buildResponsiveFields(
              first: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _trnController,
                  label: 'Tax Registration Number (TRN)',
                  hintText: 'Enter 15 digit TRN',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: KycValidators.trnFormatters,
                  validator: KycValidators.trn,
                ),
                example: 'Example: 100123456789003',
              ),
              second: _buildFieldWithExample(
                field: CustomTextField(
                  controller: _websiteController,
                  label: 'Company Website',
                  hintText: 'https://example.com',
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.website,
                ),
                example: 'Example: https://mystore.ae',
              ),
            ),

            const SizedBox(height: 18),

            // ========================================================
            // ADDRESS
            // ========================================================
            _buildFieldWithExample(
              field: CustomTextField(
                controller: _businessAddressController,
                label: 'Registered Business Address *',
                hintText: 'Enter complete registered business address',
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                validator: KycValidators.businessAddress,
              ),
              example: 'Example: Office 101, Business Bay, Dubai',
            ),

            const SizedBox(height: 18),

            // ========================================================
            // NOTES
            // ========================================================
            _buildFieldWithExample(
              field: CustomTextField(
                controller: _notesController,
                label: 'Notes for Compliance Team',
                hintText:
                    'Any important remarks about your business or documents',
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                validator: KycValidators.notes,
              ),
              example: 'Example: Additional information about your documents',
            ),

            const SizedBox(height: 24),

            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldWithExample({
    required Widget field,
    required String example,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field,

        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppColors.iconSecondary,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  example,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RESPONSIVE FIELDS
  // ============================================================

  Widget _buildResponsiveFields({
    required Widget first,
    required Widget second,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [first, const SizedBox(height: 18), second],
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

  // ============================================================
  // PHONE FIELD
  // ============================================================

  Widget _buildPhoneField() {
    final rule = _selectedPhoneRule;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Owner Phone *', style: AppTextStyles.authFieldLabel),

        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // COUNTRY CODE DROPDOWN
            // ========================================================
            SizedBox(
              width: 125,
              child: PhoneCodeDropdown(
                value: _selectedCountryIsoCode,

                onChanged: (_) {},

                onCountryChanged: (country) {
                  if (!mounted || country == null) {
                    return;
                  }

                  final isoCode = country.code?.trim();
                  final dialCode = country.dialCode?.trim();

                  if (isoCode == null || isoCode.isEmpty) {
                    return;
                  }

                  if (dialCode == null || dialCode.isEmpty) {
                    return;
                  }

                  // Previous country dial code.
                  final previousDialCode = _selectedCountryDialCode;

                  // Normalize new dial code.
                  final normalizedDialCode = dialCode.startsWith('+')
                      ? dialCode
                      : '+$dialCode';

                  setState(() {
                    _selectedCountryIsoCode = isoCode.toUpperCase();

                    _selectedCountryDialCode = normalizedDialCode;
                  });

                  // --------------------------------------------------
                  // Put new dial code inside phone field.
                  // Same approach as RegisterScreen.
                  // --------------------------------------------------

                  _setPhoneDialCode(
                    normalizedDialCode,
                    previousDialCode: previousDialCode,
                  );

                  // --------------------------------------------------
                  // Load phone rule for selected country.
                  // --------------------------------------------------

                  _updatePhoneRuleForCountry(isoCode);
                },
              ),
            ),

            const SizedBox(width: 8),

            // ========================================================
            // PHONE NUMBER FIELD
            // ========================================================
            Expanded(
              child: CustomTextField(
                controller: _ownerPhoneController,

                keyboardType: TextInputType.phone,

                textInputAction: TextInputAction.next,

                hintText: rule?.example != null
                    ? 'Example: ${rule!.example}'
                    : 'Enter phone number',

                // IMPORTANT:
                // Dial code is already inside controller.
                prefixText: null,

                validator: _validateOwnerPhone,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // ==========================================================
        // PHONE RULE INFO
        // ==========================================================
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 13,
              color: AppColors.iconSecondary,
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                _phoneRuleHelperText(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // PHONE RULE HELPER TEXT
  // ============================================================

  String _phoneRuleHelperText() {
    final rule = _selectedPhoneRule;

    if (_isPhoneRuleLoading) {
      return 'Loading phone validation rules...';
    }

    if (rule == null) {
      return 'Select a country to load phone validation rules.';
    }

    final minLength = rule.minLength;
    final maxLength = rule.maxLength;
    final example = rule.example;

    String lengthText;

    if (minLength != null && maxLength != null) {
      if (minLength == maxLength) {
        lengthText = '$minLength digits';
      } else {
        lengthText = '$minLength-$maxLength digits';
      }
    } else if (minLength != null) {
      lengthText = 'at least $minLength digits';
    } else if (maxLength != null) {
      lengthText = 'up to $maxLength digits';
    } else {
      lengthText = 'valid phone length';
    }

    final parts = <String>[
      _selectedCountryDialCode,
      lengthText,
      if (example != null && example.isNotEmpty) 'Example: $example',
    ];

    return parts.join(' • ');
  }

  // ============================================================
  // OWNER PHONE VALIDATION
  // ============================================================
  //
  // IMPORTANT:
  //
  // Field:
  // +92 3212345678
  //
  // Validator sirf:
  // 3212345678
  //
  // ko validate karega.
  //
  // +92 length mein count nahi hoga.
  // ============================================================

  String? _validateOwnerPhone(String? value) {
    final rawPhone = value?.trim() ?? '';

    // ============================================================
    // REQUIRED
    // ============================================================

    if (rawPhone.isEmpty) {
      return 'Owner phone number is required.';
    }

    // ============================================================
    // COUNTRY
    // ============================================================

    final countryCode = _selectedCountryIsoCode?.trim();

    if (countryCode == null || countryCode.isEmpty) {
      return 'Please select a country.';
    }

    // ============================================================
    // DIAL CODE
    // ============================================================

    final dialCode = _selectedCountryDialCode.trim();

    if (dialCode.isEmpty) {
      return 'Please select a valid country code.';
    }

    // ============================================================
    // REMOVE DIAL CODE
    //
    // UI:
    // +92 3212345678
    //
    // LOCAL:
    // 3212345678
    // ============================================================

    var phone = rawPhone;

    if (phone.startsWith(dialCode)) {
      phone = phone.substring(dialCode.length).trim();
    }

    // ============================================================
    // REMOVE FORMATTING
    // ============================================================

    phone = phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // ============================================================
    // REQUIRED LOCAL NUMBER
    // ============================================================

    if (phone.isEmpty) {
      return 'Phone number is required.';
    }

    // ============================================================
    // DIGITS ONLY
    // ============================================================

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must contain digits only.';
    }

    // ============================================================
    // LEADING ZERO
    // ============================================================

    if (phone.startsWith('0')) {
      return 'Enter the phone number without the leading 0.';
    }

    // ============================================================
    // PHONE RULE FROM API
    // ============================================================

    final rule = _selectedPhoneRule;

    if (rule == null) {
      if (_isPhoneRuleLoading) {
        return 'Phone validation rules are still loading.';
      }

      return 'Phone validation rule is not available for this country.';
    }

    final minLength = rule.minLength;
    final maxLength = rule.maxLength;
    final example = rule.example;

    final phoneLength = phone.length;

    // ============================================================
    // MINIMUM LENGTH
    // ============================================================

    if (minLength != null && phoneLength < minLength) {
      if (minLength == maxLength) {
        return example != null
            ? 'Phone number must be $minLength digits. '
                  'Example: $example'
            : 'Phone number must be $minLength digits.';
      }

      return example != null
          ? 'Phone number must be at least $minLength digits. '
                'Example: $example'
          : 'Phone number must be at least $minLength digits.';
    }

    // ============================================================
    // MAXIMUM LENGTH
    // ============================================================

    if (maxLength != null && phoneLength > maxLength) {
      if (minLength == maxLength) {
        return example != null
            ? 'Phone number must be $maxLength digits. '
                  'Example: $example'
            : 'Phone number must be $maxLength digits.';
      }

      final rangeText = minLength != null
          ? '$minLength-$maxLength'
          : 'up to $maxLength';

      return example != null
          ? 'Phone number must be $rangeText digits. '
                'Example: $example'
          : 'Phone number must be $rangeText digits.';
    }

    return null;
  }

  // ============================================================
  // SET PHONE DIAL CODE
  // ============================================================

  void _setPhoneDialCode(String dialCode, {String? previousDialCode}) {
    var normalizedDialCode = dialCode.trim();

    if (normalizedDialCode.isEmpty) {
      return;
    }

    if (!normalizedDialCode.startsWith('+')) {
      normalizedDialCode = '+$normalizedDialCode';
    }

    var currentValue = _ownerPhoneController.text.trim();

    // ============================================================
    // REMOVE PREVIOUS COUNTRY DIAL CODE
    // ============================================================

    if (previousDialCode != null && previousDialCode.isNotEmpty) {
      var normalizedPreviousDialCode = previousDialCode.trim();

      if (!normalizedPreviousDialCode.startsWith('+')) {
        normalizedPreviousDialCode = '+$normalizedPreviousDialCode';
      }

      if (currentValue.startsWith(normalizedPreviousDialCode)) {
        currentValue = currentValue
            .substring(normalizedPreviousDialCode.length)
            .trim();
      }
    }

    // ============================================================
    // IF ALREADY USING NEW DIAL CODE
    // ============================================================

    if (currentValue.startsWith(normalizedDialCode)) {
      return;
    }

    // ============================================================
    // REMOVE FORMATTING
    // ============================================================

    currentValue = currentValue
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // ============================================================
    // REMOVE LEADING ZERO
    // ============================================================

    currentValue = currentValue.replaceFirst(RegExp(r'^0+'), '');

    // ============================================================
    // FINAL FIELD VALUE
    // ============================================================

    final newValue = currentValue.isEmpty
        ? '$normalizedDialCode '
        : '$normalizedDialCode $currentValue';

    _ownerPhoneController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: newValue.length),
      composing: TextRange.empty,
    );
  }

  // ============================================================
  // EXPIRY
  // ============================================================

  Widget _buildExpiryField() {
    return CustomTextField(
      controller: _tradeLicenseExpiryController,
      label: 'Trade License Expiry *',
      hintText: 'yyyy/mm/dd',
      readOnly: true,
      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 19),
      onTap: _selectExpiryDate,
      validator: KycValidators.tradeLicenseExpiry,
    );
  }

  // ============================================================
  // EXPIRY DATE PICKER
  // ============================================================

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,

      // ----------------------------------------------------------
      // DEFAULT SELECTED DATE
      // ----------------------------------------------------------
      initialDate: today.add(const Duration(days: 30)),

      // ----------------------------------------------------------
      // EXPIRY MUST BE A FUTURE DATE
      // ----------------------------------------------------------
      firstDate: today.add(const Duration(days: 1)),

      // ----------------------------------------------------------
      // MAXIMUM 20 YEARS
      // ----------------------------------------------------------
      lastDate: DateTime(today.year + 20, 12, 31),

      helpText: 'Select Trade License Expiry',

      cancelText: 'Cancel',

      confirmText: 'Select',

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    // ============================================================
    // FORMAT DATE
    //
    // UI:
    // yyyy/mm/dd
    //
    // Example:
    // 2027/12/31
    // ============================================================

    final year = selectedDate.year.toString();

    final month = selectedDate.month.toString().padLeft(2, '0');

    final day = selectedDate.day.toString().padLeft(2, '0');

    final formattedDate = '$year/$month/$day';

    // ============================================================
    // SET FIELD VALUE
    // ============================================================

    setState(() {
      _tradeLicenseExpiryController.text = formattedDate;
    });

    // ============================================================
    // REVALIDATE FORM
    // ============================================================

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _formKey.currentState?.validate();
    });
  }

  // ============================================================
  // NEXT
  // ============================================================

  void _goToDocuments() {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      _showMessage('Please complete the highlighted fields.', isError: true);

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

  // ============================================================
  // STEP 2
  // ============================================================

  Widget _buildDocumentsStep() {
    return KycSectionCard(
      title: 'Legal Document Uploads',
      subtitle: 'Upload clear and valid documents. Maximum 8 MB per document.',
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

  // ============================================================
  // DOCUMENT GRID
  // ============================================================

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
            onUpload: () => _pickDocument(type: _DocumentType.tradeLicense),
            onRemove: _tradeLicenseFile == null
                ? null
                : () => _removeDocument(type: _DocumentType.tradeLicense),
          ),

          KycDocumentUploadCard(
            title: 'Authorized Person ID',
            required: true,
            file: _authorizedIdFile,
            errorText: _authorizedIdError,
            onUpload: () => _pickDocument(type: _DocumentType.authorizedId),
            onRemove: _authorizedIdFile == null
                ? null
                : () => _removeDocument(type: _DocumentType.authorizedId),
          ),

          KycDocumentUploadCard(
            title: 'VAT / Tax Registration',
            file: _vatFile,
            errorText: _vatError,
            onUpload: () => _pickDocument(type: _DocumentType.vat),
            onRemove: _vatFile == null
                ? null
                : () => _removeDocument(type: _DocumentType.vat),
          ),

          KycDocumentUploadCard(
            title: 'Additional Supporting Document',
            file: _additionalFile,
            errorText: _additionalError,
            onUpload: () => _pickDocument(type: _DocumentType.additional),
            onRemove: _additionalFile == null
                ? null
                : () => _removeDocument(type: _DocumentType.additional),
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

  // ============================================================
  // STEP NAVIGATION
  // ============================================================

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
            icon: const Icon(Icons.arrow_back_rounded),
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
            onPressed: _isSubmitting ? null : _submitKyc,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DOCUMENT PICKER
  // ============================================================

  Future<void> _pickDocument({required _DocumentType type}) async {
    if (_isPickingDocument || _isSubmitting) return;

    final source = await showModalBottomSheet<_DocumentSource>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.upload_file_rounded,
                  size: 38,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 10),

                Text('Upload Document', style: AppTextStyles.titleLarge),

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
                    Navigator.pop(context, _DocumentSource.files);
                  },
                ),

                const SizedBox(height: 10),

                _buildUploadOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a Photo',
                  subtitle: 'Capture your document',
                  onTap: () {
                    Navigator.pop(context, _DocumentSource.camera);
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
        _showMessage('File size must not exceed 8 MB.', isError: true);
        return;
      }

      setState(() {
        _setDocument(type: type, file: selectedFile!);

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

  // ============================================================
  // PICK FROM FILES
  // ============================================================

  Future<KycDocumentFile?> _pickFromFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
    );

    if (result.isEmpty) return null;

    final selected = result.single;

    final path = selected.path;

    if (path == null || path.isEmpty) {
      return null;
    }

    final extension = selected.extension?.toLowerCase() ?? '';

    final file = File(path);

    final exists = await file.exists();

    if (!exists) return null;

    final sizeBytes = await file.length();

    return KycDocumentFile(
      path: path,
      name: selected.name,
      sizeBytes: sizeBytes,
      isImage: _isImageExtension(extension),
    );
  }

  // ============================================================
  // PICK FROM CAMERA
  // ============================================================

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

  // ============================================================
  // DOCUMENT STATE
  // ============================================================

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

  void _removeDocument({required _DocumentType type}) {
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

  // ============================================================
  // UPLOAD OPTION
  // ============================================================

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
            border: Border.all(color: AppColors.border),
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
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleSmall),

                    const SizedBox(height: 3),

                    Text(subtitle, style: AppTextStyles.caption),
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

  // ============================================================
  // BUILD API PHONE
  // ============================================================
  //
  // UI:
  // +92 3212345678
  //
  // API:
  // +923212345678
  // ============================================================

  String? _buildOwnerPhoneForApi() {
    final dialCode = _selectedCountryDialCode.trim();

    if (dialCode.isEmpty) {
      return null;
    }

    var phone = _ownerPhoneController.text.trim();

    if (phone.isEmpty) {
      return null;
    }

    // ============================================================
    // REMOVE DIAL CODE
    //
    // UI:
    // +92 3212345678
    //
    // AFTER:
    // 3212345678
    // ============================================================

    if (phone.startsWith(dialCode)) {
      phone = phone.substring(dialCode.length).trim();
    }

    // ============================================================
    // REMOVE FORMATTING
    // ============================================================

    phone = phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // ============================================================
    // REMOVE LEADING ZERO
    // ============================================================

    phone = phone.replaceFirst(RegExp(r'^0+'), '');

    if (phone.isEmpty) {
      return null;
    }

    // ============================================================
    // DIGITS ONLY
    // ============================================================

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return null;
    }

    // ============================================================
    // API FORMAT
    //
    // UI:
    // +92 3212345678
    //
    // API:
    // +923212345678
    // ============================================================

    return '$dialCode$phone';
  }

  // ============================================================
  // SUBMIT KYC
  // ============================================================

  Future<void> _submitKyc() async {
    if (_isSubmitting || _isKycSubmitted) {
      return;
    }

    FocusScope.of(context).unfocus();

    // ============================================================
    // STEP 1 FORM VALIDATION
    // ============================================================
    //
    // Form sirf Step 1 par mounted hota hai.
    // Step 2 par Form AnimatedSwitcher ki wajah se remove ho jata hai.
    //
    // Isliye Step 2 se submit karte waqt form validate nahi karna.
    // ============================================================

    if (_currentStep == 0) {
      final formValid = _formKey.currentState?.validate() ?? false;

      if (!formValid) {
        _showMessage('Please complete the highlighted fields.', isError: true);

        return;
      }
    }

    // ============================================================
    // DOCUMENT VALIDATION
    // ============================================================

    _validateDocuments();

    final documentsValid =
        _tradeLicenseError == null &&
        _authorizedIdError == null &&
        _vatError == null &&
        _additionalError == null;

    if (!documentsValid) {
      _showMessage('Please upload the required documents.', isError: true);

      return;
    }

    // ============================================================
    // REQUIRED FILE SAFETY CHECK
    // ============================================================

    final tradeLicenseFile = _tradeLicenseFile;
    final authorizedIdFile = _authorizedIdFile;

    if (tradeLicenseFile == null || authorizedIdFile == null) {
      _showMessage('Please upload the required documents.', isError: true);

      return;
    }

    // ============================================================
    // FORM DATA
    // ============================================================

    final ownerName = _ownerNameController.text.trim();

    final ownerEmail = _ownerEmailController.text.trim();

    final designation = _designationController.text.trim();

    final tradeLicenseNumber = _tradeLicenseController.text.trim();

    final tradeLicenseExpiry = _tradeLicenseExpiryController.text.trim();

    final trn = _trnController.text.trim();

    final website = _websiteController.text.trim();

    final businessAddress = _businessAddressController.text.trim();

    final notes = _notesController.text.trim();

    // ============================================================
    // PHONE COUNTRY SAFETY
    // ============================================================

    final phoneCountry = _selectedCountryIsoCode?.trim();

    final phoneDialCode = _selectedCountryDialCode.trim();

    if (phoneCountry == null || phoneCountry.isEmpty) {
      _showMessage('Unable to determine phone country.', isError: true);
      return;
    }

    if (phoneDialCode.isEmpty) {
      _showMessage('Unable to determine phone dial code.', isError: true);
      return;
    }

    // ============================================================
    // PHONE RULE SAFETY
    // ============================================================

    final phoneRule = _selectedPhoneRule;

    if (_isPhoneRuleLoading) {
      _showMessage('Please wait while phone rules are loading.', isError: true);
      return;
    }

    if (phoneRule == null) {
      _showMessage(
        'Phone number rules are not available for the selected country.',
        isError: true,
      );
      return;
    }

    // ============================================================
    // PHONE API VALUE
    // ============================================================

    final apiOwnerPhone = _buildOwnerPhoneForApi();

    if (apiOwnerPhone == null || apiOwnerPhone.isEmpty) {
      _showMessage('Please enter a valid phone number.', isError: true);
      return;
    }

    // ============================================================
    // DATE CONVERSION
    // ============================================================

    final apiExpiryDate = _convertExpiryDateForApi(tradeLicenseExpiry);

    if (apiExpiryDate == null) {
      _showMessage('Invalid trade license expiry date.', isError: true);
      return;
    }

    // ============================================================
    // START SUBMITTING
    // ============================================================

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(kycSubmitControllerProvider)
          .submitKyc(
            ownerName: ownerName,
            ownerEmail: ownerEmail.isEmpty ? null : ownerEmail,
            ownerPhone: apiOwnerPhone,
            phoneCountry: phoneCountry,
            authorizedPersonDesignation: designation.isEmpty
                ? null
                : designation,
            tradeLicenseNumber: tradeLicenseNumber,
            tradeLicenseExpiry: apiExpiryDate,
            taxRegistrationNumber: trn.isEmpty ? null : trn,
            businessAddress: businessAddress,
            website: website.isEmpty ? null : website,
            notes: notes.isEmpty ? null : notes,
            tradeLicenseFile: tradeLicenseFile,
            authorizedIdFile: authorizedIdFile,
            taxCertificateFile: _vatFile,
            supportingDocumentFile: _additionalFile,
          );

      if (!mounted) {
        return;
      }

      if (result.success) {
        setState(() {
          _kycSubmitResult = result;
          _isKycSubmitted = true;
          _isSubmitting = false;
        });

        _showMessage(result.message ?? 'KYC submitted successfully.');

        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(
        result.message ?? 'Unable to submit KYC. Please try again.',
        isError: true,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(_getKycSubmitErrorMessage(error), isError: true);
    }
  }

  // ============================================================
  // CONVERT EXPIRY DATE FOR API
  // ============================================================
  //
  // UI FORMAT:
  // YYYY/MM/DD
  //
  // Example:
  // 2027/12/31
  //
  // API FORMAT:
  // YYYY-MM-DD
  //
  // Example:
  // 2027-12-31
  // ============================================================

  String? _convertExpiryDateForApi(String value) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      return null;
    }

    // ------------------------------------------------------------
    // STRICT UI FORMAT
    // YYYY/MM/DD
    // ------------------------------------------------------------

    final match = RegExp(r'^(\d{4})/(\d{2})/(\d{2})$').firstMatch(normalized);

    if (match == null) {
      return null;
    }

    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);

    if (year == null || month == null || day == null) {
      return null;
    }

    // ------------------------------------------------------------
    // BASIC RANGE
    // ------------------------------------------------------------

    if (year < 2000 || month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }

    // ------------------------------------------------------------
    // ACTUAL CALENDAR DATE
    //
    // Example:
    // 2027/02/31 => invalid
    // ------------------------------------------------------------

    final date = DateTime(year, month, day);

    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    // ------------------------------------------------------------
    // MUST BE FUTURE
    // ------------------------------------------------------------

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    if (!date.isAfter(today)) {
      return null;
    }

    // ------------------------------------------------------------
    // API FORMAT
    // YYYY-MM-DD
    // ------------------------------------------------------------

    return '$year-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }
  // ============================================================
  // KYC SUBMIT ERROR MESSAGE
  // ============================================================

  String _getKycSubmitErrorMessage(Object error) {
    if (error is ApiException) {
      final message = error.message.trim();

      if (message.isNotEmpty) {
        return message;
      }
    }

    return 'Unable to submit KYC. Please try again.';
  }

  // ============================================================
  // VALIDATE DOCUMENTS
  // ============================================================

  void _validateDocuments() {
    setState(() {
      _tradeLicenseError = _tradeLicenseFile == null
          ? 'Trade License Copy is required.'
          : null;

      _authorizedIdError = _authorizedIdFile == null
          ? 'Authorized Person ID is required.'
          : null;

      // Optional documents
      _vatError = null;
      _additionalError = null;
    });
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
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
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

// ============================================================
// ENUMS
// ============================================================

enum _DocumentType { tradeLicense, authorizedId, vat, additional }

enum _DocumentSource { files, camera }
