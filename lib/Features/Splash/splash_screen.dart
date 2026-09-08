import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Theme/app_colors.dart';
import '../../Theme/app_dimensions.dart';
import '../../Theme/app_text_styles.dart';
import '../../Routes/app_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String _onboardingCompletedKey = 'onboarding_completed';

  static const Duration _splashDuration = Duration(milliseconds: 2600);

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMATION
  // ═══════════════════════════════════════════════════════════════════════════

  late final AnimationController _animationController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  Timer? _navigationTimer;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.35, 0.9, curve: Curves.easeOut),
      ),
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.35, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();

    _navigationTimer = Timer(_splashDuration, _finishSplash);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SPLASH NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _finishSplash() async {
    if (!mounted) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool onboardingCompleted =
        prefs.getBool(_onboardingCompletedKey) ?? false;

    if (!mounted) return;

    if (onboardingCompleted) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            _buildBackgroundDecoration(),

            // ───────────────────────────────────────────────────────────────
            // CENTER BRAND
            // ───────────────────────────────────────────────────────────────
            Center(child: _buildBrandSection()),

            // ───────────────────────────────────────────────────────────────
            // BOTTOM
            // ───────────────────────────────────────────────────────────────
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUND
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBackgroundDecoration() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _buildGlowCircle(size: 230, opacity: 0.12),
          ),

          Positioned(
            top: 150,
            left: -100,
            child: _buildGlowCircle(size: 190, opacity: 0.08),
          ),

          Positioned(
            bottom: -110,
            right: -50,
            child: _buildGlowCircle(size: 260, opacity: 0.10),
          ),

          Positioned(
            bottom: 120,
            left: -80,
            child: _buildGlowCircle(size: 160, opacity: 0.06),
          ),

          // Small decorative circles.
          Positioned(top: 110, right: 40, child: _buildSmallDot()),

          Positioned(top: 135, right: 75, child: _buildSmallDot()),

          Positioned(bottom: 170, left: 35, child: _buildSmallDot()),
        ],
      ),
    );
  }

  Widget _buildGlowCircle({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: opacity),
      ),
    );
  }

  Widget _buildSmallDot() {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBrandSection() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(scale: _logoScale, child: child),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(),

          const SizedBox(height: AppDimensions.spacing24),

          Text('Gatbi', style: AppTextStyles.splashBrand),

          const SizedBox(height: AppDimensions.splashBrandSpacing),

          Text('Vendor Dashboard', style: AppTextStyles.splashTagline),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOGO
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLogo() {
    return Container(
      width: AppDimensions.splashLogoContainer,
      height: AppDimensions.splashLogoContainer,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDark.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: AppDimensions.splashLogoSize,
          height: AppDimensions.splashLogoSize,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.navyDark.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(child: _buildBrandMark()),
        ),
      ),
    );
  }

  Widget _buildBrandMark() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return AppColors.primaryGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      blendMode: BlendMode.srcIn,
      child: const Icon(
        Icons.storefront_rounded,
        size: AppDimensions.iconSizeHuge,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomSection() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: _contentFade,
          child: SlideTransition(position: _contentSlide, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.screenHorizontal,
          right: AppDimensions.screenHorizontal,
          bottom: AppDimensions.splashBottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoadingIndicator(),

            const SizedBox(height: AppDimensions.spacing16),

            Text(
              'Manage your store with ease',
              textAlign: TextAlign.center,
              style: AppTextStyles.splashTagline.copyWith(
                fontSize: 12,
                color: AppColors.white.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.white.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}
