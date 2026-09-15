import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../Core/Bottom Naigation Bar/bottom_bar_screen.dart';
import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Services/api_exception.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Controller/change_password_controller.dart';
import '../Reuse Widgets/change_password_form.dart';
import '../Reuse Widgets/change_password_header.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key, this.onBack, this.onPasswordChanged});

  /// Called when the user taps the back button.
  final VoidCallback? onBack;

  /// Called after password has been changed successfully.
  final VoidCallback? onPasswordChanged;

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ============================================================
  // Form
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // State
  // ============================================================

  bool _isLoading = false;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // Actions
  // ============================================================

  Future<void> _handleChangePassword() async {
    FocusScope.of(context).unfocus();

    // ------------------------------------------------------------
    // Validate Form
    // ------------------------------------------------------------

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // ------------------------------------------------------------
    // Start Loading
    // ------------------------------------------------------------

    setState(() {
      _isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // Get Controller
      // ----------------------------------------------------------

      final controller = ref.read(changePasswordControllerProvider);

      // ----------------------------------------------------------
      // API Request
      // ----------------------------------------------------------

      final result = await controller.changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _confirmPasswordController.text,
      );

      if (!mounted) return;

      // ----------------------------------------------------------
      // Check API Success
      // ----------------------------------------------------------

      if (result.success) {
        context.push(AppRoutes.bottombar,extra: BottomTab.more);
        // --------------------------------------------------------
        // Clear Password Fields
        // --------------------------------------------------------

        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // --------------------------------------------------------
        // Reset Form
        // --------------------------------------------------------

        _formKey.currentState?.reset();

        // --------------------------------------------------------
        // Stop Loading
        // --------------------------------------------------------

        setState(() {
          _isLoading = false;
        });

        // --------------------------------------------------------
        // Callback
        // --------------------------------------------------------

        widget.onPasswordChanged?.call();

        // --------------------------------------------------------
        // Success Message
        // --------------------------------------------------------

        _showSnackBar(
          message: result.message ?? 'Password changed successfully.',
          isSuccess: true,
        );

        return;
      }

      // ----------------------------------------------------------
      // API Returned success = false
      // ----------------------------------------------------------

      setState(() {
        _isLoading = false;
      });

      _showSnackBar(
        message: result.message ?? 'Unable to change password.',
        isSuccess: false,
      );
    } on ApiException catch (error) {
      // ----------------------------------------------------------
      // API Exception
      // ----------------------------------------------------------

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSnackBar(message: error.message, isSuccess: false);
    } catch (_) {
      // ----------------------------------------------------------
      // Unexpected Error
      // ----------------------------------------------------------

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSnackBar(
        message: 'Something went wrong. Please try again.',
        isSuccess: false,
      );
    }
  }

  // ============================================================
  // SnackBar
  // ============================================================

  void _showSnackBar({required String message, required bool isSuccess}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          backgroundColor: isSuccess ? AppColors.successDark : AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(
                isSuccess
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                color: AppColors.white,
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 56,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ChangePasswordHeader(),

                    const SizedBox(height: 32),

                    ChangePasswordForm(
                      currentPasswordController: _currentPasswordController,
                      newPasswordController: _newPasswordController,
                      confirmPasswordController: _confirmPasswordController,
                      formKey: _formKey,
                      onNewPasswordChanged: (_) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 30),

                    CustomButton(
                      text: 'Change Password',
                      onPressed: _isLoading ? null : _handleChangePassword,
                      isLoading: _isLoading,
                      width: double.infinity,
                      height: 54,
                      borderRadius: 12,
                      icon: Icons.lock_reset_rounded,
                      iconPosition: CustomButtonIconPosition.trailing,
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
