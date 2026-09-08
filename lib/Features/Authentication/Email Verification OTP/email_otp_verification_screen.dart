import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Routes/app_route.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class EmailOtpVerificationScreen extends StatefulWidget {
  const EmailOtpVerificationScreen({
    super.key,
    required this.email,
    this.onVerifyOtp,
    this.onResendOtp,
    this.onBack,
  });

  /// Email received from registration screen.
  final String email;

  /// Verify 6 digit OTP.
  final Future<void> Function(String otp)? onVerifyOtp;

  /// Resend OTP.
  final Future<void> Function()? onResendOtp;

  /// Back button.
  final VoidCallback? onBack;

  @override
  State<EmailOtpVerificationScreen> createState() =>
      _EmailOtpVerificationScreenState();
}

class _EmailOtpVerificationScreenState
    extends State<EmailOtpVerificationScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _isResending = false;

  Timer? _resendTimer;

  int _resendSeconds = 30;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _startResendTimer();

    for (final controller in _otpControllers) {
      controller.addListener(_onOtpChanged);
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    for (final controller in _otpControllers) {
      controller.removeListener(_onOtpChanged);
      controller.dispose();
    }

    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OTP CHANGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _onOtpChanged() {
    if (!mounted) return;

    final otp = _getOtp();

    if (otp.length == 6) {
      FocusScope.of(context).unfocus();
    }

    setState(() {});
  }

  String _getOtp() {
    return _otpControllers.map((controller) {
      return controller.text;
    }).join();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OTP INPUT
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleOtpChanged(String value, int index) {
    if (value.length > 1) {
      _handlePaste(value, index);
      return;
    }

    if (value.isNotEmpty) {
      if (index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PASTE OTP
  // ═══════════════════════════════════════════════════════════════════════════

  void _handlePaste(String value, int startIndex) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return;

    final availableSlots = 6 - startIndex;

    final pasteDigits = digits.substring(
      0,
      digits.length > availableSlots ? availableSlots : digits.length,
    );

    for (int i = 0; i < pasteDigits.length; i++) {
      _otpControllers[startIndex + i].text = pasteDigits[i];
    }

    final nextIndex = startIndex + pasteDigits.length;

    if (nextIndex < 6) {
      _otpFocusNodes[nextIndex].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }

    setState(() {});
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKSPACE
  // ═══════════════════════════════════════════════════════════════════════════

  KeyEventResult _handleKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otpControllers[index].text.isEmpty && index > 0) {
        _otpControllers[index - 1].clear();
        _otpFocusNodes[index - 1].requestFocus();

        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VERIFY OTP
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleVerify() async {
    if (_isVerifying) return;

    final otp = _getOtp();

    if (otp.length != 6) {
      _showError('Please enter the 6-digit verification code.');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isVerifying = true;
    });

    try {
      if (widget.onVerifyOtp != null) {
        await widget.onVerifyOtp!(otp);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 800));
      }

      // ============================================================
      // OTP SUCCESS → DASHBOARD
      // ============================================================

      if (!mounted) return;

      context.go(AppRoutes.bottombar);
    } catch (error) {
      if (!mounted) return;

      _showError(error.toString());
    } finally {
      if (!mounted) return;

      setState(() {
        _isVerifying = false;
      });
    }
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // RESEND TIMER
  // ═══════════════════════════════════════════════════════════════════════════

  void _startResendTimer() {
    _resendTimer?.cancel();

    setState(() {
      _resendSeconds = 30;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendSeconds <= 1) {
        timer.cancel();

        setState(() {
          _resendSeconds = 0;
        });
      } else {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESEND OTP
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleResend() async {
    if (_isResending || _resendSeconds > 0) {
      return;
    }

    setState(() {
      _isResending = true;
    });

    try {
      if (widget.onResendOtp != null) {
        await widget.onResendOtp!();
      }

      _clearOtp();

      _startResendTimer();

      if (!mounted) return;

      _showSuccess('A new OTP has been sent to your email.');
    } catch (error) {
      if (!mounted) return;

      _showError(error.toString());
    } finally {
      if (!mounted) return;

      setState(() {
        _isResending = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEAR OTP
  // ═══════════════════════════════════════════════════════════════════════════

  void _clearOtp() {
    for (final controller in _otpControllers) {
      controller.clear();
    }

    _otpFocusNodes.first.requestFocus();

    setState(() {});
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SNACKBARS
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

  void _showSuccess(String message) {
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
          backgroundColor: AppColors.primary,
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
                children: [_buildHeroSection(size), _buildOtpCard(size)],
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

          SizedBox(height: isSmallHeight ? 14 : 17),

          Text(
            'Verify your\nemail address',
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
            'Enter the verification code sent to your '
            'email address to complete your registration.',
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
  // OTP CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOtpCard(Size size) {
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
            _buildOtpIcon(),

            const SizedBox(height: 9),

            Text(
              'Verify OTP',
              textAlign: TextAlign.center,
              style: AppTextStyles.authTitle.copyWith(
                fontSize: isSmallScreen ? 24 : 26,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'We sent a 6-digit verification code to',
              textAlign: TextAlign.center,
              style: AppTextStyles.authSubtitle.copyWith(fontSize: 11),
            ),

            const SizedBox(height: 4),

            Text(
              widget.email,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.buttonText.copyWith(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 22),

            _buildOtpFields(),

            const SizedBox(height: 20),

            _buildVerifyButton(),

            const SizedBox(height: 18),

            _buildResendSection(),

            const SizedBox(height: 16),

            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OTP ICON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOtpIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: const Icon(
        Icons.mark_email_read_outlined,
        size: 29,
        color: AppColors.primary,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OTP FIELDS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return _buildOtpBox(index);
      }),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 43,
      height: 50,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          _handleKeyEvent(event, index);
        },
        child: TextField(
          controller: _otpControllers[index],
          focusNode: _otpFocusNodes[index],
          keyboardType: TextInputType.number,
          textInputAction: index == 5
              ? TextInputAction.done
              : TextInputAction.next,
          textAlign: TextAlign.center,
          maxLength: 1,
          autofocus: index == 0,
          style: AppTextStyles.authTitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.8),
            ),
          ),
          onChanged: (value) {
            _handleOtpChanged(value, index);
          },
          onSubmitted: (_) {
            if (index == 5) {
              _handleVerify();
            }
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VERIFY BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildVerifyButton() {
    return CustomButton(
      text: 'Verify OTP',
      icon: Icons.verified_rounded,
      onPressed: _handleVerify,
      isLoading: _isVerifying,
      type: CustomButtonType.primary,
      height: 47,
      borderRadius: 10,
      elevation: 3,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESEND
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildResendSection() {
    final canResend = _resendSeconds == 0 && !_isResending;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code?",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),

        const SizedBox(width: 5),

        if (_isResending)
          const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 1.8,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          )
        else if (_resendSeconds > 0)
          Text(
            'Resend in ${_resendSeconds}s',
            style: AppTextStyles.buttonText.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          )
        else
          GestureDetector(
            onTap: canResend ? _handleResend : null,
            child: Text(
              'Resend OTP',
              style: AppTextStyles.buttonText.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACK BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBackButton() {
    return CustomButton(
      text: 'Back to Registration',
      icon: Icons.arrow_back_rounded,
      onPressed: widget.onBack,
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
