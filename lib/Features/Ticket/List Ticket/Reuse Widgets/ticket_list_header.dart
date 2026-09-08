import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class TicketListHeader extends StatelessWidget {
  const TicketListHeader({super.key, this.onBack, this.onCreateTicket});

  final VoidCallback? onBack;
  final VoidCallback? onCreateTicket;

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!.call();
      return;
    }

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ─────────────────────────────────────────────────────────
        // BACK BUTTON
        // ─────────────────────────────────────────────────────────
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _handleBack(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ─────────────────────────────────────────────────────────
        // TITLE
        // ─────────────────────────────────────────────────────────
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support Tickets',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Manage and track your support requests',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ─────────────────────────────────────────────────────────
        // CREATE TICKET
        // ─────────────────────────────────────────────────────────
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onCreateTicket,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    size: 19,
                    color: AppColors.white,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    'Create',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
