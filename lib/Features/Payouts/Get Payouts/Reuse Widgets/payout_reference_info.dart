import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutReferenceInfo extends StatelessWidget {
  const PayoutReferenceInfo({super.key, this.reference, this.payoutNumber});

  final String? reference;
  final String? payoutNumber;

  String _value(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
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
              Icons.receipt_long_rounded,
              size: 19,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payout Reference',
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _value(reference ?? payoutNumber),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          if (reference != null && reference!.trim().isNotEmpty) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.verified_outlined,
              size: 18,
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }
}
