import 'package:flutter/material.dart';

import '../Models/analytics_stat_model.dart';
import 'analytics_stat_card.dart';

class AnalyticsStatsGrid extends StatelessWidget {
  const AnalyticsStatsGrid({
    super.key,
    required this.stats,
  });

  final List<AnalyticsStatModel> stats;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards in one row
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 165, // prevents overflow
      ),
      itemBuilder: (context, index) {
        return AnalyticsStatCard(
          stat: stats[index],
        );
      },
    );
  }
}