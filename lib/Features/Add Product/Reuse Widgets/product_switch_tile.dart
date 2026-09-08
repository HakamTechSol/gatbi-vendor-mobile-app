import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ProductSwitchTile extends StatelessWidget {
  const ProductSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.enabled = true,
  });

  final bool value;

  final ValueChanged<bool>? onChanged;

  final String title;

  final String? subtitle;

  final IconData? leadingIcon;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled =
        enabled && onChanged != null;

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 180),
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
      decoration: BoxDecoration(
        color: value
            ? AppColors.primarySurface
            : AppColors.surfaceSoft,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? AppColors.borderPrimary
              : AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: value
                    ? AppColors.primaryLight
                    : AppColors.surfaceMuted,
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Icon(
                leadingIcon,
                size: 19,
                color: value
                    ? AppColors.primary
                    : AppColors.iconSecondary,
              ),
            ),
            const SizedBox(width: 12),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      AppTextStyles.titleSmall
                          .copyWith(
                    color: effectiveEnabled
                        ? AppColors.textPrimary
                        : AppColors.disabledText,
                  ),
                ),

                if (subtitle != null &&
                    subtitle!
                        .trim()
                        .isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style:
                        AppTextStyles.formHelper
                            .copyWith(
                      color: effectiveEnabled
                          ? AppColors.textSecondary
                          : AppColors.disabledText,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          Switch.adaptive(
            value: value,
            onChanged:
                effectiveEnabled
                    ? onChanged
                    : null,
          ),
        ],
      ),
    );
  }
}