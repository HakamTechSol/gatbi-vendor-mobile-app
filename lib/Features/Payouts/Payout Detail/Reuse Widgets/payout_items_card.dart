import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_model.dart';
import 'payout_item_tile.dart';

class PayoutItemsCard extends StatelessWidget {
  const PayoutItemsCard({super.key, required this.payout});

  final PayoutDetailDataModel payout;

  @override
  Widget build(BuildContext context) {
    final items = payout.items;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
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
          _buildHeader(items.length),
          const SizedBox(height: 16),
          if (items.isEmpty)
            _buildEmptyItems()
          else
            ...List.generate(items.length, (index) {
              final item = items[index];

              return Column(
                children: [
                  PayoutItemTile(item: item, index: index + 1),
                  if (index != items.length - 1) const SizedBox(height: 10),
                ],
              );
            }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(int itemCount) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.receipt_long_outlined,
            size: 19,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Included Orders',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _buildCountBadge(itemCount),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Count Badge
  // ---------------------------------------------------------------------------

  Widget _buildCountBadge(int count) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count.toString(),
        textAlign: TextAlign.center,
        style: AppTextStyles.captionMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty Items
  // ---------------------------------------------------------------------------

  Widget _buildEmptyItems() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 19,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'No orders are included in this payout.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
