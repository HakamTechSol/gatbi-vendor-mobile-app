import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_status_history_model.dart';

class OrderTimelineCard extends StatelessWidget {
  const OrderTimelineCard({
    super.key,
    required this.timeline,
  });

  final List<VendorOrderStatusHistoryModel> timeline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(
              alpha: 0.04,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.timeline_rounded,
                size: 20,
                color: AppColors.iconPrimary,
              ),
              const SizedBox(width: 9),
              Text(
                'Order Timeline',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (timeline.isEmpty)
            const _EmptyTimeline()
          else
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: timeline.length,
              itemBuilder: (context, index) {
                return OrderTimelineItem(
                  item: timeline[index],
                  isLast:
                      index == timeline.length - 1,
                );
              },
            ),
        ],
      ),
    );
  }
}

class OrderTimelineItem extends StatelessWidget {
  const OrderTimelineItem({
    super.key,
    required this.item,
    this.isLast = false,
  });

  final VendorOrderStatusHistoryModel item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final status =
        item.status?.trim().toLowerCase() ?? '';

    final statusColor = _statusColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                  child: Icon(
                    _statusIcon(status),
                    size: 16,
                    color: statusColor,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin:
                          const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _statusLabel(status),
                          style:
                              AppTextStyles.bodyMedium
                                  .copyWith(
                            color: AppColors.navy,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(item.createdAt),
                        style:
                            AppTextStyles.orderMeta,
                      ),
                    ],
                  ),

                  if (_hasValue(item.notes)) ...[
                    const SizedBox(height: 5),
                    Text(
                      item.notes!.trim(),
                      style:
                          AppTextStyles.bodySmall.copyWith(
                        color:
                            AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],

                  if (_hasValue(
                    item.updatedByType,
                  )) ...[
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: AppColors.iconMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Updated by ${item.updatedByType!.trim()}',
                            style:
                                AppTextStyles.orderMeta,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasValue(String? value) {
    return value != null &&
        value.trim().isNotEmpty;
  }

  String _statusLabel(String value) {
    if (value.isEmpty) {
      return 'Order Update';
    }

    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                  '${word.substring(1)}',
        )
        .join(' ');
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'shipped':
        return AppColors.purple;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'processing':
        return Icons.autorenew_rounded;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.check_rounded;
      case 'cancelled':
        return Icons.close_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'N/A';
    }

    final date = DateTime.tryParse(
      value.replaceFirst(' ', 'T'),
    );

    if (date == null) {
      return value;
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 26,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.timeline_outlined,
            size: 32,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: 8),
          Text(
            'No timeline updates yet',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}