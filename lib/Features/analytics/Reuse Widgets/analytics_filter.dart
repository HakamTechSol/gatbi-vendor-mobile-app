import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class AnalyticsFilter extends StatelessWidget {
  const AnalyticsFilter({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.minDate,
    required this.maxDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.isLoading = false,
  });

  final DateTime? startDate;
  final DateTime? endDate;

  /// Minimum date received from API.
  final DateTime? minDate;

  /// Maximum date received from API.
  final DateTime? maxDate;

  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;

  final bool isLoading;

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    if (isLoading || minDate == null || maxDate == null) {
      return;
    }

    DateTime initialDate = startDate ?? minDate!;

    if (initialDate.isBefore(minDate!)) {
      initialDate = minDate!;
    }

    if (initialDate.isAfter(maxDate!)) {
      initialDate = maxDate!;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate!,
      lastDate: maxDate!,
      helpText: 'Select start date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    // Start date cannot be after currently selected end date.
    if (endDate != null && selectedDate.isAfter(endDate!)) {
      onEndDateChanged(selectedDate);
    }

    onStartDateChanged(selectedDate);
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (isLoading || minDate == null || maxDate == null) {
      return;
    }

    final effectiveFirstDate = startDate ?? minDate!;

    DateTime initialDate = endDate ?? effectiveFirstDate;

    if (initialDate.isBefore(effectiveFirstDate)) {
      initialDate = effectiveFirstDate;
    }

    if (initialDate.isAfter(maxDate!)) {
      initialDate = maxDate!;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: effectiveFirstDate,
      lastDate: maxDate!,
      helpText: 'Select end date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    onEndDateChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              label: 'Start Date',
              value: _formatDate(startDate),
              enabled: !isLoading && minDate != null && maxDate != null,
              onTap: () => _selectStartDate(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DateField(
              label: 'End Date',
              value: _formatDate(endDate),
              enabled: !isLoading && minDate != null && maxDate != null,
              onTap: () => _selectEndDate(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Date Field
// ============================================================

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.captionMedium,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
