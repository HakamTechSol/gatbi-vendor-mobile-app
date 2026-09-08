import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../Routes/app_route.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.onRegister, this.onBackToLogin});

  final Future<void> Function(
    String businessName,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  )?
  onRegister;

  final VoidCallback? onBackToLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _businessNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmationController;

  late final FocusNode _businessNameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT / DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _businessNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();

    _businessNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    _businessNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTER
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleRegister() async {
  if (_isLoading) return;

  FocusScope.of(context).unfocus();

  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    if (widget.onRegister != null) {
      await widget.onRegister!(
        _businessNameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _passwordController.text,
        _passwordConfirmationController.text,
      );
    } else {
      await Future<void>.delayed(
        const Duration(milliseconds: 800),
      );
    }

    // ============================================================
    // REGISTRATION SUCCESS → EMAIL OTP SCREEN
    // ============================================================

    if (!mounted) return;

    context.push(
      AppRoutes.emailotpVerification,
      extra: _emailController.text.trim(),
    );
  } catch (error) {
    if (!mounted) return;

    _showError(error.toString());
  } finally {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }
}
  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  String? _validateBusinessName(String? value) {
    final businessName = value?.trim() ?? '';

    if (businessName.isEmpty) {
      return 'Please enter your business name';
    }

    if (businessName.length < 2) {
      return 'Business name must be at least 2 characters';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    if (phone.length < 7) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    final confirmation = value ?? '';

    if (confirmation.isEmpty) {
      return 'Please confirm your password';
    }

    if (confirmation != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR
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
                children: [_buildHeroSection(size), _buildRegisterCard(size)],
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
  // HERO SECTION
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

  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND HEADER
  // ═══════════════════════════════════════════════════════════════════════════

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
  // REGISTER CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildRegisterCard(Size size) {
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildRegisterIcon(),

              const SizedBox(height: 9),

              Text(
                'Create Vendor Account',
                textAlign: TextAlign.center,
                style: AppTextStyles.authTitle.copyWith(
                  fontSize: isSmallScreen ? 23 : 25,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Register your business to get started',
                textAlign: TextAlign.center,
                style: AppTextStyles.authSubtitle.copyWith(fontSize: 11),
              ),

              const SizedBox(height: 20),

              _buildBusinessNameField(),

              const SizedBox(height: 13),

              _buildEmailField(),

              const SizedBox(height: 13),

              _buildPhoneField(),

              const SizedBox(height: 13),

              _buildPasswordField(),

              const SizedBox(height: 13),

              _buildPasswordConfirmationField(),

              const SizedBox(height: 20),

              _buildRegisterButton(),

              const SizedBox(height: 18),

              _buildLoginSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTER ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildRegisterIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: const Icon(
        Icons.storefront_rounded,
        size: 29,
        color: AppColors.primary,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUSINESS NAME
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBusinessNameField() {
    return CustomTextField(
      controller: _businessNameController,
      focusNode: _businessNameFocusNode,
      label: 'Business Name',
      hintText: 'Enter your business name',
      prefixIcon: Icons.business_outlined,
      textInputAction: TextInputAction.next,
      validator: _validateBusinessName,
      onSubmitted: (_) {
        _emailFocusNode.requestFocus();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMAIL
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      label: 'Email Address',
      hintText: 'Enter your email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      enableSuggestions: false,
      validator: _validateEmail,
      onSubmitted: (_) {
        _phoneFocusNode.requestFocus();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      focusNode: _phoneFocusNode,
      label: 'Phone Number',
      hintText: 'Enter your phone number',
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validator: _validatePhone,
      onSubmitted: (_) {
        _passwordFocusNode.requestFocus();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      label: 'Password',
      hintText: 'Create a password',
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      textInputAction: TextInputAction.next,
      validator: _validatePassword,
      onSubmitted: (_) {
        _passwordConfirmationFocusNode.requestFocus();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PASSWORD CONFIRMATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPasswordConfirmationField() {
    return CustomTextField(
      controller: _passwordConfirmationController,
      focusNode: _passwordConfirmationFocusNode,
      label: 'Confirm Password',
      hintText: 'Confirm your password',
      prefixIcon: Icons.lock_reset_outlined,
      isPassword: true,
      textInputAction: TextInputAction.done,
      validator: _validatePasswordConfirmation,
      onSubmitted: (_) {
        _handleRegister();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTER BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildRegisterButton() {
    return CustomButton(
      text: 'Create Account',
      icon: Icons.person_add_alt_1_rounded,
      onPressed: _handleRegister,
      isLoading: _isLoading,
      type: CustomButtonType.primary,
      height: 47,
      borderRadius: 10,
      elevation: 3,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGIN SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoginSection() {
    return Column(
      children: [
        Text(
          'Already have a vendor account?',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontSize: 11.5,
          ),
        ),

        const SizedBox(height: 7),

        CustomButton(
          text: 'Back to Login',
          icon: Icons.login_rounded,
          iconPosition: CustomButtonIconPosition.leading,
          onPressed: widget.onBackToLogin,
          type: CustomButtonType.outlined,
          height: 44,
          borderRadius: 10,
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
