import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLogin,
    this.onForgotPassword,
    this.onRegister,
    this.onBackToWebsite,
  });

  final Future<void> Function(String email, String password)? onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;
  final VoidCallback? onBackToWebsite;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT / DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGIN
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleLogin() async {
  if (_isLoading) return;

  FocusScope.of(context).unfocus();

  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    if (widget.onLogin != null) {
      await widget.onLogin!(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      await Future<void>.delayed(
        const Duration(milliseconds: 800),
      );
    }

    // ============================================================
    // LOGIN SUCCESS → DASHBOARD
    // ============================================================

    if (!mounted) return;

    context.go(AppRoutes.bottombar);
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24 + bottomInset),
                  child: Column(
                    children: [_buildHeroSection(size), _buildLoginCard(size)],
                  ),
                );
              },
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
          // Main gradient
          Container(
            width: double.infinity,
            height: screenHeight * 0.51,
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),

          // Decorative circles
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

          // Background
          Positioned.fill(
            top: screenHeight * 0.45,
            child: Container(color: AppColors.background),
          ),

          // Wave
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
        isSmallHeight ? 35 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandHeader(),

          SizedBox(height: isSmallHeight ? 14 : 17),

          Text(
            'Grow your\nbusiness with',
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
            'Access real-time sales insights, manage '
            'orders effortlessly, and keep your catalogue '
            'in sync across all channels.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.90),
              fontSize: size.width < 350 ? 10.5 : 11.5,
              height: 1.4,
            ),
          ),

          SizedBox(height: isSmallHeight ? 14 : 17),

          _buildFeatureCard(size),
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
  // FEATURE CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildFeatureCard(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // ← change this
        children: [
          Expanded(
            child: _buildFeatureItem(
              icon: Icons.analytics_outlined,
              title: 'Smart Analytics',
              description:
                  'Track revenue, best sellers, and performance in one place.',
            ),
          ),

          _buildFeatureDivider(),

          Expanded(
            child: _buildFeatureItem(
              icon: Icons.local_shipping_outlined,
              title: 'Order Fulfilment',
              description:
                  'Streamlined workflow to manage orders from placement to delivery.',
            ),
          ),

          _buildFeatureDivider(),

          Expanded(
            child: _buildFeatureItem(
              icon: Icons.headset_mic_outlined,
              title: 'Dedicated Support',
              description:
                  'Our merchant success team is available 6 days a week.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 15),
          ),

          const SizedBox(height: 7),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
              fontSize: 8.5,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 7,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureDivider() {
    return Container(
      width: 1,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: AppColors.divider,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGIN CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoginCard(Size size) {
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
              _buildLoginIcon(),

              const SizedBox(height: 9),

              Text(
                'Vendor Login',
                textAlign: TextAlign.center,
                style: AppTextStyles.authTitle.copyWith(
                  fontSize: isSmallScreen ? 24 : 26,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Sign in to manage your store',
                textAlign: TextAlign.center,
                style: AppTextStyles.authSubtitle.copyWith(fontSize: 11),
              ),

              const SizedBox(height: 20),

              _buildEmailField(),

              const SizedBox(height: 13),

              _buildPasswordField(),

              const SizedBox(height: 3),

              _buildForgotPassword(),

              const SizedBox(height: 13),

              _buildLoginButton(),

              const SizedBox(height: 18),

              _buildRegisterSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGIN ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoginIcon() {
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
      hintText: 'Enter your password',
      prefixIcon: Icons.lock_outline_rounded,
      isPassword: true,
      textInputAction: TextInputAction.done,
      validator: _validatePassword,
      onSubmitted: (_) {
        _handleLogin();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: widget.onForgotPassword,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Forgot Password?',
          style: AppTextStyles.buttonText.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGIN BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Login',
      icon: Icons.login_rounded,
      onPressed: _handleLogin,
      isLoading: _isLoading,
      type: CustomButtonType.primary,
      height: 47,
      borderRadius: 10,
      elevation: 3,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildRegisterSection() {
    return Column(
      children: [
        Text(
          'Don\'t have a vendor account?',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontSize: 11.5,
          ),
        ),

        const SizedBox(height: 7),

        CustomButton(
          text: 'Register as Vendor',
          onPressed: widget.onRegister,
          type: CustomButtonType.outlined,
          height: 44,
          borderRadius: 10,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACK TO WEBSITE
  // ═══════════════════════════════════════════════════════════════════════════

  // Widget _buildBackToWebsite() {
  //   return TextButton(
  //     onPressed: widget.onBackToWebsite,
  //     style: TextButton.styleFrom(
  //       foregroundColor: AppColors.primary,
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  //       minimumSize: Size.zero,
  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const Icon(Icons.arrow_back_rounded, size: 16),

  //         const SizedBox(width: 5),

  //         Text(
  //           'Back to Website',
  //           style: AppTextStyles.buttonText.copyWith(
  //             fontSize: 11.5,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
