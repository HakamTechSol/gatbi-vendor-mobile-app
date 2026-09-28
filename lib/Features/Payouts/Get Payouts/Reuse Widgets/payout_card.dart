import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutCard extends StatelessWidget {
  const PayoutCard({
    super.key,
    required this.payoutNumber,
    required this.amount,
    required this.currency,
    required this.currencySymbol,
    required this.status,
    required this.paymentMethod,
    required this.paymentReference,
    required this.periodStart,
    required this.periodEnd,
    required this.notes,
    required this.processedAt,
    required this.paidAt,
    required this.createdAt,
    this.onTap,
  });

  // ============================================================
  // Data
  // ============================================================

  final String? payoutNumber;
  final double? amount;
  final String? currency;
  final String? currencySymbol;
  final String? status;
  final String? paymentMethod;
  final String? paymentReference;
  final String? periodStart;
  final String? periodEnd;
  final String? notes;
  final String? processedAt;
  final String? paidAt;
  final String? createdAt;

  final VoidCallback? onTap;

  // ============================================================
  // Safe Values
  // ============================================================

  String get _payoutNumber {
    final value = payoutNumber?.trim();

    if (value == null || value.isEmpty) {
      return 'Payout Request';
    }

    return value;
  }

  String get _status {
    final value = status?.trim().toLowerCase();

    if (value == null || value.isEmpty) {
      return 'pending';
    }

    return value;
  }

  String get _paymentMethod {
    final value = paymentMethod?.trim();

    if (value == null || value.isEmpty) {
      return 'Not specified';
    }

    return _formatText(value);
  }

  String get _currency {
    final value = currency?.trim();

    if (value == null || value.isEmpty) {
      return 'AED';
    }

    return value;
  }

  String get _currencySymbol {
    final value = currencySymbol?.trim();

    if (value == null || value.isEmpty) {
      return 'د.إ';
    }

    return value;
  }

  double get _amount {
    return amount ?? 0;
  }

  // ============================================================
  // Status Color
  // ============================================================

  Color get _statusColor {
    switch (_status) {
      case 'pending':
        return AppColors.warning;

      case 'processing':
        return AppColors.info;

      case 'paid':
        return AppColors.success;

      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return AppColors.error;

      default:
        return AppColors.primary;
    }
  }

  Color get _statusBackgroundColor {
    switch (_status) {
      case 'pending':
        return AppColors.warningLight;

      case 'processing':
        return AppColors.infoLight;

      case 'paid':
        return AppColors.successLight;

      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return AppColors.errorLight;

      default:
        return AppColors.primaryLight;
    }
  }

  // ============================================================
  // Date
  // ============================================================

  String _formatDate(String? value) {
    final raw = value?.trim();

    if (raw == null || raw.isEmpty) {
      return '—';
    }

    final parsed = DateTime.tryParse(raw);

    if (parsed == null) {
      return raw;
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final year = parsed.year.toString();

    // API date only:
    // 2026-07-25
    if (!raw.contains(':')) {
      return '$day/$month/$year';
    }

    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }

  String _formatText(String value) {
    return value
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((item) => item.isNotEmpty)
        .map(
          (item) =>
              '${item[0].toUpperCase()}${item.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String _formatStatus(String value) {
    return _formatText(value);
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: _statusColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),

                const SizedBox(height: 16),

                _buildAmount(),

                const SizedBox(height: 16),

                _buildPaymentInformation(),
              ],
            ),
          ),
        ),
      ),
    );

    final paddedContent = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: content,
    );

    if (onTap == null) {
      return paddedContent;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: content,
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Payout',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _payoutNumber,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        _buildStatusBadge(),
      ],
    );
  }

  // ============================================================
  // Status Badge
  // ============================================================

  Widget _buildStatusBadge() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 105),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: _statusBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _formatStatus(_status),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.statusBadge.copyWith(color: _statusColor),
        ),
      ),
    );
  }

  // ============================================================
  // Amount
  // ============================================================

  Widget _buildAmount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payout Amount',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_currencySymbol} ${_amount.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Flexible(
            child: Text(
              _currency,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Payment Information
  // ============================================================

  Widget _buildPaymentInformation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 350) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBlock(
                icon: Icons.payment_rounded,
                label: 'Payment Method',
                value: _paymentMethod,
              ),
              const SizedBox(height: 12),
              _buildInfoBlock(
                icon: Icons.calendar_today_rounded,
                label: 'Created',
                value: _formatDate(createdAt),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoBlock(
                icon: Icons.payment_rounded,
                label: 'Payment Method',
                value: _paymentMethod,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildInfoBlock(
                icon: Icons.calendar_today_rounded,
                label: 'Created',
                value: _formatDate(createdAt),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Info Block
  // ============================================================

  Widget _buildInfoBlock({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textTertiary),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
