import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_model.dart';

class PayoutSummaryCard extends StatelessWidget {
  const PayoutSummaryCard({
    super.key,
    required this.payout,
  });

  final PayoutDetailDataModel payout;

  @override
  Widget build(BuildContext context) {
    final amount = payout.amount ?? 0;
    final currencySymbol = _currencySymbol;
    final status = _formatStatus(payout.status);
    final statusColor = _getStatusColor(payout.status);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow.withOpacity(0.45),
            blurRadius: 22,
            spreadRadius: -2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            _buildDecorativeCircle(
              size: 150,
              right: -58,
              top: -68,
            ),
            _buildDecorativeCircle(
              size: 110,
              left: -55,
              bottom: -52,
            ),
            _buildContent(
              amount: amount,
              currencySymbol: currencySymbol,
              status: status,
              statusColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------

  Widget _buildContent({
    required double amount,
    required String currencySymbol,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          _buildTopRow(),
          const SizedBox(height: 20),
          _buildAmount(
            amount,
            currencySymbol,
          ),
          const SizedBox(height: 18),
          _buildDivider(),
          const SizedBox(height: 14),
          _buildStatusBadge(
            status: status,
            color: statusColor,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Row
  // ---------------------------------------------------------------------------

  Widget _buildTopRow() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.white.withOpacity(0.20),
            ),
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            size: 21,
            color: AppColors.white.withOpacity(0.95),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PAYOUT AMOUNT',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white.withOpacity(0.72),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.25,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Available payout',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.white.withOpacity(0.90),
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
  // Amount
  // ---------------------------------------------------------------------------

  Widget _buildAmount(
    double amount,
    String currencySymbol,
  ) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            currencySymbol,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.white.withOpacity(0.82),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatAmount(amount),
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

  // ---------------------------------------------------------------------------
  // Divider
  // ---------------------------------------------------------------------------

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.white.withOpacity(0.14),
    );
  }

  // ---------------------------------------------------------------------------
  // Status Badge
  // ---------------------------------------------------------------------------

  Widget _buildStatusBadge({
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.white.withOpacity(0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.55),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: AppTextStyles.statusBadge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Decorative Background
  // ---------------------------------------------------------------------------

  Widget _buildDecorativeCircle({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.white.withOpacity(0.06),
              width: 18,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Currency
  // ---------------------------------------------------------------------------

  String get _currencySymbol {
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
  // Status Formatter
  // ---------------------------------------------------------------------------

  String _formatStatus(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Unknown';
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
  // Status Color
  // ---------------------------------------------------------------------------

  Color _getStatusColor(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'pending':
        return AppColors.pending;

      case 'processing':
        return AppColors.processing;

      case 'approved':
      case 'paid':
      case 'completed':
        return AppColors.completed;

      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return AppColors.cancelled;

      case 'draft':
        return AppColors.draft;

      default:
        return AppColors.info;
    }
  }
}