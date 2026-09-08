import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketDetailStatus extends StatelessWidget {
  const TicketDetailStatus({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: config.foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              _format(status),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.statusBadge.copyWith(
                color: config.foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getConfig(String value) {
    switch (value.trim().toLowerCase()) {
      case 'open':
        return const _StatusConfig(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primary,
        );

      case 'pending':
        return const _StatusConfig(
          backgroundColor: Color(0xFFFFF4D9),
          foregroundColor: AppColors.warning,
        );

      case 'processing':
        return const _StatusConfig(
          backgroundColor: Color(0xFFE8F1FF),
          foregroundColor: AppColors.info,
        );

      case 'resolved':
      case 'completed':
        return const _StatusConfig(
          backgroundColor: Color(0xFFE4F8EF),
          foregroundColor: AppColors.success,
        );

      case 'closed':
        return const _StatusConfig(
          backgroundColor: Color(0xFFF0F1F5),
          foregroundColor: AppColors.textSecondary,
        );

      case 'cancelled':
        return const _StatusConfig(
          backgroundColor: Color(0xFFFFE9E9),
          foregroundColor: AppColors.error,
        );

      default:
        return const _StatusConfig(
          backgroundColor: AppColors.chipBackground,
          foregroundColor: AppColors.textSecondary,
        );
    }
  }

  String _format(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return 'Unknown';
    }

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
}
