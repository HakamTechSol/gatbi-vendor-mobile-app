import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';
import 'password_policy_card.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    this.formKey,
    this.onNewPasswordChanged,
  });

  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  final GlobalKey<FormState>? formKey;

  final ValueChanged<String>? onNewPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================================================================
          // CURRENT PASSWORD
          // ================================================================
          CustomTextField(
            controller: currentPasswordController,
            label: 'Current Password',
            hintText: 'Enter your current password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.next,
            validator: _validateCurrentPassword,
          ),

          const SizedBox(height: 20),

          // ================================================================
          // NEW PASSWORD
          // ================================================================
          CustomTextField(
            controller: newPasswordController,
            label: 'New Password',
            hintText: 'Enter your new password',
            prefixIcon: Icons.lock_reset_outlined,
            isPassword: true,
            textInputAction: TextInputAction.next,
            onChanged: onNewPasswordChanged,
            validator: _validateNewPassword,
          ),

          const SizedBox(height: 12),

          // ================================================================
          // PASSWORD POLICY
          // ================================================================
          PasswordPolicyCard(password: newPasswordController.text),

          const SizedBox(height: 20),

          // ================================================================
          // CONFIRM PASSWORD
          // ================================================================
          CustomTextField(
            controller: confirmPasswordController,
            label: 'Confirm New Password',
            hintText: 'Re-enter your new password',
            prefixIcon: Icons.verified_user_outlined,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (value) {
              return _validateConfirmPassword(
                value,
                newPasswordController.text,
              );
            },
          ),

          const SizedBox(height: 10),

          // ================================================================
          // SECURITY NOTE
          // ================================================================
          _SecurityNote(),
        ],
      ),
    );
  }

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your current password';
    }

    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }

    if (value != newPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded, size: 17, color: AppColors.info),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            'After changing your password, use your new password the next time you sign in.',
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}
