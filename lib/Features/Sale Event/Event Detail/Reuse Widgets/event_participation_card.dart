import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';

class EventParticipationCard extends StatelessWidget {
  const EventParticipationCard({super.key, required this.event});

  final EventDetailItemModel event;

  @override
  Widget build(BuildContext context) {
    final participation = event.myParticipation;

    final bool hasParticipation = _hasParticipation(participation);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: hasParticipation
                      ? AppColors.successLight
                      : AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasParticipation
                      ? Icons.check_circle_outline_rounded
                      : Icons.event_available_outlined,
                  size: 21,
                  color: hasParticipation ? AppColors.success : AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'My Participation',
                  style: AppTextStyles.titleMedium,
                ),
              ),
              _ParticipationBadge(isParticipating: hasParticipation),
            ],
          ),
          const SizedBox(height: 16),
          _ParticipationContent(
            participation: participation,
            isParticipating: hasParticipation,
          ),
        ],
      ),
    );
  }

  bool _hasParticipation(dynamic participation) {
    if (participation == null) {
      return false;
    }

    if (participation is Map) {
      return participation.isNotEmpty;
    }

    if (participation is List) {
      return participation.isNotEmpty;
    }

    if (participation is String) {
      return participation.trim().isNotEmpty;
    }

    return true;
  }
}

class _ParticipationContent extends StatelessWidget {
  const _ParticipationContent({
    required this.participation,
    required this.isParticipating,
  });

  final dynamic participation;
  final bool isParticipating;

  @override
  Widget build(BuildContext context) {
    if (!isParticipating) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.infoLight,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.infoBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: AppColors.info,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'You are not participating in this event yet.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 20,
                color: AppColors.success,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'You are participating in this event.',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.successDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (participation is Map)
            _ParticipationMap(
              data: Map<String, dynamic>.from(participation as Map),
            )
          else
            Text(
              participation.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _ParticipationMap extends StatelessWidget {
  const _ParticipationMap({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries
        .where(
          (entry) =>
              entry.value != null && entry.value.toString().trim().isNotEmpty,
        )
        .toList();

    if (entries.isEmpty) {
      return Text(
        'Participation details are available.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: [
        for (int index = 0; index < entries.length; index++) ...[
          _ParticipationInfoRow(
            label: _formatLabel(entries[index].key),
            value: entries[index].value.toString(),
          ),
          if (index != entries.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  String _formatLabel(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}

class _ParticipationInfoRow extends StatelessWidget {
  const _ParticipationInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticipationBadge extends StatelessWidget {
  const _ParticipationBadge({required this.isParticipating});

  final bool isParticipating;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isParticipating
        ? AppColors.successLight
        : AppColors.surfaceMuted;

    final foregroundColor = isParticipating
        ? AppColors.successDark
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isParticipating ? 'Participating' : 'Not Joined',
        style: AppTextStyles.statusBadge.copyWith(color: foregroundColor),
      ),
    );
  }
}
