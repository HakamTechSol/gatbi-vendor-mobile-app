import 'package:flutter/material.dart';

import '../../../../../../Theme/app_colors.dart';
import '../../../../../../Theme/app_text_styles.dart';

import '../Models/get_attributes_model.dart';

class AttributeValueChip extends StatelessWidget {
  const AttributeValueChip({super.key, required this.value, this.onTap});

  final GetAttributeValueModel value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasCode = value.code != null && value.code!.trim().isNotEmpty;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildValueIcon(),
              const SizedBox(width: 7),
              Text(
                _displayValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasCode) ...[
                const SizedBox(width: 6),
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.textMuted,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  value.code!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Icon(
        Icons.sell_outlined,
        size: 13,
        color: AppColors.primary,
      ),
    );
  }

  String get _displayValue {
    final valueText = value.value?.trim();

    if (valueText == null || valueText.isEmpty) {
      return 'Unnamed';
    }

    return valueText;
  }
}
