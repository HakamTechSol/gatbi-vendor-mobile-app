import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Authentication/Registration/Category/category_dropdown.dart';
import '../../../Authentication/Registration/Country Code/country_model.dart';
import '../../../Authentication/Registration/Phone Rule/phone_rules_controller.dart';
import '../../../Authentication/Registration/Phone Rule/phone_rules_model.dart';

import '../../Get Profile/Controller/get_profile_controller.dart';
import '../../Get Profile/Models/get_profile_model.dart';

import '../Controller/edit_profile_controller.dart';
import '../Reuse Widgets/edit_profile_header.dart';
import '../Reuse Widgets/phone_code_dropdown.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _storeNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _aboutController = TextEditingController();

  final TextEditingController _warehouseController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  VendorSettingsMerchantModel? _merchant;

  String? _selectedPhoneCountry;

  CountryItemModel? _selectedCountry;

  int? _selectedCategoryId;

  String? _existingLogo;

  PhoneRulesModel? _phoneRules;

  bool _isInitialLoading = true;

  bool _isSaving = false;

  String? _initialError;

  File? _selectedLogoFile;

  bool _isPickingLogo = false;

  // ============================================================
  // PHONE RULE FUTURE
  // ============================================================

  late Future<PhoneRulesModel> _phoneRulesFuture;

  String? _getExistingPhoneDialCode(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null;
    }

    final normalizedPhone = phone.replaceAll(RegExp(r'[\s\-()]'), '');

    if (!normalizedPhone.startsWith('+')) {
      return null;
    }

    final phoneRules = _phoneRules;

    if (phoneRules == null) {
      return null;
    }

    // Phone rules country code nahi dete,
    // isliye actual country API se dial code resolve
    // PhoneCodeDropdown karega.
    //
    // Here we simply return the leading portion.
    //
    // Better approach:
    // +923625147536
    // -> +92
    //
    // Country dropdown internally available countries
    // se longest matching dial code identify karega.

    return _extractPossibleDialCode(normalizedPhone);
  }

  String? _extractPossibleDialCode(String phone) {
    if (!phone.startsWith('+')) {
      return null;
    }

    final digits = phone.substring(1);

    if (digits.length < 2) {
      return null;
    }

    // Most country dial codes are 1-3 digits.
    // +92 => first 2
    // +971 => first 3
    //
    // PhoneCodeDropdown final API country list se
    // exact match karega.

    if (digits.length >= 3) {
      return '+${digits.substring(0, 3)}';
    }

    return '+${digits.substring(0, 2)}';
  }

  Future<void> _pickLogo() async {
    if (_isSaving || _isPickingLogo) {
      return;
    }

    setState(() {
      _isPickingLogo = true;
    });

    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (image == null) {
        return;
      }

      final file = File(image.path);

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedLogoFile = file;
      });

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('EDIT PROFILE - LOGO SELECTED');
      debugPrint('==========================================');
      debugPrint('Path: ${file.path}');
      debugPrint('==========================================');
      debugPrint('');
    } catch (error) {
      debugPrint('Logo picker error: $error');

      if (!mounted) {
        return;
      }

      _showErrorSnackBar('Unable to select image. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingLogo = false;
        });
      }
    }
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Phone rules load.
    _phoneRulesFuture = _loadPhoneRules();

    // IMPORTANT:
    // Profile API bhi immediately call hogi.
    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<VendorSettingsModel> _loadProfile() async {
    try {
      debugPrint('');
      debugPrint('==========================================');
      debugPrint('EDIT PROFILE - LOAD PROFILE');
      debugPrint('==========================================');

      final result = await ref
          .read(vendorSettingsControllerProvider)
          .getVendorSettings();

      debugPrint('Profile API success: ${result.success}');

      debugPrint('Merchant available: ${result.merchant != null}');

      if (result.merchant == null) {
        throw const ApiException(
          message: 'Merchant profile information was not found.',
          code: 'MERCHANT_NOT_FOUND',
        );
      }

      _merchant = result.merchant;

      _populateForm(result.merchant!);

      debugPrint('Merchant name: ${result.merchant!.name}');

      debugPrint('Merchant email: ${result.merchant!.email}');

      debugPrint('Merchant phone: ${result.merchant!.phone}');

      debugPrint('Category ID: ${result.merchant!.primaryCategoryId}');

      debugPrint('==========================================');
      debugPrint('');

      return result;
    } catch (error) {
      debugPrint('');
      debugPrint('==========================================');
      debugPrint('EDIT PROFILE - LOAD ERROR');
      debugPrint('==========================================');
      debugPrint('Error: $error');
      debugPrint('==========================================');
      debugPrint('');

      if (mounted) {
        setState(() {
          _initialError = _getErrorMessage(error);
        });
      }

      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  // ============================================================
  // LOAD PHONE RULES
  // ============================================================

  Future<PhoneRulesModel> _loadPhoneRules() async {
    try {
      debugPrint('');
      debugPrint('EDIT PROFILE - LOAD PHONE RULES');

      final result = await ref
          .read(phoneRulesControllerProvider)
          .getPhoneRules();

      _phoneRules = result;

      debugPrint('Phone rules loaded: ${result.phoneRules.length}');

      return result;
    } catch (error) {
      debugPrint('Phone rules error: $error');

      rethrow;
    }
  }

  // ============================================================
  // POPULATE FORM
  // ============================================================

  void _populateForm(VendorSettingsMerchantModel merchant) {
    _storeNameController.text = merchant.name?.trim() ?? '';

    _emailController.text = merchant.email?.trim() ?? '';

    _aboutController.text = merchant.about?.trim() ?? '';

    _warehouseController.text = merchant.warehouseAddress?.trim() ?? '';

    _selectedCategoryId = merchant.primaryCategoryId;

    _existingLogo = merchant.logo?.trim();

    // Full phone initially rakho.
    // PhoneCodeDropdown country resolve karne ke baad
    // _extractLocalPhoneNumber() local number set karega.
    _phoneController.text = merchant.phone?.trim() ?? '';

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('EDIT PROFILE - FORM POPULATED');
    debugPrint('==========================================');
    debugPrint('Store: ${merchant.name}');
    debugPrint('Email: ${merchant.email}');
    debugPrint('Phone: ${merchant.phone}');
    debugPrint('Category ID: ${merchant.primaryCategoryId}');
    debugPrint('Logo: ${merchant.logo}');
    debugPrint('==========================================');
    debugPrint('');
  }

  // ============================================================
  // COUNTRY CHANGED
  // ============================================================

  void _onCountryChanged(String? countryCode) {
    if (countryCode == null || countryCode.trim().isEmpty) {
      return;
    }

    setState(() {
      _selectedPhoneCountry = countryCode.trim().toUpperCase();
    });

    _updatePhoneForCountry(_selectedCountry);
  }

  // ============================================================
  // COUNTRY OBJECT CHANGED
  // ============================================================

  void _onCountryObjectChanged(CountryItemModel? country) {
    if (country == null) {
      return;
    }

    final previousCountry = _selectedCountry;

    setState(() {
      _selectedCountry = country;

      if (country.code != null && country.code!.trim().isNotEmpty) {
        _selectedPhoneCountry = country.code!.trim().toUpperCase();
      }
    });

    // First country selection.
    if (previousCountry == null) {
      _extractLocalPhoneNumber(country);
      return;
    }

    // User manually changed country.
    if (previousCountry.code != country.code) {
      _phoneController.clear();
    }
  }

  // ============================================================
  // EXTRACT LOCAL PHONE
  // ============================================================

  void _extractLocalPhoneNumber(CountryItemModel country) {
    final merchantPhone = _merchant?.phone?.trim() ?? '';

    if (merchantPhone.isEmpty) {
      return;
    }

    final dialCode = country.dialCode?.trim() ?? '';

    if (dialCode.isEmpty) {
      return;
    }

    final normalizedPhone = merchantPhone.replaceAll(RegExp(r'[\s\-()]'), '');

    final normalizedDialCode = dialCode.replaceAll(RegExp(r'[\s\-()]'), '');

    if (normalizedPhone.startsWith(normalizedDialCode)) {
      final localNumber = normalizedPhone.substring(normalizedDialCode.length);

      if (!mounted) {
        return;
      }

      setState(() {
        _phoneController.text = localNumber;

        _phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneController.text.length),
        );
      });
    }
  }

  // ============================================================
  // UPDATE PHONE
  // ============================================================

  void _updatePhoneForCountry(CountryItemModel? country) {
    if (country == null) {
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _extractLocalPhoneNumber(country);
    }
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  void _onCategoryChanged(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ============================================================
    // CATEGORY
    // ============================================================

    if (_selectedCategoryId == null) {
      _showErrorSnackBar('Please select a primary category.');
      return;
    }

    // ============================================================
    // COUNTRY
    // ============================================================

    if (_selectedPhoneCountry == null ||
        _selectedPhoneCountry!.trim().isEmpty) {
      _showErrorSnackBar('Please select a phone country.');
      return;
    }

    // ============================================================
    // DIAL CODE
    // ============================================================

    final dialCode = _selectedCountry?.dialCode?.trim() ?? '';

    if (dialCode.isEmpty) {
      _showErrorSnackBar('Phone country code is not available.');
      return;
    }

    // ============================================================
    // LOCAL PHONE
    // ============================================================

    final localPhone = _phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (localPhone.isEmpty) {
      _showErrorSnackBar('Please enter your phone number.');
      return;
    }

    // ============================================================
    // PHONE VALIDATION
    // ============================================================

    final phoneValidation = _validatePhoneNumber(localPhone);

    if (phoneValidation != null) {
      _showErrorSnackBar(phoneValidation);
      return;
    }

    // ============================================================
    // COMPLETE PHONE
    // ============================================================

    final cleanDialCode = dialCode.replaceAll(RegExp(r'\D'), '');

    final phoneFull = '+$cleanDialCode$localPhone';

    // ============================================================
    // DEBUG
    // ============================================================

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('EDIT PROFILE - SAVE BUTTON');
    debugPrint('==================================================');
    debugPrint('ABOUT: ${_aboutController.text.trim()}');
    debugPrint('WAREHOUSE: ${_warehouseController.text.trim()}');
    debugPrint(
      'PHONE COUNTRY: '
      '${_selectedPhoneCountry!.trim().toUpperCase()}',
    );
    debugPrint('PHONE FULL: $phoneFull');
    debugPrint('CATEGORY ID: $_selectedCategoryId');
    debugPrint('EXISTING LOGO: ${_existingLogo ?? 'NULL'}');
    debugPrint(
      'SELECTED LOGO FILE: '
      '${_selectedLogoFile?.path ?? 'NO FILE'}',
    );
    debugPrint('==================================================');
    debugPrint('');

    setState(() {
      _isSaving = true;
    });

    try {
      final result = await ref
          .read(editProfileControllerProvider)
          .editProfile(
            about: _aboutController.text.trim(),
            warehouseAddress: _warehouseController.text.trim(),
            phoneFull: phoneFull,
            phoneCountry: _selectedPhoneCountry!.trim().toUpperCase(),
            primaryCategoryId: _selectedCategoryId!,

            // Existing logo
            logo: _existingLogo ?? '',

            // IMPORTANT:
            // Selected new image
            logoFile: _selectedLogoFile,
          );

      // ==========================================================
      // RESULT DEBUG
      // ==========================================================

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('EDIT PROFILE - SCREEN RESULT');
      debugPrint('==================================================');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint(
        'UPDATED LOGO: '
        '${result.merchant?.logo ?? 'N/A'}',
      );
      debugPrint(
        'UPDATED PHONE: '
        '${result.merchant?.phone ?? 'N/A'}',
      );
      debugPrint('==================================================');
      debugPrint('');

      if (!mounted) {
        return;
      }

      if (!result.success) {
        _showErrorSnackBar(
          result.message?.trim().isNotEmpty == true
              ? result.message!.trim()
              : 'Profile could not be updated.',
        );

        return;
      }

      // ==========================================================
      // UPDATE LOCAL LOGO
      // ==========================================================

      if (result.merchant?.logo != null &&
          result.merchant!.logo!.trim().isNotEmpty) {
        _existingLogo = result.merchant!.logo!.trim();

        _selectedLogoFile = null;
      }

      _showSuccessSnackBar(
        result.message?.trim().isNotEmpty == true
            ? result.message!.trim()
            : 'Profile updated successfully.',
      );

      context.pop(result);
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint('==================================================');
      debugPrint('EDIT PROFILE - API EXCEPTION SCREEN');
      debugPrint('==================================================');
      debugPrint('CODE: ${error.code}');
      debugPrint('MESSAGE: ${error.message}');
      debugPrint('==================================================');
      debugPrint('');

      if (!mounted) {
        return;
      }

      _showErrorSnackBar(
        error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Unable to update profile.',
      );
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('==================================================');
      debugPrint('EDIT PROFILE - UNEXPECTED ERROR');
      debugPrint('==================================================');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('==================================================');
      debugPrint('');

      if (!mounted) {
        return;
      }

      _showErrorSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // PHONE VALIDATION
  // ============================================================

  String? _validatePhoneNumber(String phone) {
    final rules = _phoneRules;

    if (rules == null) {
      return null;
    }

    final countryCode = _selectedPhoneCountry?.trim().toUpperCase();

    if (countryCode == null || countryCode.isEmpty) {
      return 'Please select a phone country.';
    }

    PhoneRuleItemModel? countryRule;

    for (final rule in rules.phoneRules) {
      final ruleCountry = rule.countryCode?.trim().toUpperCase();

      if (ruleCountry == countryCode) {
        countryRule = rule;
        break;
      }
    }

    final minLength = countryRule?.minLength ?? rules.defaultMinLength;

    final maxLength = countryRule?.maxLength ?? rules.defaultMaxLength;

    if (minLength != null && phone.length < minLength) {
      return 'Phone number must contain at least '
          '$minLength digits.';
    }

    if (maxLength != null && phone.length > maxLength) {
      return 'Phone number must contain at most '
          '$maxLength digits.';
    }

    if (minLength != null &&
        maxLength != null &&
        minLength == maxLength &&
        phone.length != minLength) {
      return 'Phone number must contain '
          '$minLength digits.';
    }

    return null;
  }

  // ============================================================
  // PHONE VALIDATOR
  // ============================================================

  String? _phoneValidator(String? value) {
    final phone = value?.replaceAll(RegExp(r'\D'), '') ?? '';

    if (phone.isEmpty) {
      return 'Phone number is required.';
    }

    return _validatePhoneNumber(phone);
  }

  // ============================================================
  // ERROR
  // ============================================================

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      if (error.message.trim().isNotEmpty) {
        return error.message.trim();
      }
    }

    return 'Unable to load your profile. Please try again.';
  }

  // ============================================================
  // SUCCESS SNACKBAR
  // ============================================================

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.successDark,
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
  // ERROR SNACKBAR
  // ============================================================

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
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
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _storeNameController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    _warehouseController.dispose();
    _phoneController.dispose();

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
        child: Column(
          children: [
            // ======================================================
            // REUSABLE HEADER
            // ======================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: EditProfileHeader(
                onBack: _isSaving
                    ? null
                    : () {
                        context.pop();
                      },
              ),
            ),

            // ======================================================
            // CONTENT
            // ======================================================
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    // ==========================================================
    // INITIAL LOADING
    // ==========================================================

    if (_isInitialLoading) {
      return const _EditProfileLoading();
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    if (_initialError != null) {
      return _buildInitialError();
    }

    // ==========================================================
    // FORM
    // ==========================================================

    return _buildForm();
  }

  // ============================================================
  // INITIAL ERROR
  // ============================================================

  Widget _buildInitialError() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.errorBorder),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Unable to Load Profile',
              textAlign: TextAlign.center,
              style: AppTextStyles.errorTitle,
            ),

            const SizedBox(height: 8),

            Text(
              _initialError!,
              textAlign: TextAlign.center,
              style: AppTextStyles.errorDescription,
            ),

            const SizedBox(height: 22),

            CustomButton(
              width: 160,
              height: 46,
              text: 'Try Again',
              icon: Icons.refresh_rounded,
              onPressed: _retryInitialLoad,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RETRY
  // ============================================================

  void _retryInitialLoad() {
    setState(() {
      _initialError = null;
      _isInitialLoading = true;

      _phoneRulesFuture = _loadPhoneRules();
    });

    _loadProfile();
  }

  // ============================================================
  // FORM
  // ============================================================

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroCard(),

              const SizedBox(height: 18),

              _buildBusinessInformationCard(),

              const SizedBox(height: 16),

              _buildContactInformationCard(),

              const SizedBox(height: 16),

              _buildLocationCard(),

              const SizedBox(height: 16),

              _buildAboutCard(),

              const SizedBox(height: 24),

              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshProfile() async {
    try {
      await Future.wait([_loadProfile(), _reloadPhoneRules()]);
    } catch (_) {
      // Errors already handled by individual methods.
    }
  }

  // ============================================================
  // RELOAD PHONE RULES
  // ============================================================

  Future<void> _reloadPhoneRules() async {
    final future = _loadPhoneRules();

    setState(() {
      _phoneRulesFuture = future;
    });

    await future;
  }

  // ============================================================
  // INTRO CARD
  // ============================================================

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: AppColors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Business Profile', style: AppTextStyles.titleLarge),

                const SizedBox(height: 4),

                Text(
                  'Update your merchant information, '
                  'contact details and warehouse address.',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUSINESS INFORMATION
  // ============================================================

  Widget _buildBusinessInformationCard() {
    return _FormCard(
      title: 'Business Information',
      subtitle: 'Basic information about your merchant store.',
      icon: Icons.business_outlined,
      children: [
        _buildLogoPicker(),

        const SizedBox(height: 20),
        CustomTextField(
          controller: _storeNameController,
          label: 'Store Name',
          hintText: 'Store name',
          prefixIcon: Icons.store_outlined,
          enabled: false,
          readOnly: true,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          controller: _emailController,
          label: 'Email Address',
          hintText: 'Email address',
          prefixIcon: Icons.email_outlined,
          enabled: false,
          readOnly: true,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 16),

        CategoryDropdown(
          value: _selectedCategoryId,
          onChanged: _onCategoryChanged,
          validator: (value) {
            if (value == null) {
              return 'Primary category is required.';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLogoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Store Logo', style: AppTextStyles.formLabel),

        const SizedBox(height: 10),

        Center(
          child: GestureDetector(
            onTap: _pickLogo,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.borderPrimary,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(child: _buildLogoImage()),
                ),

                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    child: _isPickingLogo
                        ? const Padding(
                            padding: EdgeInsets.all(9),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_outlined,
                            size: 17,
                            color: AppColors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: Text('Tap to change logo', style: AppTextStyles.formHelper),
        ),
      ],
    );
  }

  Widget _buildLogoImage() {
    // ----------------------------------------------------------
    // NEW IMAGE
    // ----------------------------------------------------------

    if (_selectedLogoFile != null) {
      return Image.file(
        _selectedLogoFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // ----------------------------------------------------------
    // EXISTING API IMAGE
    // ----------------------------------------------------------

    final logo = _existingLogo?.trim();

    if (logo != null && logo.isNotEmpty) {
      return Image.network(
        logo,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultLogo();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    }

    // ----------------------------------------------------------
    // DEFAULT
    // ----------------------------------------------------------

    return _buildDefaultLogo();
  }

  Widget _buildDefaultLogo() {
    return Container(
      color: AppColors.primaryLight,
      alignment: Alignment.center,
      child: const Icon(
        Icons.storefront_rounded,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }

  // ============================================================
  // CONTACT INFORMATION
  // ============================================================

  Widget _buildContactInformationCard() {
    return _FormCard(
      title: 'Contact Information',
      subtitle: 'Select your country and update your phone number.',
      icon: Icons.phone_outlined,
      children: [
        Text('Phone Country', style: AppTextStyles.formLabel),

        const SizedBox(height: 8),

        PhoneCodeDropdown(
          value: _selectedPhoneCountry,

          initialPhone: _merchant?.phone,

          initialDialCode: _getExistingPhoneDialCode(_merchant?.phone),

          onChanged: _onCountryChanged,

          onCountryChanged: _onCountryObjectChanged,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hintText: 'Enter phone number',
          prefixIcon: Icons.phone_outlined,
          prefixText: _selectedCountry?.dialCode != null
              ? '${_selectedCountry!.dialCode} '
              : null,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: _phoneValidator,
        ),

        const SizedBox(height: 8),

        FutureBuilder<PhoneRulesModel>(
          future: _phoneRulesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 1.8),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'Checking phone rules...',
                    style: AppTextStyles.formHelper,
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return Text(
                'Phone validation rules could not be loaded.',
                style: AppTextStyles.formHelper.copyWith(
                  color: AppColors.warningDark,
                ),
              );
            }

            final rule = _getCurrentPhoneRule();

            if (rule == null) {
              return Text(
                'Enter a valid phone number for the selected country.',
                style: AppTextStyles.formHelper,
              );
            }

            final min = rule.minLength;

            final max = rule.maxLength;

            String helper;

            if (min != null && max != null && min == max) {
              helper = 'Phone number must contain $min digits.';
            } else if (min != null && max != null) {
              helper = 'Phone number must contain $min-$max digits.';
            } else if (min != null) {
              helper = 'Minimum $min digits required.';
            } else if (max != null) {
              helper = 'Maximum $max digits allowed.';
            } else {
              helper = 'Enter a valid phone number.';
            }

            return Text(helper, style: AppTextStyles.formHelper);
          },
        ),
      ],
    );
  }

  // ============================================================
  // CURRENT PHONE RULE
  // ============================================================

  PhoneRuleItemModel? _getCurrentPhoneRule() {
    final countryCode = _selectedPhoneCountry?.trim().toUpperCase();

    if (countryCode == null || countryCode.isEmpty || _phoneRules == null) {
      return null;
    }

    for (final rule in _phoneRules!.phoneRules) {
      if (rule.countryCode?.trim().toUpperCase() == countryCode) {
        return rule;
      }
    }

    return null;
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Widget _buildLocationCard() {
    return _FormCard(
      title: 'Warehouse',
      subtitle: 'Your registered warehouse address.',
      icon: Icons.location_on_outlined,
      children: [
        CustomTextField(
          controller: _warehouseController,
          label: 'Warehouse Address',
          hintText: 'Enter warehouse address',
          maxLines: 4,
          minLines: 3,
          textInputAction: TextInputAction.newline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Warehouse address is required.';
            }

            return null;
          },
        ),
      ],
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  Widget _buildAboutCard() {
    return _FormCard(
      title: 'About Store',
      subtitle: 'Tell customers about your business.',
      icon: Icons.description_outlined,
      children: [
        CustomTextField(
          controller: _aboutController,
          label: 'About',
          hintText: 'Describe your business...',
          maxLines: 6,
          minLines: 4,
          maxLength: 1000,
          textInputAction: TextInputAction.newline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'About is required.';
            }

            return null;
          },
        ),
      ],
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return Column(
      children: [
        CustomButton(
          text: 'Save Changes',
          icon: Icons.check_rounded,
          height: 54,
          borderRadius: 14,
          isLoading: _isSaving,
          isEnabled: !_isSaving,
          onPressed: _saveProfile,
          elevation: 3,
        ),

        const SizedBox(height: 10),

        Text(
          'Your store name and email are managed by your account.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

// ============================================================================
// FORM CARD
// ============================================================================

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 21, color: AppColors.primary),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),

                    const SizedBox(height: 3),

                    Text(subtitle, style: AppTextStyles.settingsSubtitle),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...children,
        ],
      ),
    );
  }
}

// ============================================================================
// CIRCULAR LOADING
// ============================================================================

class _EditProfileLoading extends StatelessWidget {
  const _EditProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.8,
        color: AppColors.primary,
      ),
    );
  }
}
