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
import '../../../Services/dio.dart';
import '../../../Services/file_download_service.dart';

import '../../Account Setting/Get Profile/Controller/get_profile_controller.dart';
import '../../Account Setting/Get Profile/Models/get_profile_model.dart';

import '../../Authentication/Registration/Phone Rule/phone_code_dropdown.dart';
import '../../Authentication/Registration/Phone Rule/phone_rules_controller.dart';
import '../../Authentication/Registration/Phone Rule/phone_rules_model.dart';

import '../Controller/kyc_document_controller.dart';
import '../Controller/kyc_submit_controller.dart';
import '../Controller/vendor_kyc_controller.dart';

import '../Models/vendor_kyc_detail_model.dart';
import '../Models/vendor_kyc_document_model.dart';

import '../Reuse Widgets/kyc_shimmar.dart';
import '../Reuse Widgets/kyc_status_badge.dart';
import '../Services/kyc_document_file.dart';

// Reuse Widgets
import '../Reuse Widgets/kyc_details_card.dart';
import '../Reuse Widgets/kyc_document_preview_dialog.dart';
import '../Reuse Widgets/kyc_document_upload_card.dart';
import '../Reuse Widgets/kyc_documents_section.dart';
import '../Reuse Widgets/kyc_form_field.dart';
import '../Reuse Widgets/kyc_form_field_with_example.dart';
import '../Reuse Widgets/kyc_guidelines_card.dart';
import '../Reuse Widgets/kyc_header.dart';
import '../Reuse Widgets/kyc_help_card.dart';
import '../Reuse Widgets/kyc_responsive_fields.dart';
import '../Reuse Widgets/kyc_section_card.dart';
import '../Reuse Widgets/kyc_status_card.dart';
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
  // SETTINGS
  // ============================================================

  late Future<VendorSettingsModel> _settingsFuture;

  bool _isSettingsLoading = true;
  String? _settingsError;

  // ============================================================
  // PHONE
  // ============================================================

  late final Future<PhoneRulesModel> _phoneRulesFuture;

  PhoneRuleItemModel? _selectedPhoneRule;

  bool _isPhoneRuleLoading = false;

  int _phoneRuleRequestId = 0;

  String? _selectedCountryIsoCode = 'AE';

  String _selectedCountryDialCode = '+971';

  // ============================================================
  // KYC STATE (GET)
  // ============================================================

  bool _isKycLoading = true;

  bool _kycExists = false;

  bool _isDownloading = false;

  String? _kycStatus;

  String? _kycStatusLabel;

  String? _kycMessage;

  String? _kycRejectionReason;

  int? _kycSubmissionCount;

  VendorKycDetailModel? _kycDetail;

  List<VendorKycDocumentModel> _kycDocuments = [];

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
  // UI
  // ============================================================

  int _currentStep = 0;

  bool _isSubmitting = false;

  bool _isPickingDocument = false;

  final ImagePicker _imagePicker = ImagePicker();

  static const int _maxFileSizeBytes = 8 * 1024 * 1024;

  // ============================================================
  // REJECTED
  // ============================================================

  bool get _isRejectedStatus {
    switch (_kycStatus?.trim().toLowerCase()) {
      case 'rejected':
      case 'declined':
      case 'denied':
        return true;

      default:
        return false;
    }
  }

  // ============================================================
  // NOT SUBMITTED
  //
  // IMPORTANT:
  //
  // API can return:
  //
  // status       = pending
  // status_label = not_submitted
  //
  // In this case FORM MUST BE VISIBLE.
  // ============================================================

  bool get _isNotSubmitted {
    final label = _kycStatusLabel?.trim().toLowerCase();

    switch (label) {
      case 'not_submitted':
      case 'not-submitted':
      case 'not submitted':
      case 'not submitted yet':
      case 'not submitted yet.':
        return true;

      default:
        return false;
    }
  }

  // ============================================================
  // DOWNLOADING
  // ============================================================

  void _setDownloading(bool value) {
    if (!mounted) return;

    setState(() {
      _isDownloading = value;
    });
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadKyc();
    });
  }

  // ============================================================
  // LOAD KYC
  // ============================================================

  Future<bool> _loadKyc({bool showError = true}) async {
    if (mounted) {
      setState(() {
        _isKycLoading = true;
      });
    }

    try {
      final result = await ref.read(vendorKycControllerProvider).getVendorKyc();

      if (!mounted) return false;

      final kyc = result.kyc;

      final rawStatus = kyc?.status?.trim().toLowerCase();

      final rawStatusLabel = kyc?.statusLabel?.trim().toLowerCase();

      // ========================================================
      // IMPORTANT
      //
      // status_label has higher priority than status.
      //
      // Example:
      //
      // status       = pending
      // status_label = not_submitted
      //
      // This means user has NOT submitted KYC yet.
      // Therefore FORM must be visible.
      // ========================================================

      final isNotSubmitted = _isNotSubmittedValue(rawStatusLabel);

      final hasActiveKyc = isNotSubmitted
          ? false
          : _isActiveKycStatus(rawStatus);

      setState(() {
        _isKycLoading = false;

        _kycExists = hasActiveKyc;

        _kycStatus = kyc?.status?.trim();

        _kycStatusLabel = kyc?.statusLabel?.trim();

        _kycMessage = kyc?.statusLabel?.trim();

        _kycRejectionReason = kyc?.rejectionReason?.trim();

        _kycSubmissionCount = kyc?.submissionCount;

        _kycDetail = kyc?.detail;

        _kycDocuments = List<VendorKycDocumentModel>.from(
          kyc?.documents ?? const <VendorKycDocumentModel>[],
        );
      });

      // ========================================================
      // NOT SUBMITTED
      //
      // Clear any old form data because this is a fresh KYC.
      // ========================================================

      if (isNotSubmitted) {
        _currentStep = 0;

        _tradeLicenseFile = null;
        _authorizedIdFile = null;
        _vatFile = null;
        _additionalFile = null;

        _tradeLicenseError = null;
        _authorizedIdError = null;
        _vatError = null;
        _additionalError = null;
      }

      // ========================================================
      // REJECTED
      //
      // Show form again and restore previous submitted data.
      // ========================================================

      if (rawStatus == 'rejected' ||
          rawStatus == 'declined' ||
          rawStatus == 'denied') {
        _fillKycDetailIntoForm(kyc?.detail);
      }

      return true;
    } catch (error) {
      if (!mounted) return false;

      setState(() {
        _isKycLoading = false;
      });

      if (showError) {
        _showMessage(_getKycGetErrorMessage(error), isError: true);
      }

      return false;
    }
  }

  // ============================================================
  // STATUS LABEL HELPER
  // ============================================================

  bool _isNotSubmittedValue(String? statusLabel) {
    switch (statusLabel?.trim().toLowerCase()) {
      case 'not_submitted':
      case 'not-submitted':
      case 'not submitted':
      case 'not submitted yet':
      case 'not submitted yet.':
        return true;

      default:
        return false;
    }
  }

  // ============================================================
  // KYC STATUS HELPERS
  // ============================================================

  bool _isActiveKycStatus(String? status) {
    switch (status) {
      case 'pending':
      case 'under_review':
      case 'underreview':
      case 'review':
      case 'in_review':
      case 'approved':
      case 'verified':
      case 'accepted':
        return true;

      case null:
      case '':
      case 'not_submitted':
      case 'not-submitted':
      case 'not submitted':
      case 'rejected':
      case 'declined':
      case 'denied':
      default:
        return false;
    }
  }

  // ============================================================
  // FILL EXISTING KYC DATA
  // ============================================================

  void _fillKycDetailIntoForm(VendorKycDetailModel? detail) {
    if (detail == null) return;

    _ownerNameController.text = detail.ownerName?.trim() ?? '';

    _ownerEmailController.text = detail.ownerEmail?.trim() ?? '';

    _designationController.text =
        detail.authorizedPersonDesignation?.trim() ?? '';

    _tradeLicenseController.text = detail.tradeLicenseNumber?.trim() ?? '';

    _trnController.text = detail.taxRegistrationNumber?.trim() ?? '';

    _websiteController.text = detail.website?.trim() ?? '';

    _businessAddressController.text = detail.businessAddress?.trim() ?? '';

    _notesController.text = detail.notes?.trim() ?? '';

    final expiry = detail.tradeLicenseExpiry?.trim();

    if (expiry != null && expiry.isNotEmpty) {
      _tradeLicenseExpiryController.text = _formatApiDateForUi(expiry);
    }

    _setOwnerPhoneFromApi(detail.ownerPhone);
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatApiDateForUi(String value) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      return '';
    }

    final parsed = DateTime.tryParse(normalized);

    if (parsed == null) {
      return normalized.replaceAll('-', '/');
    }

    return '${parsed.year}/'
        '${parsed.month.toString().padLeft(2, '0')}/'
        '${parsed.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // SET OWNER PHONE FROM API
  // ============================================================

  void _setOwnerPhoneFromApi(String? value) {
    final phone = value?.trim();

    if (phone == null || phone.isEmpty) {
      return;
    }

    final countryRules = _phoneRulesFuture;

    countryRules.then((rules) {
      if (!mounted) return;

      PhoneRuleItemModel? matchedRule;

      for (final rule in rules.phoneRules) {
        final dialCode = rule.countryCode?.trim();

        if (dialCode == null || dialCode.isEmpty) {
          continue;
        }

        final normalizedDialCode = dialCode.startsWith('+')
            ? dialCode
            : '+$dialCode';

        if (phone.startsWith(normalizedDialCode)) {
          matchedRule = rule;

          setState(() {
            _selectedCountryIsoCode = rule.countryCode?.trim().toUpperCase();

            _selectedCountryDialCode = normalizedDialCode;

            _selectedPhoneRule = rule;
          });

          _ownerPhoneController.text =
              '$normalizedDialCode '
              '${phone.substring(normalizedDialCode.length).trim()}';

          return;
        }
      }

      if (matchedRule == null) {
        _ownerPhoneController.text = phone;
      }
    });
  }

  // ============================================================
  // KYC GET ERROR
  // ============================================================

  String _getKycGetErrorMessage(Object error) {
    if (error is ApiException) {
      final message = error.message.trim();

      if (message.isNotEmpty) {
        return message;
      }
    }

    return 'Unable to load KYC information. Please try again.';
  }

  // ============================================================
  // PHONE RULES
  // ============================================================

  Future<void> _loadInitialPhoneRule() async {
    final countryCode = _selectedCountryIsoCode?.trim();

    if (countryCode == null || countryCode.isEmpty) {
      return;
    }

    final requestId = ++_phoneRuleRequestId;

    if (mounted) {
      setState(() {
        _selectedPhoneRule = null;
        _isPhoneRuleLoading = true;
      });
    }

    try {
      final phoneRules = await _phoneRulesFuture;

      if (!mounted || requestId != _phoneRuleRequestId) {
        return;
      }

      PhoneRuleItemModel? matchedRule;

      for (final rule in phoneRules.phoneRules) {
        if (rule.countryCode?.trim().toUpperCase() ==
            countryCode.toUpperCase()) {
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

  Future<void> _updatePhoneRuleForCountry(String? countryCode) async {
    if (!mounted) return;

    final requestId = ++_phoneRuleRequestId;

    if (countryCode == null || countryCode.trim().isEmpty) {
      setState(() {
        _selectedPhoneRule = null;
        _isPhoneRuleLoading = false;
      });

      return;
    }

    final normalized = countryCode.trim().toUpperCase();

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
        if (rule.countryCode?.trim().toUpperCase() == normalized) {
          matchedRule = rule;
          break;
        }
      }

      setState(() {
        _selectedPhoneRule = matchedRule;
        _isPhoneRuleLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

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
  // SETTINGS
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
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSettingsLoading = false;
        _settingsError = 'Unable to load vendor settings. Please try again.';
      });
    }
  }

  Future<void> _retryVendorSettings() async {
    if (!mounted) return;

    setState(() {
      _settingsFuture = ref
          .read(vendorSettingsControllerProvider)
          .getVendorSettings();
    });

    await _loadVendorSettings();
  }

  void _fillSettingsData(VendorSettingsModel settings) {
    final merchant = settings.merchant;

    _storeNameController.text = merchant?.name?.trim() ?? '';

    _storeEmailController.text = merchant?.email?.trim() ?? '';

    _ownerNameController.clear();

    _ownerEmailController.clear();

    _selectedCountryIsoCode = 'AE';

    _selectedCountryDialCode = '+971';

    _setPhoneDialCode(_selectedCountryDialCode);

    _updatePhoneRuleForCountry(_selectedCountryIsoCode);
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
            ? const KycShimmerScreen()
            : _settingsError != null
            ? _buildSettingsError()
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 600 ? 24.0 : 16.0;

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
                  KycHeader(status: _headerStatus),

                  const SizedBox(height: 20),

                  _buildKycBody(),

                  const SizedBox(height: 18),

                  const KycTimelineCard(),

                  const SizedBox(height: 16),

                  const KycHelpCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // KYC BODY
  // ============================================================

  Widget _buildKycBody() {
    if (_isKycLoading) {
      return _buildKycLoading();
    }

    // ==========================================================
    // NOT SUBMITTED
    //
    // IMPORTANT:
    //
    // status = pending
    // status_label = not_submitted
    //
    // FORM SHOW
    // STATUS CARD HIDE
    // ==========================================================

    if (_isNotSubmitted) {
      return _buildKycForm();
    }

    // ==========================================================
    // APPROVED
    //
    // Only Status Card.
    // ==========================================================

    if (_isApprovedStatus) {
      return KycStatusCard(
        status: _kycStatus,
        rejectionReason: _kycRejectionReason,
        submissionCount: _kycSubmissionCount,
        message: _kycMessage,
        onRefresh: _refreshKycStatus,
      );
    }

    // ==========================================================
    // ACTIVE KYC
    //
    // pending / under_review etc.
    // ==========================================================

    if (_kycExists) {
      return _buildExistingKycState();
    }

    // ==========================================================
    // REJECTED / NO KYC
    //
    // Rejected:
    // Status Card + Form
    //
    // Empty:
    // Form
    // ==========================================================

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isRejectedStatus) ...[
          KycStatusCard(
            status: _kycStatus,
            rejectionReason: _kycRejectionReason,
            submissionCount: _kycSubmissionCount,
            message: _kycMessage,
            onRefresh: _refreshKycStatus,
          ),

          const SizedBox(height: 18),
        ],

        _buildKycForm(),
      ],
    );
  }

  // ============================================================
  // APPROVED
  // ============================================================

  bool get _isApprovedStatus {
    switch (_kycStatus?.trim().toLowerCase()) {
      case 'approved':
      case 'verified':
      case 'accepted':
        return true;

      default:
        return false;
    }
  }

  // ============================================================
  // HEADER STATUS
  // ============================================================

  KycStatus get _headerStatus {
    // ----------------------------------------------------------
    // NOT SUBMITTED
    //
    // API:
    // status = pending
    // status_label = not_submitted
    //
    // Header should not be treated as active submitted KYC.
    // ----------------------------------------------------------

    if (_isNotSubmitted) {
      return KycStatus.pending;
    }

    switch (_kycStatus?.trim().toLowerCase()) {
      case 'approved':
      case 'verified':
      case 'accepted':
        return KycStatus.approved;

      case 'rejected':
      case 'declined':
      case 'denied':
        return KycStatus.rejected;

      case 'under_review':
      case 'underreview':
      case 'review':
      case 'in_review':
      case 'pending':
      default:
        return KycStatus.pending;
    }
  }

  // ============================================================
  // EXISTING KYC STATE
  // ============================================================

  Widget _buildExistingKycState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KycStatusCard(
          status: _kycStatus,
          rejectionReason: _kycRejectionReason,
          submissionCount: _kycSubmissionCount,
          message: _kycMessage,
          onRefresh: _refreshKycStatus,
        ),

        const SizedBox(height: 18),

        if (!_isApprovedStatus) ...[
          if (_kycDetail != null) ...[
            KycDetailsCard(detail: _kycDetail),

            const SizedBox(height: 18),
          ],

          if (_kycDocuments.isNotEmpty)
            KycDocumentsSection(
              documents: _kycDocuments,
              onPreview: _previewServerDocument,
              onDownload: _downloadServerDocument,
            ),
        ],
      ],
    );
  }

  // ============================================================
  // FORM
  // ============================================================

  Widget _buildKycForm() {
    return Column(
      children: [
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
      ],
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
  // INFORMATION STEP
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
            KycResponsiveFields(
              first: KycFormFieldWithExample(
                example: 'Example: Beauty Store',
                field: KycFormField(
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
              ),
              second: KycFormFieldWithExample(
                example: 'Example: store@example.com',
                field: KycFormField(
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
              ),
            ),

            const SizedBox(height: 18),

            KycResponsiveFields(
              first: KycFormFieldWithExample(
                example: 'Example: Ahmed Ali',
                field: KycFormField(
                  controller: _ownerNameController,
                  label: 'Owner Full Name *',
                  hintText: 'Enter owner full name',
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.ownerName,
                ),
              ),
              second: KycFormFieldWithExample(
                example: 'Example: ahmed@example.com',
                field: KycFormField(
                  controller: _ownerEmailController,
                  label: 'Owner Email',
                  hintText: 'Enter owner email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.ownerEmail,
                ),
              ),
            ),

            const SizedBox(height: 18),

            KycResponsiveFields(
              first: _buildPhoneField(),
              second: KycFormFieldWithExample(
                example: 'Example: Owner / Director / Manager',
                field: KycFormField(
                  controller: _designationController,
                  label: 'Designation / Role',
                  hintText: 'e.g. Owner, Director, Manager',
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.designation,
                ),
              ),
            ),

            const SizedBox(height: 18),

            KycResponsiveFields(
              first: KycFormFieldWithExample(
                example: 'Example: TL-DXB-12345',
                field: KycFormField(
                  controller: _tradeLicenseController,
                  label: 'Trade License Number *',
                  hintText: 'Enter trade license number',
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.tradeLicense,
                ),
              ),
              second: _buildExpiryField(),
            ),

            const SizedBox(height: 18),

            KycResponsiveFields(
              first: KycFormFieldWithExample(
                example: 'Example: 100123456789003',
                field: KycFormField(
                  controller: _trnController,
                  label: 'Tax Registration Number (TRN)',
                  hintText: 'Enter 15 digit TRN',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: KycValidators.trnFormatters,
                  validator: KycValidators.trn,
                ),
              ),
              second: KycFormFieldWithExample(
                example: 'Example: https://mystore.ae',
                field: KycFormField(
                  controller: _websiteController,
                  label: 'Company Website',
                  hintText: 'https://example.com',
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: KycValidators.website,
                ),
              ),
            ),

            const SizedBox(height: 18),

            KycFormFieldWithExample(
              example: 'Example: Office 101, Business Bay, Dubai',
              field: KycFormField(
                controller: _businessAddressController,
                label: 'Registered Business Address *',
                hintText: 'Enter complete registered business address',
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                validator: KycValidators.businessAddress,
              ),
            ),

            const SizedBox(height: 18),

            KycFormFieldWithExample(
              example: 'Example: Additional information about your documents',
              field: KycFormField(
                controller: _notesController,
                label: 'Notes for Compliance Team',
                hintText:
                    'Any important remarks about your business or documents',
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                validator: KycValidators.notes,
              ),
            ),

            const SizedBox(height: 24),

            _buildNextButton(),
          ],
        ),
      ),
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

                  if (isoCode == null ||
                      isoCode.isEmpty ||
                      dialCode == null ||
                      dialCode.isEmpty) {
                    return;
                  }

                  final previousDialCode = _selectedCountryDialCode;

                  final normalizedDialCode = dialCode.startsWith('+')
                      ? dialCode
                      : '+$dialCode';

                  setState(() {
                    _selectedCountryIsoCode = isoCode.toUpperCase();

                    _selectedCountryDialCode = normalizedDialCode;
                  });

                  _setPhoneDialCode(
                    normalizedDialCode,
                    previousDialCode: previousDialCode,
                  );

                  _updatePhoneRuleForCountry(isoCode);
                },
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: CustomTextField(
                controller: _ownerPhoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                hintText: rule?.example != null
                    ? 'Example: ${rule!.example}'
                    : 'Enter phone number',
                validator: _validateOwnerPhone,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

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
      lengthText = minLength == maxLength
          ? '$minLength digits'
          : '$minLength-$maxLength digits';
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

  String? _validateOwnerPhone(String? value) {
    final rawPhone = value?.trim() ?? '';

    if (rawPhone.isEmpty) {
      return 'Owner phone number is required.';
    }

    final countryCode = _selectedCountryIsoCode?.trim();

    if (countryCode == null || countryCode.isEmpty) {
      return 'Please select a country.';
    }

    final dialCode = _selectedCountryDialCode.trim();

    if (dialCode.isEmpty) {
      return 'Please select a valid country code.';
    }

    var phone = rawPhone;

    if (phone.startsWith(dialCode)) {
      phone = phone.substring(dialCode.length).trim();
    }

    phone = phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    if (phone.isEmpty) {
      return 'Phone number is required.';
    }

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must contain digits only.';
    }

    if (phone.startsWith('0')) {
      return 'Enter the phone number without the leading 0.';
    }

    final rule = _selectedPhoneRule;

    if (rule == null) {
      if (_isPhoneRuleLoading) {
        return 'Phone validation rules are still loading.';
      }

      return 'Phone validation rule is not available for this country.';
    }

    final length = phone.length;

    if (rule.minLength != null && length < rule.minLength!) {
      return 'Phone number must be at least ${rule.minLength} digits.';
    }

    if (rule.maxLength != null && length > rule.maxLength!) {
      return 'Phone number must not exceed ${rule.maxLength} digits.';
    }

    return null;
  }

  // ============================================================
  // PHONE DIAL CODE
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

    if (previousDialCode != null && previousDialCode.isNotEmpty) {
      var previous = previousDialCode.trim();

      if (!previous.startsWith('+')) {
        previous = '+$previous';
      }

      if (currentValue.startsWith(previous)) {
        currentValue = currentValue.substring(previous.length).trim();
      }
    }

    if (currentValue.startsWith(normalizedDialCode)) {
      return;
    }

    currentValue = currentValue
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    currentValue = currentValue.replaceFirst(RegExp(r'^0+'), '');

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
    return KycFormFieldWithExample(
      example: 'Select from date picker',
      field: KycFormField(
        controller: _tradeLicenseExpiryController,
        label: 'Trade License Expiry *',
        hintText: 'yyyy/mm/dd',
        readOnly: true,
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 19),
        onTap: _selectExpiryDate,
        validator: KycValidators.tradeLicenseExpiry,
      ),
    );
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: today.add(const Duration(days: 30)),
      firstDate: today.add(const Duration(days: 1)),
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

    final formatted =
        '${selectedDate.year}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    setState(() {
      _tradeLicenseExpiryController.text = formatted;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _formKey.currentState?.validate();
    });
  }

  // ============================================================
  // NEXT BUTTON
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
  // DOCUMENTS STEP
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
  // PICK DOCUMENT
  // ============================================================

  Future<void> _pickDocument({required _DocumentType type}) async {
    if (_isPickingDocument || _isSubmitting) {
      return;
    }

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
                  onTap: () => Navigator.pop(context, _DocumentSource.files),
                ),

                const SizedBox(height: 10),

                _buildUploadOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a Photo',
                  subtitle: 'Capture your document',
                  onTap: () => Navigator.pop(context, _DocumentSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null || !mounted) {
      return;
    }

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

      if (selectedFile == null || !mounted) {
        return;
      }

      if (selectedFile.sizeBytes > _maxFileSizeBytes) {
        _showMessage('File size must not exceed 8 MB.', isError: true);

        return;
      }

      setState(() {
        _setDocument(type: type, file: selectedFile!);

        _clearDocumentError(type);
      });
    } catch (_) {
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
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
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

    final file = File(path);

    if (!await file.exists()) {
      return null;
    }

    final sizeBytes = await file.length();

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

    if (image == null) {
      return null;
    }

    final file = File(image.path);

    if (!await file.exists()) {
      return null;
    }

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
  // SERVER DOCUMENT PREVIEW
  // ============================================================

  void _previewServerDocument(VendorKycDocumentModel document) {
    final dioClient = ref.read(dioProvider);

    showDialog<void>(
      context: context,
      builder: (_) {
        return KycDocumentPreviewDialog(
          document: document,
          dioClient: dioClient,
        );
      },
    );
  }

  // ============================================================
  // SERVER DOCUMENT DOWNLOAD
  // ============================================================

  Future<void> _downloadServerDocument(VendorKycDocumentModel document) async {
    if (_isDownloading) {
      return;
    }

    final controller = ref.read(kycDocumentDownloadControllerProvider);

    const downloadService = FileDownloadService();

    try {
      _setDownloading(true);

      if (mounted) {
        _showMessage('Downloading document...');
      }

      final result = await controller.downloadDocument(document: document);

      if (result.bytes.isEmpty) {
        throw const ApiException(
          message: 'Downloaded document is empty.',
          code: 'EMPTY_DOCUMENT',
        );
      }

      final file = await downloadService.saveBytesFile(
        bytes: result.bytes,
        fileName: result.fileName,
        mimeType: result.mimeType,
      );

      if (!mounted) {
        return;
      }

      _showMessage('Document saved successfully.\n${file.path}');
    } on ApiException catch (error) {
      debugPrint(
        'KYC DOCUMENT DOWNLOAD API ERROR: '
        '${error.code} - ${error.message}',
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        error.message.trim().isNotEmpty
            ? error.message
            : 'Unable to download document.',
        isError: true,
      );
    } on FileSystemException catch (error) {
      debugPrint(
        'KYC DOCUMENT FILE ERROR: '
        '${error.message}',
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        error.message.trim().isNotEmpty
            ? error.message
            : 'Unable to save document.',
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'KYC DOCUMENT DOWNLOAD UNKNOWN ERROR: '
        '$error',
      );

      debugPrint('$stackTrace');

      if (!mounted) {
        return;
      }

      _showMessage(
        'Something went wrong while downloading the document.',
        isError: true,
      );
    } finally {
      if (mounted) {
        _setDownloading(false);
      }
    }
  }

  // ============================================================
  // SUBMIT KYC
  // ============================================================

  Future<void> _submitKyc() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();

    final tradeLicenseFile = _tradeLicenseFile;

    final authorizedIdFile = _authorizedIdFile;

    _validateDocuments();

    final documentsValid =
        _tradeLicenseError == null &&
        _authorizedIdError == null &&
        _vatError == null &&
        _additionalError == null;

    if (!documentsValid ||
        tradeLicenseFile == null ||
        authorizedIdFile == null) {
      _showMessage('Please upload the required documents.', isError: true);

      return;
    }

    final ownerName = _ownerNameController.text.trim();

    final ownerEmail = _ownerEmailController.text.trim();

    final designation = _designationController.text.trim();

    final tradeLicenseNumber = _tradeLicenseController.text.trim();

    final expiry = _tradeLicenseExpiryController.text.trim();

    final trn = _trnController.text.trim();

    final website = _websiteController.text.trim();

    final businessAddress = _businessAddressController.text.trim();

    final notes = _notesController.text.trim();

    final phoneCountry = _selectedCountryIsoCode?.trim();

    if (phoneCountry == null || phoneCountry.isEmpty) {
      _showMessage('Unable to determine phone country.', isError: true);

      return;
    }

    if (_isPhoneRuleLoading) {
      _showMessage('Please wait while phone rules are loading.', isError: true);

      return;
    }

    if (_selectedPhoneRule == null) {
      _showMessage(
        'Phone number rules are not available for the selected country.',
        isError: true,
      );

      return;
    }

    final apiPhone = _buildOwnerPhoneForApi();

    if (apiPhone == null) {
      _showMessage('Please enter a valid phone number.', isError: true);

      return;
    }

    final apiExpiry = _convertExpiryDateForApi(expiry);

    if (apiExpiry == null) {
      _showMessage('Invalid trade license expiry date.', isError: true);

      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(kycSubmitControllerProvider)
          .submitKyc(
            ownerName: ownerName,
            ownerEmail: ownerEmail.isEmpty ? null : ownerEmail,
            ownerPhone: apiPhone,
            phoneCountry: phoneCountry,
            authorizedPersonDesignation: designation.isEmpty
                ? null
                : designation,
            tradeLicenseNumber: tradeLicenseNumber,
            tradeLicenseExpiry: apiExpiry,
            taxRegistrationNumber: trn.isEmpty ? null : trn,
            businessAddress: businessAddress,
            website: website.isEmpty ? null : website,
            notes: notes.isEmpty ? null : notes,
            tradeLicenseFile: tradeLicenseFile,
            authorizedIdFile: authorizedIdFile,
            taxCertificateFile: _vatFile,
            supportingDocumentFile: _additionalFile,
          );

      if (!mounted) return;

      if (result.success) {
        setState(() {
          _isSubmitting = false;
        });

        _showMessage(result.message ?? 'KYC submitted successfully.');

        final refreshed = await _loadKyc(showError: true);

        if (!mounted) return;

        if (!refreshed) {
          return;
        }

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
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showMessage(_getKycSubmitErrorMessage(error), isError: true);
    }
  }

  // ============================================================
  // KYC LOADING
  // ============================================================

  Widget _buildKycLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),

          const SizedBox(height: 16),

          Text(
            'Checking KYC status...',
            style: AppTextStyles.titleMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            'Please wait while we load your verification information.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshKycStatus() async {
    final success = await _loadKyc(showError: true);

    if (!mounted || !success) {
      return;
    }

    _showMessage('KYC status refreshed.');
  }

  // ============================================================
  // OWNER PHONE API
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

    if (phone.startsWith(dialCode)) {
      phone = phone.substring(dialCode.length).trim();
    }

    phone = phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    phone = phone.replaceFirst(RegExp(r'^0+'), '');

    if (phone.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return null;
    }

    return '$dialCode$phone';
  }

  // ============================================================
  // EXPIRY API
  // ============================================================

  String? _convertExpiryDateForApi(String value) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      return null;
    }

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

    if (year < 2000 || month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }

    final date = DateTime(year, month, day);

    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    if (!date.isAfter(today)) {
      return null;
    }

    return '$year-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // DOCUMENT VALIDATION
  // ============================================================

  void _validateDocuments() {
    setState(() {
      _tradeLicenseError = _tradeLicenseFile == null
          ? 'Trade License Copy is required.'
          : null;

      _authorizedIdError = _authorizedIdFile == null
          ? 'Authorized Person ID is required.'
          : null;

      _vatError = null;

      _additionalError = null;
    });
  }

  // ============================================================
  // SUBMIT ERROR
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
}

// ============================================================
// ENUMS
// ============================================================

enum _DocumentType { tradeLicense, authorizedId, vat, additional }

enum _DocumentSource { files, camera }
