import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class SupportTicketPrioritySelector extends StatelessWidget {
  const SupportTicketPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.priorities,
    required this.onChanged,
  });

  final String selectedPriority;
  final List<String> priorities;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: AppTextStyles.formLabel),
        const SizedBox(height: 9),
        Row(
          children: priorities.map((priority) {
            final isSelected = priority == selectedPriority;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: priority == priorities.last ? 0 : 8,
                ),
                child: _PriorityOption(
                  label: priority,
                  isSelected: isSelected,
                  onTap: () => onChanged(priority),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PriorityOption extends StatelessWidget {
  const _PriorityOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _color {
    switch (label.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 46,
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.10) : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 1.3 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.borderStrong,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? color : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
