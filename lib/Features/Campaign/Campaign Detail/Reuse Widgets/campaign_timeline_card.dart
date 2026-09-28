import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/campaign_detail_model.dart';

class CampaignTimelineCard extends StatelessWidget {
  const CampaignTimelineCard({super.key, required this.campaign});

  final CampaignDetailData campaign;

  @override
  Widget build(BuildContext context) {
    final events = _buildEvents();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          if (events.isEmpty)
            _buildEmptyState()
          else
            ...List.generate(events.length, (index) {
              final event = events[index];

              return _TimelineItem(
                event: event,
                isLast: index == events.length - 1,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.purpleLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.timeline_rounded,
            size: 21,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Timeline',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Campaign activity history',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_outlined,
            size: 30,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 8),
          Text(
            'No timeline activity',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<_TimelineEvent> _buildEvents() {
    final events = <_TimelineEvent>[];

    _addEvent(
      events,
      title: 'Created',
      value: campaign.createdAt,
      icon: Icons.add_circle_outline_rounded,
      color: AppColors.info,
    );

    _addEvent(
      events,
      title: 'Last Updated',
      value: campaign.updatedAt,
      icon: Icons.update_rounded,
      color: AppColors.primary,
    );

    _addEvent(
      events,
      title: 'Approved',
      value: campaign.approvedAt,
      icon: Icons.verified_outlined,
      color: AppColors.success,
    );

    _addEvent(
      events,
      title: 'Activated',
      value: campaign.activatedAt,
      icon: Icons.play_circle_outline_rounded,
      color: AppColors.purple,
    );

    return events;
  }

  void _addEvent(
    List<_TimelineEvent> events, {
    required String title,
    required String? value,
    required IconData icon,
    required Color color,
  }) {
    if (value == null || value.trim().isEmpty) {
      return;
    }

    events.add(
      _TimelineEvent(
        title: title,
        dateTime: _formatDateTime(value),
        icon: icon,
        color: color,
      ),
    );
  }

  String _formatDateTime(String value) {
    final parts = value.trim().split(' ');

    if (parts.length < 2) {
      return value;
    }

    final date = parts[0];
    final time = parts[1];

    final dateParts = date.split('-');

    if (dateParts.length != 3) {
      return value;
    }

    final year = dateParts[0];
    final month = int.tryParse(dateParts[1]);
    final day = int.tryParse(dateParts[2]);

    if (month == null || day == null) {
      return value;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      return value;
    }

    return '${months[month - 1]} $day, $year • $time';
  }
}

class _TimelineEvent {
  const _TimelineEvent({
    required this.title,
    required this.dateTime,
    required this.icon,
    required this.color,
  });

  final String title;
  final String dateTime;
  final IconData icon;
  final Color color;
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.event, required this.isLast});

  final _TimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: event.color.withOpacity(0.10),
                    shape: BoxShape.circle,
                    border: Border.all(color: event.color.withOpacity(0.18)),
                  ),
                  child: Icon(event.icon, size: 17, color: event.color),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.dateTime,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
