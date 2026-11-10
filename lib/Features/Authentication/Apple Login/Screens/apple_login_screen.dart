import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Routes/app_route.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Social Login/Models/social_login_result.dart';
import '../Controller/apple_login_controller.dart';

class AppleLoginScreen extends ConsumerStatefulWidget {
  const AppleLoginScreen({super.key, this.onLoginSuccess});

  final VoidCallback? onLoginSuccess;

  @override
  ConsumerState<AppleLoginScreen> createState() => _AppleLoginScreenState();
}

class _AppleLoginScreenState extends ConsumerState<AppleLoginScreen> {
  bool _isLoading = false;

  /// Triggered when Apple Sign-In completes successfully.
  Future<void> _handleAppleSignIn() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final controller = AppleLoginController(dioClient: ref.read(dioProvider));

      final result = await controller.signInWithApple();

      if (!mounted) return;

      _handleSocialResult(result);
    } on ApiException catch (error) {
      if (!mounted) return;
      _showError(error.message);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Apple Sign-In failed: $error');
      }

      if (!mounted) return;
      _showError('Apple sign-in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSocialResult(SocialLoginResult result) {
    if (result.vendorNotFound) {
      context.go(
        AppRoutes.register,
        extra: {
          'email': result.email,
          'first_name': result.firstName,
          'last_name': result.lastName,
        },
      );
      return;
    }

    if (result.requiresOtp) {
      context.go(
        AppRoutes.loginotpVerification,
        extra: {
          'email': result.email ?? '',
          'merchant_id': result.merchantId,
          'expires_in_minutes': result.expiresInMinutes,
        },
      );
      return;
    }

    if (result.hasToken) {
      widget.onLoginSuccess?.call();
      return;
    }

    if (result.errorCode == 'CANCELLED') {
      return;
    }

    _showError(
      result.message ??
          'Apple sign-in could not be completed. Please try again.',
    );
  }

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
                    children: [_buildHeroSection(size), _buildAppleCard(size)],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.51,
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
            top: size.height * 0.45,
            child: Container(color: AppColors.background),
          ),

          ClipPath(
            clipper: _HeroWaveClipper(),
            child: Container(
              width: double.infinity,
              height: size.height * 0.53,
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
            'Grow your business with',
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
            'Access real-time sales insights, manage orders effortlessly, and keep your catalogue in sync across all channels.',
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
        crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget _buildAppleCard(Size size) {
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
            _buildAppleHeader(),

            const SizedBox(height: 18),

            _buildAppleButton(),

            const SizedBox(height: 16),

            _buildDivider(),

            const SizedBox(height: 12),

            _buildLoginWithEmailSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppleHeader() {
    final isSmallScreen = MediaQuery.sizeOf(context).width < 350;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Image.asset('assets/Vender.png', width: 28, height: 28),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue with Apple',
                style: AppTextStyles.authTitle.copyWith(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Sign in with your Apple ID',
                style: AppTextStyles.authSubtitle.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppleButton() {
    return CustomButton(
      text: 'Continue with Apple',
      icon: Icons.apple_rounded,
      onPressed: _handleAppleSignIn,
      isLoading: _isLoading,
      type: CustomButtonType.primary,
      height: 50,
      borderRadius: 12,
      elevation: 3,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        SizedBox(width: 20),
        Container(height: 1, width: double.infinity, color: AppColors.divider),
        const SizedBox(width: 14),
        Text(
          'or',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 14),
        Container(height: 1, width: double.infinity, color: AppColors.divider),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildLoginWithEmailSection() {
    return Column(
      children: [
        Text(
          'Use your email & password',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Login with Email'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () {
            context.go(AppRoutes.register);
          },
          child: Text(
            'Create One Free Account',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
