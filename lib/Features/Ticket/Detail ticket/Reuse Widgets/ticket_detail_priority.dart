import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketDetailPriority extends StatelessWidget {
  const TicketDetailPriority({super.key, required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 15, color: config.foregroundColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              _format(priority),
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

  _PriorityConfig _getConfig(String value) {
    switch (value.trim().toLowerCase()) {
      case 'high':
        return const _PriorityConfig(
          backgroundColor: Color(0xFFFFE9E9),
          foregroundColor: AppColors.error,
          icon: Icons.priority_high_rounded,
        );

      case 'medium':
        return const _PriorityConfig(
          backgroundColor: Color(0xFFFFF4D9),
          foregroundColor: AppColors.warning,
          icon: Icons.remove_rounded,
        );

      case 'low':
        return const _PriorityConfig(
          backgroundColor: Color(0xFFE4F8EF),
          foregroundColor: AppColors.success,
          icon: Icons.keyboard_arrow_down_rounded,
        );

      default:
        return const _PriorityConfig(
          backgroundColor: AppColors.chipBackground,
          foregroundColor: AppColors.textSecondary,
          icon: Icons.flag_outlined,
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

class _PriorityConfig {
  const _PriorityConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
}
