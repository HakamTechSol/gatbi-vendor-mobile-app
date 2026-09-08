import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketCategoryBadge extends StatelessWidget {
  const TicketCategoryBadge({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    final config = _categoryConfig(category);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 13,
            color: config.foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            _formatCategory(category),
            style: AppTextStyles.statusBadge.copyWith(
              color: config.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  _CategoryConfig _categoryConfig(String value) {
    switch (value.trim().toLowerCase()) {
      case 'payment':
        return const _CategoryConfig(
          backgroundColor: Color(0xFFEAF0FF),
          foregroundColor: AppColors.primary,
          icon: Icons.payments_outlined,
        );

      case 'order':
        return const _CategoryConfig(
          backgroundColor: Color(0xFFE8F1FF),
          foregroundColor: AppColors.info,
          icon: Icons.shopping_bag_outlined,
        );

      case 'product':
        return const _CategoryConfig(
          backgroundColor: Color(0xFFF0E9FF),
          foregroundColor: AppColors.purple,
          icon: Icons.inventory_2_outlined,
        );

      case 'technical':
        return const _CategoryConfig(
          backgroundColor: Color(0xFFFFF4D9),
          foregroundColor: AppColors.warning,
          icon: Icons.build_outlined,
        );

      case 'general':
        return const _CategoryConfig(
          backgroundColor: Color(0xFFF0F1F5),
          foregroundColor: AppColors.textSecondary,
          icon: Icons.help_outline_rounded,
        );

      default:
        return const _CategoryConfig(
          backgroundColor: AppColors.chipBackground,
          foregroundColor: AppColors.textSecondary,
          icon: Icons.label_outline_rounded,
        );
    }
  }

  String _formatCategory(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'General';
    }

    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}

class _CategoryConfig {
  const _CategoryConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
}
