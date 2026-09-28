import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_model.dart';

class PayoutInformationCard extends StatelessWidget {
  const PayoutInformationCard({super.key, required this.payout});

  final PayoutDetailDataModel payout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.55),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildInfoRow(
            icon: Icons.payments_rounded,
            label: 'Payment Method',
            value: _formatPaymentMethod(payout.paymentMethod),
            valueColor: AppColors.primary,
            valueBackground: AppColors.primarySurface,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.receipt_long_rounded,
            label: 'Payment Reference',
            value: _displayValue(payout.paymentReference),
            valueColor: AppColors.textPrimary,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Created',
            value: _formatDateTime(payout.createdAt),
            valueColor: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            size: 20,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payout Information',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Payment and transaction details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Information Row
  // ---------------------------------------------------------------------------

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    Color? valueBackground,
  }) {
    final hasBackground = valueBackground != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left icon
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.divider),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),

        const SizedBox(width: 12),

        // Label
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Right aligned value
        SizedBox(
          width: 145,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: hasBackground
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                  : EdgeInsets.zero,
              decoration: hasBackground
                  ? BoxDecoration(
                      color: valueBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.borderPrimary.withOpacity(0.55),
                      ),
                    )
                  : null,
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Divider
  // ---------------------------------------------------------------------------

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          const SizedBox(width: 50),
          Expanded(child: Container(height: 1, color: AppColors.divider)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Display Value
  // ---------------------------------------------------------------------------

  String _displayValue(String? value) {
    final text = value?.trim() ?? '';

    return text.isEmpty ? '—' : text;
  }

  // ---------------------------------------------------------------------------
  // Payment Method
  // ---------------------------------------------------------------------------

  String _formatPaymentMethod(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Not specified';
    }

    return text
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // ---------------------------------------------------------------------------
  // Date Formatter
  // ---------------------------------------------------------------------------

  String _formatDateTime(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '—';
    }

    final normalized = text.replaceFirst(' ', 'T');
    final dateTime = DateTime.tryParse(normalized);

    if (dateTime == null) {
      return text;
    }

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _monthName(dateTime.month);
    final year = dateTime.year;

    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day $month $year, '
        '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }
}
