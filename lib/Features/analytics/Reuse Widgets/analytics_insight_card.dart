import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Core/Custom Widgets/custom_button.dart';
import '../Models/analytics_insight_model.dart';

class AnalyticsInsightCard extends StatelessWidget {
  const AnalyticsInsightCard({
    super.key,
    required this.insight,
    this.onButtonPressed,
  });

  final AnalyticsInsightModel insight;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final colors = _InsightColors.fromType(insight.type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(colors),
          const SizedBox(width: 12),
          Expanded(child: _buildContent(colors)),
        ],
      ),
    );
  }

  Widget _buildIcon(_InsightColors colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colors.iconBackground,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        insight.icon ?? colors.defaultIcon,
        size: 21,
        color: colors.iconColor,
      ),
    );
  }

  Widget _buildContent(_InsightColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          insight.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(color: colors.titleColor),
        ),
        const SizedBox(height: 5),
        Text(
          insight.message,
          style: AppTextStyles.bodySmall.copyWith(color: colors.messageColor),
        ),
        if (insight.buttonText != null &&
            insight.buttonText!.trim().isNotEmpty &&
            onButtonPressed != null) ...[
          const SizedBox(height: 12),
          CustomButton(
            text: insight.buttonText!,
            onPressed: onButtonPressed,
            type: CustomButtonType.outlined,
            height: 38,
            width: null,
            borderRadius: 9,
            icon: Icons.arrow_forward_rounded,
            iconPosition: CustomButtonIconPosition.trailing,
          ),
        ],
      ],
    );
  }
}

class _InsightColors {
  const _InsightColors({
    required this.background,
    required this.border,
    required this.iconBackground,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
    required this.defaultIcon,
  });

  final Color background;
  final Color border;
  final Color iconBackground;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;
  final IconData defaultIcon;

  factory _InsightColors.fromType(AnalyticsInsightType type) {
    switch (type) {
      case AnalyticsInsightType.success:
        return const _InsightColors(
          background: AppColors.successLight,
          border: AppColors.successBorder,
          iconBackground: AppColors.success,
          iconColor: AppColors.iconOnPrimary,
          titleColor: AppColors.successDark,
          messageColor: AppColors.textSecondary,
          defaultIcon: Icons.check_circle_outline_rounded,
        );

      case AnalyticsInsightType.warning:
        return const _InsightColors(
          background: AppColors.warningLight,
          border: AppColors.warningBorder,
          iconBackground: AppColors.warning,
          iconColor: AppColors.iconOnPrimary,
          titleColor: AppColors.warningDark,
          messageColor: AppColors.textSecondary,
          defaultIcon: Icons.warning_amber_rounded,
        );

      case AnalyticsInsightType.error:
        return const _InsightColors(
          background: AppColors.errorLight,
          border: AppColors.errorBorder,
          iconBackground: AppColors.error,
          iconColor: AppColors.iconOnPrimary,
          titleColor: AppColors.errorDark,
          messageColor: AppColors.textSecondary,
          defaultIcon: Icons.error_outline_rounded,
        );

      case AnalyticsInsightType.info:
        return const _InsightColors(
          background: AppColors.infoLight,
          border: AppColors.infoBorder,
          iconBackground: AppColors.info,
          iconColor: AppColors.iconOnPrimary,
          titleColor: AppColors.infoDark,
          messageColor: AppColors.textSecondary,
          defaultIcon: Icons.info_outline_rounded,
        );
    }
  }
}
