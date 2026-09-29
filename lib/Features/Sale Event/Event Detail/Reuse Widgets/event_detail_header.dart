import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';
import 'event_status_badge.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader({super.key, required this.event, this.onBack});

  final EventDetailItemModel event;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBackButton(),
              const SizedBox(width: 12),
              Expanded(child: _buildTitleSection()),
              const SizedBox(width: 12),
              EventStatusBadge(status: event.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: AppColors.primarySurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onBack,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 21,
            color: AppColors.iconPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    final name = event.name?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name?.isNotEmpty == true ? name! : 'Event Details',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.event_outlined,
              size: 14,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                event.slug?.trim().isNotEmpty == true
                    ? event.slug!.trim()
                    : 'Event',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
