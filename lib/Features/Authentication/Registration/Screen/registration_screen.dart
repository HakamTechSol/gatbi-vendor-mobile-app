import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Routes/app_route.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Services/auth_validator.dart';
import '../../../../Services/dio.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Category/category_dropdown.dart';
import '../Controller/register_controller.dart';
import '../Phone Rule/phone_code_dropdown.dart';
import '../Phone Rule/phone_rules_model.dart';
import '../business Type/business_type_dropdown.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.onBackToLogin});

  final VoidCallback? onBackToLogin;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // STEP MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  int _currentStep = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _storeNameController;
  late final TextEditingController _licenseNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _aboutController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmationController;

  // ═══════════════════════════════════════════════════════════════════════════
  // FOCUS NODES
  // ═══════════════════════════════════════════════════════════════════════════

  late final FocusNode _storeNameFocusNode;
  late final FocusNode _licenseNumberFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _addressFocusNode;
  late final FocusNode _aboutFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTER CONTROLLER
  // ═══════════════════════════════════════════════════════════════════════════

  late final RegisterController _registerController;

  // ═══════════════════════════════════════════════════════════════════════════
  // FORM KEYS
  // ═══════════════════════════════════════════════════════════════════════════

  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _step3FormKey = GlobalKey<FormState>();

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTED VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  String? _selectedBusinessType;

  int? _selectedCategoryId;

  /// API expects country code such as AE / PK.
  String? _selectedPhoneCountryCode;

  /// Selected phone rule is used for local phone validation.
  PhoneRuleItemModel? _selectedPhoneRule;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isLoading = false;

  bool _termsAgreed = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    // Text controllers.
    _storeNameController = TextEditingController();
    _licenseNumberController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _aboutController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();

    // Focus nodes.
    _storeNameFocusNode = FocusNode();
    _licenseNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _aboutFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();

    // Existing DioClient architecture.
    _registerController = RegisterController(dioClient: ref.read(dioProvider));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void dispose() {
    _storeNameController.dispose();
    _licenseNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    _storeNameFocusNode.dispose();
    _licenseNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _aboutFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  void _nextStep() {
    if (_currentStep == 0) {
      final isValid = _step1FormKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }

      setState(() {
        _currentStep = 1;
      });

      return;
    }

    if (_currentStep == 1) {
      final isValid = _step2FormKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }

      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _prevStep() {
    if (_currentStep <= 0) {
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTRATION SUCCESS DIALOG
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _showRegistrationSuccessDialog({required String message}) async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppColors.success,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Registration Successful',
                  style: AppTextStyles.authTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Confirm',
                icon: Icons.check_rounded,
                iconPosition: CustomButtonIconPosition.trailing,
                type: CustomButtonType.primary,
                height: 47,
                borderRadius: 10,
                elevation: 2,
                onPressed: () {
                  Navigator.of(dialogContext).pop();

                  if (!mounted) {
                    return;
                  }

                  context.go(AppRoutes.login);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTER
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleRegister() async {
    if (_isLoading) {
      return;
    }

    // ------------------------------------------------------------
    // Terms validation
    // ------------------------------------------------------------

    if (!_termsAgreed) {
      _showError('Please agree to the Terms of Service and Privacy Policy.');
      return;
    }

    // ------------------------------------------------------------
    // Step 3 validation
    // ------------------------------------------------------------

    final isStep3Valid = _step3FormKey.currentState?.validate() ?? false;

    if (!isStep3Valid) {
      return;
    }

    // ------------------------------------------------------------
    // Required values
    // ------------------------------------------------------------

    final businessType = _selectedBusinessType;
    final categoryId = _selectedCategoryId;
    final phoneCountry = _selectedPhoneCountryCode;

    if (businessType == null || businessType.isEmpty) {
      _showError('Please select a business type.');
      return;
    }

    if (categoryId == null) {
      _showError('Please select a category.');
      return;
    }

    if (phoneCountry == null || phoneCountry.isEmpty) {
      _showError('Please select your phone country.');
      return;
    }

    // ------------------------------------------------------------
    // Form values
    // ------------------------------------------------------------

    final storeName = _storeNameController.text.trim();

    final email = _emailController.text.trim();

    final phone = _phoneController.text.trim();

    final address = _addressController.text.trim();

    final about = _aboutController.text.trim();

    final tradeLicenseNumber = _licenseNumberController.text.trim();

    final password = _passwordController.text;

    final passwordConfirmation = _passwordConfirmationController.text;

    if (phone.isEmpty) {
      _showError('Phone number is required.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneFull = phone;

      // ==========================================================
      // REGISTER REQUEST
      // ==========================================================

      final result = await _registerController.register(
        storeName: storeName,
        businessType: businessType,
        email: email,
        phoneFull: phoneFull,
        phoneCountry: phoneCountry,
        address: address,
        categoryId: categoryId,
        about: about,
        tradeLicenseNumber: tradeLicenseNumber.isEmpty
            ? null
            : tradeLicenseNumber,
        password: password,
        passwordConfirmation: passwordConfirmation,
        termsAgreed: '1',
      );

      if (!mounted) {
        return;
      }

      // ==========================================================
      // SUCCESS
      // ==========================================================

      if (result.success == true) {
        await _showRegistrationSuccessDialog(
          message:
              result.message ??
              'Registration successful. Please verify your email before logging in.',
        );
        return;
      }

      // ==========================================================
      // API FAILURE
      // ==========================================================

      _showError(result.message ?? 'Registration failed. Please try again.');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError('Something went wrong. Please try again.');
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR SNACKBAR
  // ═══════════════════════════════════════════════════════════════════════════

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          backgroundColor: AppColors.errorDark,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildBackground(size),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 24 + bottomInset),
              child: Column(
                children: [_buildHeroSection(size), _buildWizardCard(size)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUND
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBackground(Size size) {
    final screenHeight = size.height;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.51,
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),

          Positioned(
            top: 70,
            right: -55,
            child: _buildBackgroundCircle(size: 170, opacity: 0.05),
          ),

          Positioned(
            top: 180,
            right: -90,
            child: _buildBackgroundCircle(size: 230, opacity: 0.04),
          ),

          Positioned(
            top: 280,
            right: -120,
            child: _buildBackgroundCircle(size: 300, opacity: 0.035),
          ),

          Positioned.fill(
            top: screenHeight * 0.45,
            child: Container(color: AppColors.background),
          ),

          ClipPath(
            clipper: _HeroWaveClipper(),
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.53,
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircle({
    required double size,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: opacity),
          width: 28,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HERO
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeroSection(Size size) {
    final isSmallHeight = size.height < 700;

    final horizontalPadding = size.width < 350 ? 16.0 : 20.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        isSmallHeight ? 18 : 22,
        horizontalPadding,
        isSmallHeight ? 30 : 35,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandHeader(),

          SizedBox(height: isSmallHeight ? 14 : 17),

          Text(
            'Start your\nbusiness journey',
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.white,
              fontSize: size.width < 350 ? 23 : 25,
              height: 1.02,
              letterSpacing: -0.7,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            'Create your vendor account, manage your '
            'store, track orders, and grow your business '
            'from one simple platform.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.90),
              fontSize: size.width < 350 ? 10.5 : 11.5,
              height: 1.4,
            ),
          ),

          SizedBox(height: isSmallHeight ? 14 : 17),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
          ),
          child: const Icon(
            Icons.storefront_rounded,
            color: AppColors.white,
            size: 17,
          ),
        ),

        const SizedBox(width: 11),

        Text(
          'Vendor Hub',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WIZARD CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildWizardCard(Size size) {
    final isSmallScreen = size.width < 350;

    return Transform.translate(
      offset: const Offset(0, -15),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
        padding: EdgeInsets.fromLTRB(
          isSmallScreen ? 16 : 20,
          20,
          isSmallScreen ? 16 : 20,
          20,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowStrong,
              blurRadius: 22,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildStepIndicator(),

            const SizedBox(height: 24),

            if (_currentStep == 0) _buildStep1Content(),

            if (_currentStep == 1) _buildStep2Content(),

            if (_currentStep == 2) _buildStep3Content(),

            const SizedBox(height: 24),

            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP INDICATOR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepCircle(1, 'Business\nDetails'),

        Expanded(child: _buildStepLine(0)),

        _buildStepCircle(2, 'Contact &\nLocation'),

        Expanded(child: _buildStepLine(1)),

        _buildStepCircle(3, 'Profile &\nCompliance'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep >= step - 1;

    final isCompleted = _currentStep > step - 1;

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.success
                : isActive
                ? AppColors.primary
                : AppColors.draft,
            border: Border.all(
              color: isActive || isCompleted
                  ? Colors.transparent
                  : AppColors.draft,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '$step',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.draft,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isCompleted
                ? AppColors.success
                : isActive
                ? AppColors.primary
                : AppColors.draft,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int index) {
    final isActive = _currentStep > index;

    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? AppColors.success : AppColors.draftLight,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 1
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStep1Content() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Details',
            style: AppTextStyles.authTitle.copyWith(fontSize: 20),
          ),

          const SizedBox(height: 4),

          Text(
            'Store basics & category',
            style: AppTextStyles.authSubtitle.copyWith(fontSize: 12),
          ),

          const SizedBox(height: 20),

          // Store Name
          CustomTextField(
            controller: _storeNameController,
            focusNode: _storeNameFocusNode,
            label: 'Store Name *',
            hintText: 'Enter your store name',
            prefixIcon: Icons.store_outlined,
            textInputAction: TextInputAction.next,
            validator: AuthValidator.businessName,
            onSubmitted: (_) {
              _licenseNumberFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 16),

          // Business Type
          _buildBusinessTypeDropdown(),

          const SizedBox(height: 16),

          // Category
          _buildCategoryDropdown(),

          const SizedBox(height: 16),

          // Trade License
          CustomTextField(
            controller: _licenseNumberController,
            focusNode: _licenseNumberFocusNode,
            label: 'Trade License Number',
            hintText: 'Optional but recommended',
            prefixIcon: Icons.description_outlined,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUSINESS TYPE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBusinessTypeDropdown() {
    return BusinessTypeDropdown(
      value: _selectedBusinessType,
      onChanged: (value) {
        setState(() {
          _selectedBusinessType = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select business type';
        }

        return null;
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCategoryDropdown() {
    return CategoryDropdown(
      value: _selectedCategoryId,
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }

        return null;
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 2
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStep2Content() {
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact & Location',
            style: AppTextStyles.authTitle.copyWith(fontSize: 20),
          ),

          const SizedBox(height: 4),

          Text(
            'Communication & address',
            style: AppTextStyles.authSubtitle.copyWith(fontSize: 12),
          ),

          const SizedBox(height: 20),

          // Email
          CustomTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: 'Email Address *',
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: false,
            validator: AuthValidator.email,
            onSubmitted: (_) {
              _phoneFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 16),

          // Phone
          _buildPhoneField(),

          const SizedBox(height: 16),

          // Address
          CustomTextField(
            controller: _addressController,
            focusNode: _addressFocusNode,
            label: 'Business Address *',
            hintText: 'Enter your full business address',
            maxLines: 3,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().length < 10) {
                return 'Address must be at least 10 characters';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPhoneField() {
    final example = _selectedPhoneRule?.example;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number *',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 6),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 110,
              margin: const EdgeInsets.only(right: 8),
              child: PhoneCodeDropdown(
                value: _selectedPhoneCountryCode,
                onChanged: (value) {
                  setState(() {
                    _selectedPhoneCountryCode = value;
                  });
                },
                onRuleChanged: (rule) {
                  setState(() {
                    _selectedPhoneRule = rule;

                    if (rule?.countryCode != null) {
                      _selectedPhoneCountryCode = rule!.countryCode;
                    }
                  });
                },
              ),
            ),

            Expanded(
              child: CustomTextField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                hintText: example != null
                    ? 'Example: $example'
                    : 'Enter phone number',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: _validatePhone,
              ),
            ),
          ],
        ),

        if (_selectedPhoneRule != null) ...[
          const SizedBox(height: 6),

          Text(
            _phoneRuleHint(),
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Phone number is required';
    }

    final rule = _selectedPhoneRule;

    if (rule == null) {
      return 'Phone rules are still loading. Please try again.';
    }

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must contain digits only';
    }

    final minLength = rule.minLength;
    final maxLength = rule.maxLength;
    final example = rule.example;

    final length = phone.length;

    if (minLength != null && length < minLength) {
      if (minLength == maxLength) {
        return example != null
            ? 'Phone number must be $minLength digits. '
                  'Example: $example'
            : 'Phone number must be $minLength digits';
      }

      return example != null
          ? 'Phone number must be at least $minLength digits. '
                'Example: $example'
          : 'Phone number must be at least $minLength digits';
    }

    if (maxLength != null && length > maxLength) {
      if (minLength == maxLength) {
        return example != null
            ? 'Phone number must be $maxLength digits. '
                  'Example: $example'
            : 'Phone number must be $maxLength digits';
      }

      return example != null
          ? 'Phone number must be between '
                '$minLength-$maxLength digits. '
                'Example: $example'
          : 'Phone number must be between '
                '$minLength-$maxLength digits';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE RULE HINT
  // ═══════════════════════════════════════════════════════════════════════════

  String _phoneRuleHint() {
    final rule = _selectedPhoneRule;

    if (rule == null) {
      return '';
    }

    final minLength = rule.minLength;
    final maxLength = rule.maxLength;
    final example = rule.example;
    final countryCode = rule.countryCode;

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
      lengthText = 'valid length';
    }

    final parts = <String>[
      if (countryCode != null) countryCode,
      lengthText,
      if (example != null) 'Example: $example',
    ];

    return parts.join(' • ');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP 3
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStep3Content() {
    return Form(
      key: _step3FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile & Compliance',
            style: AppTextStyles.authTitle.copyWith(fontSize: 20),
          ),

          const SizedBox(height: 4),

          Text(
            'Business story & consents',
            style: AppTextStyles.authSubtitle.copyWith(fontSize: 12),
          ),

          const SizedBox(height: 20),

          // About
          CustomTextField(
            controller: _aboutController,
            focusNode: _aboutFocusNode,
            label: 'About Your Business *',
            hintText: 'Tell us about your business (min 50 characters)',
            maxLines: 4,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().length < 50) {
                return 'Minimum 50 characters required';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password
          CustomTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            label: 'Password *',
            hintText: 'Create a password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.next,
            validator: AuthValidator.password,
            onSubmitted: (_) {
              _passwordConfirmationFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password
          CustomTextField(
            controller: _passwordConfirmationController,
            focusNode: _passwordConfirmationFocusNode,
            label: 'Confirm Password *',
            hintText: 'Confirm your password',
            prefixIcon: Icons.lock_reset_outlined,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (value) {
              return AuthValidator.confirmPassword(
                value,
                password: _passwordController.text,
              );
            },
          ),

          const SizedBox(height: 16),

          // Terms
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _termsAgreed,
                onChanged: (value) {
                  setState(() {
                    _termsAgreed = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION BUTTONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ----------------------------------------------------------
        // Back
        // ----------------------------------------------------------
        if (_currentStep > 0)
          Expanded(
            child: CustomButton(
              text: 'Back',
              icon: Icons.arrow_back_rounded,
              iconPosition: CustomButtonIconPosition.leading,
              onPressed: _prevStep,
              type: CustomButtonType.outlined,
              height: 47,
              borderRadius: 10,
            ),
          )
        else
          const Spacer(),

        const SizedBox(width: 12),

        // ----------------------------------------------------------
        // Next / Submit
        // ----------------------------------------------------------
        Expanded(
          child: CustomButton(
            text: _currentStep == 2 ? 'Submit Application' : 'Next',
            icon: _currentStep == 2
                ? Icons.check_circle_outline
                : Icons.arrow_forward_rounded,
            iconPosition: CustomButtonIconPosition.trailing,
            onPressed: _currentStep == 2 ? _handleRegister : _nextStep,
            isLoading: _isLoading,
            type: CustomButtonType.primary,
            height: 47,
            borderRadius: 10,
            elevation: 3,
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// HERO WAVE CLIPPER
// ═════════════════════════════════════════════════════════════════════════════

class _HeroWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);

    path.lineTo(0, size.height * 0.87);

    path.quadraticBezierTo(
      size.width * 0.18,
      size.height * 0.94,
      size.width * 0.38,
      size.height * 0.90,
    );

    path.quadraticBezierTo(
      size.width * 0.61,
      size.height * 0.85,
      size.width * 0.80,
      size.height * 0.88,
    );

    path.quadraticBezierTo(
      size.width * 0.92,
      size.height * 0.91,
      size.width,
      size.height * 0.83,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
