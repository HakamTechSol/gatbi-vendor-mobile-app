import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_detail_model.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.order});

  final OrderDetailModel order;

  @override
  Widget build(BuildContext context) {
    return _SummaryCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.receipt_long_outlined,
            title: 'Order Summary',
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Order Date',
                  value: _formatDate(order.createdAt),
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryItem(
                  label: 'Items',
                  value: '${order.itemCount}',
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _AmountRow(
            label: 'Subtotal',
            amount: order.subtotal,
            currency: order.currency,
          ),

          if (order.discountAmount != null) ...[
            const SizedBox(height: 9),
            _AmountRow(
              label: 'Discount',
              amount: order.discountAmount,
              currency: order.currency,
              isDiscount: true,
            ),
          ],

          if (order.shippingAmount != null) ...[
            const SizedBox(height: 9),
            _AmountRow(
              label: 'Shipping',
              amount: order.shippingAmount,
              currency: order.currency,
            ),
          ],

          if (order.taxAmount != null) ...[
            const SizedBox(height: 9),
            _AmountRow(
              label: 'Tax',
              amount: order.taxAmount,
              currency: order.currency,
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.divider),
          ),

          Row(
            children: [
              Text(
                'Total',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${order.currency} ${order.totalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.orderAmount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _SummaryCardContainer extends StatelessWidget {
  const _SummaryCardContainer({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.iconPrimary),
        const SizedBox(width: 9),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.iconSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.orderMeta),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
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

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    required this.currency,
    this.isDiscount = false,
  });

  final String label;
  final double? amount;
  final String currency;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    final value = amount == null
        ? '-'
        : '$currency ${amount!.toStringAsFixed(2)}';

    return Row(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
