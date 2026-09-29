import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';

class EventDateCard extends StatelessWidget {
  const EventDateCard({super.key, required this.event});

  final EventDetailItemModel event;

  @override
  Widget build(BuildContext context) {
    return _EventDateCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildDateContent(),
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
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 21,
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Dates',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Event availability period',
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

  Widget _buildDateContent() {
    final startDate = _parseDate(event.startDate);
    final endDate = _parseDate(event.endDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 500;

        if (isCompact) {
          return Column(
            children: [
              _DateTile(
                icon: Icons.play_circle_outline_rounded,
                label: 'Start Date',
                date: startDate,
                color: AppColors.primary,
                backgroundColor: AppColors.primarySurface,
              ),
              const SizedBox(height: 10),
              _buildArrow(),
              const SizedBox(height: 10),
              _DateTile(
                icon: Icons.stop_circle_outlined,
                label: 'End Date',
                date: endDate,
                color: AppColors.purple,
                backgroundColor: AppColors.purpleLight,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _DateTile(
                icon: Icons.play_circle_outline_rounded,
                label: 'Start Date',
                date: startDate,
                color: AppColors.primary,
                backgroundColor: AppColors.primarySurface,
              ),
            ),
            const SizedBox(width: 10),
            _buildArrow(),
            const SizedBox(width: 10),
            Expanded(
              child: _DateTile(
                icon: Icons.stop_circle_outlined,
                label: 'End Date',
                date: endDate,
                color: AppColors.purple,
                backgroundColor: AppColors.purpleLight,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildArrow() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: const Icon(
        Icons.arrow_forward_rounded,
        size: 16,
        color: AppColors.textTertiary,
      ),
    );
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.trim());
  }
}

// ============================================================
// DATE TILE
// ============================================================

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.icon,
    required this.label,
    required this.date,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final DateTime? date;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatDate(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate() {
    final value = date;

    if (value == null) {
      return 'Not available';
    }

    return '${_monthName(value.month)} '
        '${value.day}, '
        '${value.year}';
  }

  String _monthName(int month) {
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
      return '';
    }

    return months[month - 1];
  }
}

// ============================================================
// CARD CONTAINER
// ============================================================

class _EventDateCardContainer extends StatelessWidget {
  const _EventDateCardContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}
