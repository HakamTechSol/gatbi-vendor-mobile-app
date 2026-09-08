import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketDetailCategory extends StatelessWidget {
  const TicketDetailCategory({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(category);

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
              _format(category),
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

  _CategoryConfig _getConfig(String value) {
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

  String _format(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return 'General';
    }

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
