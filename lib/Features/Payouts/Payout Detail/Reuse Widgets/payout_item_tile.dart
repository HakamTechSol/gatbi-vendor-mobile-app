import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_item_model.dart';

class PayoutItemTile extends StatelessWidget {
  const PayoutItemTile({
    super.key,
    required this.item,
    this.index,
  });

  final PayoutDetailItemModel item;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final orderNumber = _displayValue(item.orderNumber);
    final orderTotal = item.orderTotal ?? 0;
    final commissionRate = item.commissionRate ?? 0;
    final commissionAmount = item.commissionAmount ?? 0;
    final vendorAmount = item.vendorAmount ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderHeader(orderNumber),
          const SizedBox(height: 13),
          _buildFinancialRows(
            orderTotal: orderTotal,
            commissionRate: commissionRate,
            commissionAmount: commissionAmount,
            vendorAmount: vendorAmount,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Order Header
  // ---------------------------------------------------------------------------

  Widget _buildOrderHeader(String orderNumber) {
    return Row(
      children: [
        if (index != null) ...[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              index.toString(),
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ] else ...[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                orderNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Financial Rows
  // ---------------------------------------------------------------------------

  Widget _buildFinancialRows({
    required double orderTotal,
    required double commissionRate,
    required double commissionAmount,
    required double vendorAmount,
  }) {
    return Column(
      children: [
        _buildAmountRow(
          label: 'Order Total',
          value: _formatAmount(orderTotal),
        ),
        const SizedBox(height: 8),
        _buildAmountRow(
          label: 'Commission ($commissionRate%)',
          value: _formatAmount(commissionAmount),
          valueColor: AppColors.error,
        ),
        const SizedBox(height: 8),
        _buildAmountRow(
          label: 'Vendor Amount',
          value: _formatAmount(vendorAmount),
          valueColor: AppColors.success,
          isHighlighted: true,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Amount Row
  // ---------------------------------------------------------------------------

  Widget _buildAmountRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _displayValue(String? value) {
    final text = value?.trim() ?? '';

    return text.isEmpty ? 'Unknown Order' : text;
  }

  String _formatAmount(double amount) {
    return 'AED ${amount.toStringAsFixed(2)}';
  }
}