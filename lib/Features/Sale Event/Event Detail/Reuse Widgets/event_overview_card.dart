import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';

class EventOverviewCard extends StatelessWidget {
  const EventOverviewCard({super.key, required this.event});

  final EventDetailItemModel event;

  @override
  Widget build(BuildContext context) {
    return _EventCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 18),
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        _IconContainer(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          backgroundColor: AppColors.primarySurface,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Overview',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Basic event information',
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

  Widget _buildInfoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 500;

        final items = [
          _EventInfoData(
            icon: Icons.tag_outlined,
            label: 'Event ID',
            value: event.id != null ? '#${event.id}' : '—',
          ),
          _EventInfoData(
            icon: Icons.flag_outlined,
            label: 'Status',
            value: _formatValue(event.status),
          ),
          _EventInfoData(
            icon: Icons.percent_rounded,
            label: 'Minimum Discount',
            value: event.minDiscountPercentage != null
                ? '${_formatPercentage(event.minDiscountPercentage!)}%'
                : '—',
          ),
        ];

        if (isCompact) {
          return Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _EventInfoTile(
                  icon: items[i].icon,
                  label: items[i].label,
                  value: items[i].value,
                ),
                if (i != items.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Expanded(
                child: _EventInfoTile(
                  icon: items[i].icon,
                  label: items[i].label,
                  value: items[i].value,
                ),
              ),
              if (i != items.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }

  String _formatValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value
        .trim()
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String _formatPercentage(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }
}

// ============================================================
// EVENT CARD
// ============================================================

class _EventCard extends StatelessWidget {
  const _EventCard({required this.child});

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

// ============================================================
// ICON CONTAINER
// ============================================================

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 21, color: color),
    );
  }
}

// ============================================================
// INFO TILE
// ============================================================

class _EventInfoTile extends StatelessWidget {
  const _EventInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
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
}

class _EventInfoData {
  const _EventInfoData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}
