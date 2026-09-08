import 'package:flutter/material.dart';

import '../../../../Theme/app_text_styles.dart';
import '../Models/analytics_insight_model.dart';
import 'analytics_insight_card.dart';

class QuickInsightsSection extends StatelessWidget {
  const QuickInsightsSection({
    super.key,
    required this.insights,
    this.title = 'Quick Insights',
    this.subtitle = 'Important updates from your store performance',
    this.onInsightButtonPressed,
  });

  final List<AnalyticsInsightModel> insights;
  final String title;
  final String subtitle;
  final ValueChanged<AnalyticsInsightModel>? onInsightButtonPressed;

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: insights.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (context, index) {
            final insight = insights[index];

            return AnalyticsInsightCard(
              insight: insight,
              onButtonPressed:
                  insight.buttonText == null || onInsightButtonPressed == null
                  ? null
                  : () => onInsightButtonPressed!(insight),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleLarge),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}
