import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutRequestDialog extends StatefulWidget {
  const PayoutRequestDialog({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  final Future<void> Function({
    required String startDate,
    required String endDate,
  })
  onSubmit;

  final bool isLoading;

  @override
  State<PayoutRequestDialog> createState() => _PayoutRequestDialogState();
}

class _PayoutRequestDialogState extends State<PayoutRequestDialog> {
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  bool _isSubmitting = false;

  DateTime _startDate = _dateOnly(
    DateTime.now().subtract(const Duration(days: 30)),
  );

  DateTime _endDate = _dateOnly(DateTime.now());

  final DateFormat _displayFormat = DateFormat('dd MMM yyyy');

  final DateFormat _apiFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();

    _startDateController = TextEditingController(
      text: _displayFormat.format(_startDate),
    );

    _endDateController = TextEditingController(
      text: _displayFormat.format(_endDate),
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: _buildCard(),
    );
  }

  // ===========================================================================
  // MAIN CARD
  // ===========================================================================

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 30,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), _buildDivider(), _buildContent()],
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 14, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Payout',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select the payout period you want to request.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildCloseButton(),
        ],
      ),
    );
  }

  // ===========================================================================
  // DIVIDER
  // ===========================================================================

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.divider,
    );
  }

  // ===========================================================================
  // CLOSE BUTTON
  // ===========================================================================

  Widget _buildCloseButton() {
    final isLoading = widget.isLoading || _isSubmitting;

    return Material(
      color: AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: isLoading ? null : () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            Icons.close_rounded,
            size: 19,
            color: isLoading ? AppColors.disabledText : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
  // ===========================================================================
  // CONTENT
  // ===========================================================================

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodInfo(),
          const SizedBox(height: 20),
          _buildDateFields(),
          const SizedBox(height: 22),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // ===========================================================================
  // PERIOD INFO
  // ===========================================================================

  Widget _buildPeriodInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.borderPrimary.withOpacity(0.55)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 17,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Choose a date range for the orders you want '
              'to include in this payout request.',
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DATE FIELDS
  // ===========================================================================

  Widget _buildDateFields() {
    final isLoading = widget.isLoading || _isSubmitting;

    return Column(
      children: [
        CustomTextField(
          controller: _startDateController,
          label: 'Start Date',
          hintText: 'Select start date',
          readOnly: true,
          suffixIcon: _buildCalendarIcon(
            onTap: isLoading ? null : _selectStartDate,
          ),
        ),
        const SizedBox(height: 17),
        CustomTextField(
          controller: _endDateController,
          label: 'End Date',
          hintText: 'Select end date',
          readOnly: true,
          suffixIcon: _buildCalendarIcon(
            onTap: isLoading ? null : _selectEndDate,
          ),
        ),
      ],
    );
  }
  // ===========================================================================
  // CALENDAR ICON
  // ===========================================================================

  Widget _buildCalendarIcon({required VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: IconButton(
        onPressed: onTap,
        tooltip: 'Select date',
        splashRadius: 22,
        icon: Icon(
          Icons.calendar_month_rounded,
          size: 21,
          color: onTap == null ? AppColors.disabledText : AppColors.primary,
        ),
      ),
    );
  }

  // ===========================================================================
  // START DATE PICKER
  // ===========================================================================

  Future<void> _selectStartDate() async {
    final today = _dateOnly(DateTime.now());

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate.isAfter(today) ? today : _startDate,
      firstDate: DateTime(2000),
      lastDate: today,
      helpText: 'Select Start Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return _buildDatePickerTheme(context, child);
      },
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    final normalizedDate = _dateOnly(selectedDate);

    // Start date cannot be after end date.
    if (normalizedDate.isAfter(_endDate)) {
      _showInvalidDateMessage('Start date cannot be after the end date.');
      return;
    }

    setState(() {
      _startDate = normalizedDate;

      _startDateController.text = _displayFormat.format(_startDate);
    });
  }

  // ===========================================================================
  // END DATE PICKER
  // ===========================================================================

  Future<void> _selectEndDate() async {
    final today = _dateOnly(DateTime.now());

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate.isAfter(today) ? today : _endDate,
      firstDate: _startDate,
      lastDate: today,
      helpText: 'Select End Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return _buildDatePickerTheme(context, child);
      },
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    final normalizedDate = _dateOnly(selectedDate);

    // Extra safety.
    if (normalizedDate.isAfter(today)) {
      _showInvalidDateMessage('Future dates are not available.');
      return;
    }

    if (normalizedDate.isBefore(_startDate)) {
      _showInvalidDateMessage('End date cannot be before the start date.');
      return;
    }

    setState(() {
      _endDate = normalizedDate;

      _endDateController.text = _displayFormat.format(_endDate);
    });
  }

  // ===========================================================================
  // DATE PICKER THEME
  // ===========================================================================

  Widget _buildDatePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.textPrimary,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: AppColors.primary,
          headerForegroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          todayBorder: const BorderSide(color: AppColors.primary, width: 1.2),
          todayForegroundColor: const WidgetStatePropertyAll(AppColors.primary),
          todayBackgroundColor: const WidgetStatePropertyAll(
            AppColors.primarySurface,
          ),
        ),
      ),
      child: child!,
    );
  }

  // ===========================================================================
  // SUBMIT BUTTON
  // ===========================================================================
  Widget _buildSubmitButton() {
    final isLoading = widget.isLoading || _isSubmitting;

    return CustomButton(
      text: 'Request Payout',
      icon: Icons.send_rounded,
      iconPosition: CustomButtonIconPosition.trailing,
      height: 52,
      borderRadius: 13,
      isLoading: isLoading,
      isEnabled: !isLoading,
      elevation: 4,
      onPressed: isLoading ? null : _submitRequest,
    );
  }
  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  Future<void> _submitRequest() async {
    if (widget.isLoading || _isSubmitting) {
      return;
    }

    final startDate = _apiFormat.format(_startDate);
    final endDate = _apiFormat.format(_endDate);

    if (_startDate.isAfter(_endDate)) {
      _showInvalidDateMessage('Please select a valid date range.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(startDate: startDate, endDate: endDate);
    } catch (error) {
      if (!mounted) {
        return;
      }

      String message = 'Unable to submit payout request.';

      if (error is ApiException) {
        final apiMessage = error.message.trim();

        if (apiMessage.isNotEmpty) {
          message = apiMessage;
        }
      }

      setState(() {
        _isSubmitting = false;
      });

      // Close dialog and return API error message
      // to the parent screen.
      Navigator.of(context).pop(message);
    }
  }
  
  // ===========================================================================
  // INVALID DATE MESSAGE
  // ===========================================================================

  void _showInvalidDateMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ===========================================================================
  // DATE ONLY
  // ===========================================================================

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
