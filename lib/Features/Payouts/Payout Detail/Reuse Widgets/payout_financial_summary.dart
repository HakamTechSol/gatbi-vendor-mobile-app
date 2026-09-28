import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_model.dart';

class PayoutFinancialSummary extends StatelessWidget {
  const PayoutFinancialSummary({super.key, required this.payout});

  final PayoutDetailDataModel payout;

  @override
  Widget build(BuildContext context) {
    final items = payout.items;

    final orderCount = items.length;
    final orderTotal = _calculateOrderTotal();
    final commission = _calculateCommission();
    final vendorAmount = _calculateVendorAmount();

    final currency = _currency;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildSummaryRow(
            icon: Icons.shopping_bag_outlined,
            label: 'Orders',
            value: orderCount.toString(),
          ),
          _buildDivider(),
          _buildSummaryRow(
            icon: Icons.receipt_long_outlined,
            label: 'Order Total',
            value: _formatAmount(orderTotal, currency),
          ),
          _buildDivider(),
          _buildSummaryRow(
            icon: Icons.percent_rounded,
            label: 'Commission',
            value: _formatAmount(commission, currency),
            valueColor: AppColors.error,
          ),
          _buildDivider(),
          _buildVendorAmountRow(vendorAmount: vendorAmount, currency: currency),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Currency
  // ---------------------------------------------------------------------------

  String get _currency {
    final symbol = payout.currencySymbol?.trim() ?? '';

    if (symbol.isNotEmpty) {
      return symbol;
    }

    final currency = payout.currency?.trim() ?? '';

    if (currency.isNotEmpty) {
      return currency;
    }

    return 'AED';
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            size: 19,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Financial Summary',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Summary Row
  // ---------------------------------------------------------------------------

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Vendor Amount Row
  // ---------------------------------------------------------------------------

  Widget _buildVendorAmountRow({
    required double vendorAmount,
    required String currency,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 19,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'Vendor Amount',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              _formatAmount(vendorAmount, currency),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Divider
  // ---------------------------------------------------------------------------

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, thickness: 1, color: AppColors.divider),
    );
  }

  // ---------------------------------------------------------------------------
  // Financial Calculations
  // ---------------------------------------------------------------------------

  double _calculateOrderTotal() {
    return payout.items.fold<double>(
      0,
      (total, item) => total + (item.orderTotal ?? 0),
    );
  }

  double _calculateCommission() {
    return payout.items.fold<double>(
      0,
      (total, item) => total + (item.commissionAmount ?? 0),
    );
  }

  double _calculateVendorAmount() {
    return payout.items.fold<double>(
      0,
      (total, item) => total + (item.vendorAmount ?? 0),
    );
  }

  // ---------------------------------------------------------------------------
  // Amount Formatter
  // ---------------------------------------------------------------------------

  String _formatAmount(double amount, String currency) {
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}
