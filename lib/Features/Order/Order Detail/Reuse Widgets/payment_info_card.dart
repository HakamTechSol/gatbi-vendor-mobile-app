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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _PaymentDetail(
                  label: 'Amount',
                  value:
                      '${order.currencySymbol ?? order.currency ?? 'AED'} '
                      '${_formatAmount(order.total)}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentDetail(
                  label: 'Status',
                  value: _statusLabel(order.paymentStatus),
                  valueColor: _statusColor(order.paymentStatus),
                ),
              ),
            ],
          ),

          if (_hasValue(order.paymentMethod)) ...[
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.credit_card_outlined,
              label: 'Payment Method',
              value: _statusLabel(order.paymentMethod),
            ),
          ],

          if (_hasValue(paymentProof?.transactionReference)) ...[
            const SizedBox(height: 11),
            _InfoRow(
              icon: Icons.tag_outlined,
              label: 'Transaction Reference',
              value: paymentProof!.transactionReference!.trim(),
            ),
          ],

          if (_hasValue(paymentProof?.paymentDate)) ...[
            const SizedBox(height: 11),
            _InfoRow(
              icon: Icons.schedule_outlined,
              label: 'Payment Date',
              value: paymentProof!.paymentDate!.trim(),
            ),
          ],

          if (_hasValue(paymentProof?.bankName)) ...[
            const SizedBox(height: 11),
            _InfoRow(
              icon: Icons.account_balance_outlined,
              label: 'Bank',
              value: paymentProof!.bankName!.trim(),
            ),
          ],

          if (_hasValue(paymentProof?.accountHolderName)) ...[
            const SizedBox(height: 11),
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Account Holder',
              value: paymentProof!.accountHolderName!.trim(),
            ),
          ],

          if (_hasValue(paymentProof?.verificationStatus)) ...[
            const SizedBox(height: 11),
            _InfoRow(
              icon: Icons.verified_outlined,
              label: 'Verification',
              value: _statusLabel(paymentProof!.verificationStatus),
            ),
          ],

          if (_hasValue(paymentProof?.notes)) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                paymentProof!.notes!.trim(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
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
