import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/payout_detail_model.dart';

class PayoutDetailHeader extends StatelessWidget {
  const PayoutDetailHeader({super.key, required this.payout, this.onBack});

  final PayoutDetailDataModel payout;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final payoutNumber = payout.payoutNumber?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(context),
          const SizedBox(width: 12),
          Expanded(child: _buildTitleSection(payoutNumber)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Back Button
  // ---------------------------------------------------------------------------

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onBack ?? () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Title Section
  // ---------------------------------------------------------------------------

  Widget _buildTitleSection(String payoutNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payout Details',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        if (payoutNumber.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            payoutNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
