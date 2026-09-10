import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Routes/app_route.dart';
import '../../Theme/app_colors.dart';
import '../../Theme/app_dimensions.dart';
import '../../Theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onFinished});

  final VoidCallback? onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  late final PageController _pageController;

  late final AnimationController _contentAnimationController;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  int _currentPage = 0;

  bool _isCompleting = false;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  // ═══════════════════════════════════════════════════════════════════════════
  // ONBOARDING DATA
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Manage Your Store',
      description:
          'Keep your products, inventory and store operations organized from one simple dashboard.',
      icon: Icons.storefront_rounded,
      secondaryIcon: Icons.inventory_2_rounded,
      accentIcon: Icons.dashboard_rounded,
      illustrationLabel: 'Your store, simplified',
    ),
    _OnboardingData(
      title: 'Track Orders Easily',
      description:
          'Stay on top of your orders and monitor their progress with a clear and intuitive experience.',
      icon: Icons.shopping_bag_rounded,
      secondaryIcon: Icons.local_shipping_rounded,
      accentIcon: Icons.receipt_long_rounded,
      illustrationLabel: 'Orders at a glance',
    ),
    _OnboardingData(
      title: 'Grow Your Business',
      description:
          'Get the tools you need to manage your vendor journey and keep your business moving forward.',
      icon: Icons.trending_up_rounded,
      secondaryIcon: Icons.insights_rounded,
      accentIcon: Icons.auto_graph_rounded,
      illustrationLabel: 'Built for your growth',
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _contentFade = CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOut,
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _contentAnimationController.forward();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAGE CHANGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _onPageChanged(int page) {
    if (!mounted) return;

    setState(() {
      _currentPage = page;
    });

    _contentAnimationController
      ..reset()
      ..forward();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLETE ONBOARDING
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save onboarding completion permanently.
      await prefs.setBool(_onboardingCompletedKey, true);

      if (!mounted) return;

      // Optional callback if parent wants to handle completion.
      widget.onFinished?.call();

      // Navigate to login.
      context.go(AppRoutes.login);
    } catch (e) {
      debugPrint('❌ Failed to save onboarding status: $e');

      if (!mounted) return;

      setState(() {
        _isCompleting = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NEXT
  // ═══════════════════════════════════════════════════════════════════════════

  void _nextPage() {
    if (_isLastPage) {
      _completeOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildPage(context, _pages[index], index);
                },
              ),
            ),

            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TOP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.spacing8,
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildBrandMini()],
        ),
      ),
    );
  }

  Widget _buildBrandMini() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radius10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow,
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.storefront_rounded,
            size: 19,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing10),
        Text(
          'Gatbi',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPage(BuildContext context, _OnboardingData data, int index) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spacing8),

          _buildIllustration(context, data, index),

          const SizedBox(height: AppDimensions.spacing28),

          AnimatedBuilder(
            animation: _contentAnimationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _contentFade,
                child: SlideTransition(position: _contentSlide, child: child),
              );
            },
            child: _buildTextContent(data),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ILLUSTRATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildIllustration(
    BuildContext context,
    _OnboardingData data,
    int index,
  ) {
    final size = MediaQuery.sizeOf(context);

    final illustrationHeight = size.height < 700
        ? 270.0
        : AppDimensions.onboardingIllustrationHeight;

    return SizedBox(
      width: double.infinity,
      height: illustrationHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: illustrationHeight * 0.82,
            height: illustrationHeight * 0.82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.softGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),

          Positioned(
            top: 22,
            right: 30,
            child: _buildDecorativeCircle(
              size: 54,
              color: AppColors.purple,
              opacity: 0.10,
            ),
          ),

          Positioned(
            bottom: 24,
            left: 24,
            child: _buildDecorativeCircle(
              size: 42,
              color: AppColors.primary,
              opacity: 0.10,
            ),
          ),

          _buildMainIllustrationCard(data, index),

          Positioned(
            top: 48,
            right: 16,
            child: _buildFloatingCard(icon: data.secondaryIcon, small: true),
          ),

          Positioned(
            bottom: 38,
            left: 12,
            child: _buildFloatingCard(icon: data.accentIcon, small: false),
          ),

          Positioned(right: 28, bottom: 30, child: _buildStatusBadge(index)),
        ],
      ),
    );
  }

  Widget _buildMainIllustrationCard(_OnboardingData data, int index) {
    return Container(
      width: 196,
      height: 196,
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -32,
            right: -32,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.10),
              ),
            ),
          ),

          Positioned(
            bottom: -45,
            left: -35,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(data.icon, size: 44, color: AppColors.white),
                ),

                const SizedBox(height: AppDimensions.spacing16),

                Text(
                  data.illustrationLabel,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing6),

                _buildMiniLines(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniLines() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMiniLine(width: 26),
        const SizedBox(width: 5),
        _buildMiniLine(width: 12),
        const SizedBox(width: 5),
        _buildMiniLine(width: 18),
      ],
    );
  }

  Widget _buildMiniLine({required double width}) {
    return Container(
      width: width,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(AppDimensions.radius4),
      ),
    );
  }

  Widget _buildFloatingCard({required IconData icon, required bool small}) {
    final size = small ? 48.0 : 54.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: small ? 21 : 24,
        color: small ? AppColors.purple : AppColors.primary,
      ),
    );
  }

  Widget _buildDecorativeCircle({
    required double size,
    required Color color,
    required double opacity,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }

  Widget _buildStatusBadge(int index) {
    final labels = ['Simple', 'Organized', 'Growing'];

    final icons = [
      Icons.check_rounded,
      Icons.bolt_rounded,
      Icons.trending_up_rounded,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing10,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icons[index], size: 15, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacing6),
          Text(
            labels[index],
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTextContent(_OnboardingData data) {
    return Column(
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.onboardingTitle,
        ),

        const SizedBox(height: AppDimensions.onboardingTitleSpacing),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.onboardingDescription,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.spacing12,
        AppDimensions.screenHorizontal,
        AppDimensions.spacing24,
      ),
      child: Column(
        children: [
          _buildPageIndicators(),

          const SizedBox(height: AppDimensions.spacing24),

          Row(
            children: [
              if (_currentPage > 0)
                _buildBackButton()
              else
                const SizedBox(width: 52),

              const Spacer(),

              _buildNextButton(),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAGE INDICATORS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final isActive = index == _currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive
              ? AppDimensions.onboardingIndicatorActiveWidth
              : AppDimensions.onboardingIndicatorSize,
          height: AppDimensions.onboardingIndicatorHeight,
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.primaryGradient : null,
            color: isActive ? null : AppColors.borderStrong,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACK BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBackButton() {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
      child: InkWell(
        onTap: _isCompleting
            ? null
            : () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                );
              },
        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        child: Container(
          width: 52,
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: AppDimensions.buttonIconSize,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NEXT BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildNextButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryShadow,
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          onTap: _isCompleting ? null : _nextPage,
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          child: Container(
            height: AppDimensions.buttonHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing20,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isCompleting)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                else ...[
                  Text(
                    _isLastPage ? 'Get Started' : 'Next',
                    style: AppTextStyles.buttonLarge,
                  ),
                  const SizedBox(width: AppDimensions.buttonIconGap),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: AppDimensions.buttonIconSize,
                    color: AppColors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ONBOARDING MODEL
// ═════════════════════════════════════════════════════════════════════════════

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.secondaryIcon,
    required this.accentIcon,
    required this.illustrationLabel,
  });

  final String title;
  final String description;

  final IconData icon;
  final IconData secondaryIcon;
  final IconData accentIcon;

  final String illustrationLabel;
}
