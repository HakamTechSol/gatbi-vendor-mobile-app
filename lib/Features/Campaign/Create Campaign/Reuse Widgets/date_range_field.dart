import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Utils/date_helper.dart';

class DateRangeField extends StatelessWidget {
  const DateRangeField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartChanged,
    required this.onEndChanged,
    this.startErrorText,
    this.endErrorText,
  });

  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;
  final String? startErrorText;
  final String? endErrorText;

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final today = DateHelper.today;
    // lastDate = end of CURRENT month, taake user current month
    // ka pura calendar dekh sake (past dates disabled rahengi)
    final lastDate = DateHelper.currentMonthLastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: lastDate,
      // Sirf today .. month-end tak selectable
      selectableDayPredicate: (day) => DateHelper.isSelectable(day),
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'SELECT DATE',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.white,
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: AppColors.white,
              todayBorder: const BorderSide(
                color: AppColors.primary,
                width: 1.4,
              ),
              todayForegroundColor: WidgetStateProperty.all(AppColors.primary),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppColors.disabledText;
                }
                if (states.contains(WidgetState.selected)) {
                  return AppColors.white;
                }
                return AppColors.textPrimary;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return Colors.transparent;
              }),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Campaign Duration', style: AppTextStyles.formLabel),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DateTile(
                label: 'Start Date',
                date: startDate,
                icon: Icons.calendar_today_rounded,
                errorText: startErrorText,
                onTap: () => _pickDate(
                  context,
                  initial: startDate,
                  onPicked: onStartChanged,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateTile(
                label: 'End Date',
                date: endDate,
                icon: Icons.event_rounded,
                errorText: endErrorText,
                onTap: () => _pickDate(
                  context,
                  initial: endDate,
                  onPicked: onEndChanged,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Only dates from today up to the end of this month are selectable.',
          style: AppTextStyles.formHelper,
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.date,
    required this.icon,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final DateTime date;
  final IconData icon;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.captionMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateHelper.toDisplayDate(date),
                    style: AppTextStyles.authInput,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(icon, size: 18, color: AppColors.iconPrimary),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(errorText!, style: AppTextStyles.formError),
        ],
      ],
    );
  }
}
