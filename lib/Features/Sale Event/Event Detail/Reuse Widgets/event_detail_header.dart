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
    final eventName = event.name?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ============================================================
          // Back Button
          // ============================================================
          _buildBackButton(context),

          const SizedBox(width: 12),

          // ============================================================
          // Title Section
          // ============================================================
          Expanded(child: _buildTitleSection(eventName)),

          // ============================================================
          // Event Status
          // ============================================================
          const SizedBox(width: 10),

          EventStatusBadge(status: event.status),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Back Button
  // ---------------------------------------------------------------------------

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onBack ?? () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Title Section
  // ---------------------------------------------------------------------------

  Widget _buildTitleSection(String eventName) {
    final slug = event.slug?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventName.isNotEmpty ? eventName : 'Event Details',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        // ============================================================
        // Event Slug
        // ============================================================
        if (slug.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.event_outlined,
                size: 14,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  slug,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
