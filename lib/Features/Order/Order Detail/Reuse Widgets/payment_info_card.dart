import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_payment_model.dart';

class PaymentInfoCard extends StatelessWidget {
  const PaymentInfoCard({super.key, required this.payment, this.onViewProof});

  final OrderPaymentModel? payment;
  final VoidCallback? onViewProof;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: payment == null
          ? _EmptyPayment()
          : _PaymentContent(payment: payment!, onViewProof: onViewProof),
    );
  }
}

class _PaymentContent extends StatelessWidget {
  const _PaymentContent({required this.payment, this.onViewProof});

  final OrderPaymentModel payment;
  final VoidCallback? onViewProof;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: _PaymentDetail(
                label: 'Amount',
                value:
                    '${payment.currency} ${payment.amount.toStringAsFixed(2)}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PaymentDetail(
                label: 'Status',
                value: payment.status.label,
                valueColor: _statusColor(payment.status),
              ),
            ),
          ],
        ),

        if (payment.method != null && payment.method!.isNotEmpty) ...[
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.credit_card_outlined,
            label: 'Payment Method',
            value: payment.method!,
          ),
        ],

        if (payment.transactionId != null &&
            payment.transactionId!.isNotEmpty) ...[
          const SizedBox(height: 11),
          _InfoRow(
            icon: Icons.tag_outlined,
            label: 'Transaction ID',
            value: payment.transactionId!,
          ),
        ],

        if (payment.paidAt != null) ...[
          const SizedBox(height: 11),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Paid At',
            value: _formatDate(payment.paidAt!),
          ),
        ],

        if (payment.paymentProofUrl != null &&
            payment.paymentProofUrl!.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewProof,
              icon: const Icon(Icons.receipt_long_outlined, size: 18),
              label: const Text('View Payment Proof'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.borderPrimary),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],

        if (payment.notes != null && payment.notes!.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              payment.notes!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _statusColor(OrderPaymentStatus status) {
    switch (status) {
      case OrderPaymentStatus.paid:
        return AppColors.success;
      case OrderPaymentStatus.failed:
        return AppColors.error;
      case OrderPaymentStatus.refunded:
      case OrderPaymentStatus.partiallyRefunded:
        return AppColors.warning;
      case OrderPaymentStatus.pending:
      case OrderPaymentStatus.unknown:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.payments_outlined,
          size: 20,
          color: AppColors.iconPrimary,
        ),
        const SizedBox(width: 9),
        Text(
          'Payment Information',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PaymentDetail extends StatelessWidget {
  const _PaymentDetail({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.orderMeta),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: valueColor ?? AppColors.navy,
              fontWeight: FontWeight.w700,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.iconSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.orderMeta),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyPayment extends StatelessWidget {
  const _EmptyPayment();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        const SizedBox(height: 18),
        Text(
          'No payment information available',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
