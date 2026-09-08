import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../Routes/app_route.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.token,
    this.onResetPassword,
    this.onBackToLogin,
  });

  /// Token received from the password reset deep link.
  final String token;

  final Future<void> Function(
    String token,
    String password,
    String passwordConfirmation,
  )?
  onResetPassword;

  final VoidCallback? onBackToLogin;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT / DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESET PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleResetPassword() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.onResetPassword != null) {
        await widget.onResetPassword!(
          widget.token,
          _passwordController.text,
          _confirmPasswordController.text,
        );
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 800));
      }

      if (!mounted) return;

      // Reset password successful → Login Screen
      context.go(AppRoutes.login);
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

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your new password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != _passwordController.text) {
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
  // SUCCESS
  // ═══════════════════════════════════════════════════════════════════════════

  // void _showSuccess() {
  //   ScaffoldMessenger.of(context)
  //     ..hideCurrentSnackBar()
  //     ..showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Password reset successfully',
  //           style: AppTextStyles.bodyMedium.copyWith(
  //             color: AppColors.white,
  //             fontSize: 13,
  //           ),
  //         ),
  //         backgroundColor: AppColors.success,
  //         behavior: SnackBarBehavior.floating,
  //         margin: const EdgeInsets.all(16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //     );
  // }

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
                  _buildResetPasswordCard(size),
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
            'Create a new\npassword',
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
            'Choose a strong password to keep your '
            'Vendor Hub account secure.',
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
  // RESET PASSWORD CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildResetPasswordCard(Size size) {
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
              _buildResetIcon(),

              const SizedBox(height: 9),

              Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: AppTextStyles.authTitle.copyWith(
                  fontSize: isSmallScreen ? 24 : 26,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Enter your new password below',
                textAlign: TextAlign.center,
                style: AppTextStyles.authSubtitle.copyWith(fontSize: 11),
              ),

              const SizedBox(height: 20),

              _buildPasswordField(),

              const SizedBox(height: 13),

              _buildConfirmPasswordField(),

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

  Widget _buildResetIcon() {
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
  // PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      label: 'New Password',
      hintText: 'Enter your new password',
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      textInputAction: TextInputAction.next,
      validator: _validatePassword,
      onSubmitted: (_) {
        _confirmPasswordFocusNode.requestFocus();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONFIRM PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      label: 'Confirm Password',
      hintText: 'Re-enter your new password',
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      textInputAction: TextInputAction.done,
      validator: _validateConfirmPassword,
      onSubmitted: (_) {
        _handleResetPassword();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESET BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildResetButton() {
    return CustomButton(
      text: 'Reset Password',
      icon: Icons.check_circle_outline_rounded,
      onPressed: _handleResetPassword,
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
      onPressed: widget.onBackToLogin,
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
