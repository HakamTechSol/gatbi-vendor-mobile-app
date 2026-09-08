import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/analytics_stat_model.dart';

class AnalyticsStatCard extends StatelessWidget {
  const AnalyticsStatCard({super.key, required this.stat});

  final AnalyticsStatModel stat;

  @override
  Widget build(BuildContext context) {
    final iconColor = stat.iconColor ?? AppColors.primary;
    final iconBackground = stat.iconBackgroundColor ?? AppColors.primaryLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────────────────────────────────────
          // ICON
          // ─────────────────────────────────────────────────────────────
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stat.icon ?? Icons.analytics_outlined,
              size: 21,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 10),

          // ─────────────────────────────────────────────────────────────
          // TITLE
          // ─────────────────────────────────────────────────────────────
          Text(
            stat.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.metricLabel,
          ),

          const SizedBox(height: 4),

          // ─────────────────────────────────────────────────────────────
          // VALUE
          // ─────────────────────────────────────────────────────────────
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.metricValue,
          ),

          // ─────────────────────────────────────────────────────────────
          // SUBTITLE
          // ─────────────────────────────────────────────────────────────
          if (stat.subtitle != null && stat.subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              stat.subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionMedium,
            ),
          ],
        ],
      ),
    );
  }
}
