import 'package:flutter/material.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';

class VariantActiveSwitch extends StatelessWidget {
  const VariantActiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: value ? AppColors.successLight : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColors.successBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          Expanded(child: _buildContent()),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeTrackColor: AppColors.success,
            activeThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.borderStrong,
            inactiveThumbColor: AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: value
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: value ? AppColors.success : AppColors.iconSecondary,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variant Active',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value
              ? 'This variant is active and available.'
              : 'This variant will be inactive.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.formHelper.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
