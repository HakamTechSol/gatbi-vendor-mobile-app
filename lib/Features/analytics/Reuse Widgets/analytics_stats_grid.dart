import 'package:flutter/material.dart';

import 'analytics_stat_card.dart';

class AnalyticsStatsGrid extends StatelessWidget {
  const AnalyticsStatsGrid({super.key, required this.stats});

  final List<AnalyticsStatData> stats;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 165,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];

        return AnalyticsStatCard(
          title: stat.title,
          value: stat.value,
          subtitle: stat.subtitle,
          icon: stat.icon,
          iconColor: stat.iconColor,
          iconBackgroundColor: stat.iconBackgroundColor,
        );
      },
    );
  }
}

// ============================================================
// Analytics Stat Data
// ============================================================

class AnalyticsStatData {
  const AnalyticsStatData({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon = Icons.analytics_outlined,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
}
