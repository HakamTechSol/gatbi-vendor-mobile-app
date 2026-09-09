import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PasswordPolicyCard extends StatelessWidget {
  const PasswordPolicyCard({super.key, required this.password});

  final String password;

  bool get _hasMinLength => password.length >= 6;

  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(password);

  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(password);

  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(password);

  bool get _hasSpecialCharacter =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]+=;]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderPrimary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.security_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  'Password requirements',
                  style: AppTextStyles.titleSmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _RequirementItem(
            text: 'At least 6 characters',
            isValid: _hasMinLength,
          ),

          const SizedBox(height: 9),

          _RequirementItem(
            text: 'One uppercase letter',
            isValid: _hasUppercase,
          ),

          const SizedBox(height: 9),

          _RequirementItem(
            text: 'One lowercase letter',
            isValid: _hasLowercase,
          ),

          const SizedBox(height: 9),

          _RequirementItem(text: 'One number', isValid: _hasNumber),

          const SizedBox(height: 9),

          _RequirementItem(
            text: 'One special character',
            isValid: _hasSpecialCharacter,
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({required this.text, required this.isValid});

  final String text;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? AppColors.successLight : AppColors.surface,
            border: Border.all(
              color: isValid ? AppColors.success : AppColors.borderStrong,
              width: 1,
            ),
          ),
          child: Icon(
            isValid ? Icons.check_rounded : Icons.circle_outlined,
            size: isValid ? 13 : 10,
            color: isValid ? AppColors.success : AppColors.textMuted,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: isValid ? AppColors.successDark : AppColors.textSecondary,
              fontWeight: isValid ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
