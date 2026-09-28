import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_model.dart';

class PayoutTimelineCard extends StatelessWidget {
  const PayoutTimelineCard({super.key, required this.payout});

  final PayoutDetailDataModel payout;

  @override
  Widget build(BuildContext context) {
    final status = payout.status?.trim().toLowerCase() ?? '';

    final isProcessing =
        status == 'processing' ||
        status == 'approved' ||
        status == 'paid' ||
        status == 'completed';

    final isPaid = status == 'paid' || status == 'completed';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTimeline(isProcessing: isProcessing, isPaid: isPaid),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.timeline_rounded,
            size: 19,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Payout Timeline',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Timeline
  // ---------------------------------------------------------------------------

  Widget _buildTimeline({required bool isProcessing, required bool isPaid}) {
    return Column(
      children: [
        _buildTimelineItem(
          title: 'Created',
          description: _formatDateTime(
            payout.createdAt,
            fallback: 'Payout request created',
          ),
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          title: 'Processing',
          description: payout.processedAt?.trim().isNotEmpty == true
              ? _formatDateTime(payout.processedAt)
              : isProcessing
              ? 'Processing started'
              : 'Not processed yet',
          isCompleted: isProcessing,
          isLast: false,
        ),
        _buildTimelineItem(
          title: 'Paid',
          description: payout.paidAt?.trim().isNotEmpty == true
              ? _formatDateTime(payout.paidAt)
              : isPaid
              ? 'Payment completed'
              : 'Not paid yet',
          isCompleted: isPaid,
          isLast: true,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Timeline Item
  // ---------------------------------------------------------------------------

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required bool isCompleted,
    required bool isLast,
  }) {
    final activeColor = isCompleted
        ? AppColors.success
        : AppColors.borderStrong;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success
                        : AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                    border: Border.all(color: activeColor, width: 1.5),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_rounded : Icons.circle_outlined,
                    size: 14,
                    color: isCompleted ? AppColors.white : AppColors.textMuted,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: isCompleted
                          ? AppColors.success.withValues(alpha: 0.35)
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isCompleted
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
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

  // ---------------------------------------------------------------------------
  // Date Formatter
  // ---------------------------------------------------------------------------

  String _formatDateTime(String? value, {String fallback = '—'}) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return fallback;
    }

    final normalized = text.replaceFirst(' ', 'T');
    final dateTime = DateTime.tryParse(normalized);

    if (dateTime == null) {
      return text;
    }

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _monthName(dateTime.month);
    final year = dateTime.year;

    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day $month $year, '
        '${hour.toString().padLeft(2, '0')}:$minute $period';
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
