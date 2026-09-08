import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import 'variant_value_chip.dart';

class VariantAttributeCard extends StatelessWidget {
  const VariantAttributeCard({
    super.key,
    required this.name,
    required this.values,
    required this.onDelete,
    required this.onAddValue,
    required this.onDeleteValue,
    this.onNameChanged,
    this.enabled = true,
  });

  final String name;
  final List<String> values;

  final VoidCallback onDelete;
  final VoidCallback onAddValue;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<String> onDeleteValue;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: 19,
                  color: AppColors.inputIcon,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      values.isEmpty
                          ? 'No values added'
                          : '${values.length} value${values.length == 1 ? '' : 's'}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: enabled ? onDelete : null,
                tooltip: 'Remove attribute',
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: enabled ? AppColors.error : AppColors.iconMuted,
                  size: 21,
                ),
              ),
            ],
          ),

          if (values.isNotEmpty) ...[
            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: values.map((value) {
                return VariantValueChip(
                  label: value,
                  enabled: enabled,
                  onDeleted: () => onDeleteValue(value),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 14),

          OutlinedButton.icon(
            onPressed: enabled ? onAddValue : null,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Value'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
