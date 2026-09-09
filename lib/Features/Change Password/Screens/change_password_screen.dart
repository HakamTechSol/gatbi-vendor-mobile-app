import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Reuse Widgets/change_password_form.dart';
import '../Reuse Widgets/change_password_header.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, this.onBack, this.onPasswordChanged});

  /// Called when the user taps the back button.
  final VoidCallback? onBack;

  /// UI-only callback for now.
  ///
  /// Later this can be connected to the API/state layer.
  final VoidCallback? onPasswordChanged;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // ------------------------------------------------------------
    // UI ONLY
    // ------------------------------------------------------------
    // API / Riverpod / Repository will be connected later.
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    widget.onPasswordChanged?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: AppColors.successDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.white,
              size: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Password changed successfully.',
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

  void _handleBack() {
    FocusScope.of(context).unfocus();

    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
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
                      onPressed: _handleChangePassword,
                      isLoading: _isLoading,
                      width: double.infinity,
                      height: 54,
                      borderRadius: 12,
                      icon: Icons.lock_reset_rounded,
                      iconPosition: CustomButtonIconPosition.trailing,
                    ),

                    const SizedBox(height: 14),

                    _buildCancelButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ============================================================
  // Cancel Button
  // ============================================================

  Widget _buildCancelButton() {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: _isLoading ? null : _handleBack,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Cancel',
          style: AppTextStyles.buttonText.copyWith(
            color: _isLoading ? AppColors.textMuted : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
