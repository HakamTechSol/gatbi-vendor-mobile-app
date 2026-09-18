import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_detail_model.dart';
import '../Models/order_payment_proof_model.dart';

class PaymentInfoCard extends StatelessWidget {
  const PaymentInfoCard({
    super.key,
    required this.order,
    this.paymentProof,
    this.onViewProof,
  });

  final VendorOrderDetailModel order;
  final VendorOrderPaymentProofModel? paymentProof;
  final VoidCallback? onViewProof;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),

            const SizedBox(height: 16),

            // Amount + Status
            _SummarySection(
              amount:
                  '${order.currencySymbol ?? order.currency ?? 'AED'} '
                  '${_formatAmount(order.total)}',
              status: _statusLabel(order.paymentStatus),
              statusColor: _statusColor(order.paymentStatus),
            ),

            const SizedBox(height: 14),

            // Payment method
            if (_hasValue(order.paymentMethod))
              _InfoRow(
                icon: Icons.credit_card_outlined,
                label: 'Payment Method',
                value: _statusLabel(order.paymentMethod),
              ),

            // Transaction reference
            if (_hasValue(paymentProof?.transactionReference)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.tag_outlined,
                label: 'Transaction Reference',
                value: paymentProof!.transactionReference!.trim(),
              ),
            ],

            // Payment date
            if (_hasValue(paymentProof?.paymentDate)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Payment Date',
                value: paymentProof!.paymentDate!.trim(),
              ),
            ],

            // Bank
            if (_hasValue(paymentProof?.bankName)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.account_balance_outlined,
                label: 'Bank',
                value: paymentProof!.bankName!.trim(),
              ),
            ],

            // Account holder
            if (_hasValue(paymentProof?.accountHolderName)) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Account Holder',
                value: paymentProof!.accountHolderName!.trim(),
              ),
            ],

            // Notes
            if (_hasValue(paymentProof?.notes)) ...[
              const SizedBox(height: 14),
              _NotesSection(notes: paymentProof!.notes!.trim()),
            ],
          ],
        ),
      ),
    );
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  String _formatAmount(num? amount) {
    if (amount == null) {
      return '-';
    }

    return amount.toStringAsFixed(2);
  }

  String _statusLabel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'N/A';
    }

    return value
        .trim()
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
        )
        .join(' ');
  }

  Color _statusColor(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'paid':
        return AppColors.success;

      case 'failed':
        return AppColors.error;

      case 'verification_required':
      case 'pending':
        return AppColors.warning;

      case 'refunded':
        return AppColors.warning;

      default:
        return AppColors.textSecondary;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.payments_outlined,
            size: 21,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Information',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Transaction and payment details',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  final String amount;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Amount
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextStyles.orderMeta.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Status - always sticks to right
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: statusColor.withValues(alpha: 0.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),

          const SizedBox(width: 10),

          // Label
          Expanded(
            flex: 5,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.orderMeta.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Right value
          Expanded(
            flex: 6,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.notes_outlined,
              size: 17,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Notes',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
