import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketPriorityBadge extends StatelessWidget {
  const TicketPriorityBadge({super.key, required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final config = _priorityConfig(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 13, color: config.foregroundColor),
          const SizedBox(width: 5),
          Text(
            _formatPriority(priority),
            style: AppTextStyles.statusBadge.copyWith(
              color: config.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  _PriorityConfig _priorityConfig(String value) {
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

  String _formatPriority(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Unknown';
    }

    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
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
