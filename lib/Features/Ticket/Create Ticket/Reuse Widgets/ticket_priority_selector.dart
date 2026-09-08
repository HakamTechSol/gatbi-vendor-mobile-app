import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketPrioritySelector extends StatelessWidget {
  const TicketPrioritySelector({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.validator,
  });

  final String? value;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? Function(String?)? validator;

  static const List<String> priorities = ['Low', 'Medium', 'High'];

  Color _getColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high_rounded;
      case 'medium':
        return Icons.remove_rounded;
      case 'low':
        return Icons.keyboard_arrow_down_rounded;
      default:
        return Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Priority', style: AppTextStyles.formLabel),
            const SizedBox(height: 8),
            Row(
              children: priorities.map((priority) {
                final isSelected =
                    value?.toLowerCase() == priority.toLowerCase();

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: priority == priorities.last ? 0 : 8,
                    ),
                    child: _PriorityItem(
                      label: priority,
                      icon: _getIcon(priority),
                      color: _getColor(priority),
                      isSelected: isSelected,
                      enabled: enabled,
                      onTap: () {
                        if (!enabled) return;

                        onChanged?.call(priority);
                        field.didChange(priority);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  field.errorText ?? '',
                  style: AppTextStyles.formError,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PriorityItem extends StatelessWidget {
  const _PriorityItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 52,
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.10)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: enabled ? color : AppColors.disabled),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? color : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
