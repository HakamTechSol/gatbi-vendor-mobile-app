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
import '../Controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.onSubmit, this.onBackToLogin});

  final Future<void> Function(String email)? onSubmit;
  final VoidCallback? onBackToLogin;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT / DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleSubmit() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // ================================================================
      // API CONNECTION
      // ================================================================

      final dioClient = ref.read(dioProvider);

      final controller = ForgotPasswordController(dioClient: dioClient);

      final result = await controller.forgotPassword(email: email);

      if (!mounted) return;

      // ================================================================
      // API SUCCESS
      // ================================================================

      if (result.success == true) {
        await _showSuccessDialog(
          message:
              result.message ??
              'If a vendor account exists, a password reset link will be sent.',
        );
      }
    } on ApiException catch (error) {
      if (!mounted) return;

      _showError(error.message);
    } catch (error) {
      if (!mounted) return;

      _showError('Something went wrong. Please try again.');
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMAIL VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  String? _validateEmail(String? value) {
    return AuthValidator.email(value);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUCCESS DIALOG
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _showSuccessDialog({required String message}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==========================================================
                // SUCCESS ICON
                // ==========================================================
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.softGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryLight),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_rounded,
                    color: AppColors.primary,
                    size: 31,
                  ),
                ),

                const SizedBox(height: 16),

                // ==========================================================
                // TITLE
                // ==========================================================
                Text(
                  'Reset Link Sent',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authTitle.copyWith(
                    fontSize: 21,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 9),

                // ==========================================================
                // MESSAGE
                // ==========================================================
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authSubtitle.copyWith(
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 22),

                // ==========================================================
                // CONFIRM BUTTON
                // ==========================================================
                CustomButton(
                  text: 'Confirm',
                  icon: Icons.check_rounded,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  type: CustomButtonType.primary,
                  height: 46,
                  borderRadius: 10,
                  elevation: 2,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    // ================================================================
    // AFTER CONFIRM → LOGIN
    // ================================================================

    context.go(AppRoutes.login);
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
                children: [
                  _buildHeroSection(size),
                  _buildForgotPasswordCard(size),
                ],
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
        isSmallHeight ? 35 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandHeader(),

          SizedBox(height: isSmallHeight ? 18 : 22),

          Text(
            'Reset your\npassword',
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
            'Enter your registered email address and '
            'we will send you a link to reset your password.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.90),
              fontSize: size.width < 350 ? 10.5 : 11.5,
              height: 1.4,
            ),
          ),
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
  // FORGOT PASSWORD CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildForgotPasswordCard(Size size) {
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
              _buildForgotIcon(),

              const SizedBox(height: 9),

              Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: AppTextStyles.authTitle.copyWith(
                  fontSize: isSmallScreen ? 24 : 26,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Enter your email to reset your password',
                textAlign: TextAlign.center,
                style: AppTextStyles.authSubtitle.copyWith(fontSize: 11),
              ),

              const SizedBox(height: 20),

              _buildEmailField(),

              const SizedBox(height: 18),

              _buildResetButton(),

              const SizedBox(height: 18),

              _buildBackToLogin(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildForgotIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: const Icon(
        Icons.lock_reset_rounded,
        size: 29,
        color: AppColors.primary,
      ),
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
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      validator: _validateEmail,
      onSubmitted: (_) {
        _handleSubmit();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESET BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildResetButton() {
    return CustomButton(
      text: 'Send Reset Link',
      icon: Icons.send_rounded,
      onPressed: _handleSubmit,
      isLoading: _isLoading,
      type: CustomButtonType.primary,
      height: 47,
      borderRadius: 10,
      elevation: 3,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACK TO LOGIN
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBackToLogin() {
    return CustomButton(
      text: 'Back to Login',
      icon: Icons.arrow_back_rounded,
      iconPosition: CustomButtonIconPosition.leading,
      onPressed:
          widget.onBackToLogin ??
          () {
            context.go(AppRoutes.login);
          },
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 10,
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
