import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewVendorReply extends StatelessWidget {
  const ReviewVendorReply({super.key, required this.reply, this.repliedAt});

  // ===========================================================================
  // Fields
  // ===========================================================================

  final String? reply;
  final String? repliedAt;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final normalizedReply = reply?.trim() ?? '';

    if (normalizedReply.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------------
          // Header
          // -------------------------------------------------------------------
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.reply_rounded,
                  size: 17,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Your Reply',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.successDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // -------------------------------------------------------------------
          // Reply Text
          // -------------------------------------------------------------------
          Text(
            normalizedReply,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),

          // -------------------------------------------------------------------
          // Replied At
          // -------------------------------------------------------------------
          if (_hasRepliedAt) ...[const SizedBox(height: 11), _buildRepliedAt()],
        ],
      ),
    );
  }

  // ===========================================================================
  // Replied At
  // ===========================================================================

  Widget _buildRepliedAt() {
    final formattedDate = _formatDate(repliedAt!);

    return Row(
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 14,
          color: AppColors.successDark,
        ),
        const SizedBox(width: 6),
        Text(
          'Replied: $formattedDate',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.successDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  bool get _hasRepliedAt {
    return repliedAt != null && repliedAt!.trim().isNotEmpty;
  }

  String _formatDate(String value) {
    try {
      final normalized = value.trim();

      if (normalized.isEmpty) {
        return value;
      }

      final parsed = DateTime.tryParse(normalized.replaceFirst(' ', 'T'));

      if (parsed == null) {
        return value;
      }

      final day = parsed.day.toString().padLeft(2, '0');
      final month = parsed.month.toString().padLeft(2, '0');
      final year = parsed.year.toString();

      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');

      return '$day/$month/$year • $hour:$minute';
    } catch (_) {
      return value;
    }
  }
}
