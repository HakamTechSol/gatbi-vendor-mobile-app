import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

enum ProductFormNoticeType { info, success, warning, error }

class ProductFormNotice extends StatelessWidget {
  const ProductFormNotice({
    super.key,
    required this.message,
    this.title,
    this.type = ProductFormNoticeType.info,
    this.icon,
    this.onClose,
  });

  final String message;
  final String? title;
  final ProductFormNoticeType type;
  final IconData? icon;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final config = _NoticeConfig.fromType(type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: config.iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon ?? config.icon, size: 19, color: config.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(message, style: AppTextStyles.formHelper),
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: config.iconColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoticeConfig {
  const _NoticeConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData icon;

  factory _NoticeConfig.fromType(ProductFormNoticeType type) {
    switch (type) {
      case ProductFormNoticeType.info:
        return _NoticeConfig(
          backgroundColor: AppColors.inputBackground,
          borderColor: AppColors.border,
          iconBackgroundColor: AppColors.inputIconBackground,
          iconColor: AppColors.primary,
          icon: Icons.info_outline_rounded,
        );

      case ProductFormNoticeType.success:
        return _NoticeConfig(
          backgroundColor: AppColors.success.withValues(alpha: 0.08),
          borderColor: AppColors.success.withValues(alpha: 0.25),
          iconBackgroundColor: AppColors.success.withValues(alpha: 0.12),
          iconColor: AppColors.success,
          icon: Icons.check_circle_outline_rounded,
        );

      case ProductFormNoticeType.warning:
        return _NoticeConfig(
          backgroundColor: AppColors.warning.withValues(alpha: 0.08),
          borderColor: AppColors.warning.withValues(alpha: 0.25),
          iconBackgroundColor: AppColors.warning.withValues(alpha: 0.12),
          iconColor: AppColors.warning,
          icon: Icons.warning_amber_rounded,
        );

      case ProductFormNoticeType.error:
        return _NoticeConfig(
          backgroundColor: AppColors.error.withValues(alpha: 0.08),
          borderColor: AppColors.error.withValues(alpha: 0.25),
          iconBackgroundColor: AppColors.error.withValues(alpha: 0.12),
          iconColor: AppColors.error,
          icon: Icons.error_outline_rounded,
        );
    }
  }
}
