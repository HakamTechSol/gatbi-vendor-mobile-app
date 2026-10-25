import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReadyForPickupCard extends StatelessWidget {
  const ReadyForPickupCard({
    super.key,
    required this.providerName,
    required this.canRequestPickup,
    this.blockReason,
    this.isRetryMode = false,
    required this.isLoading,
    required this.onRequestPickup,
    this.onOpenSettings,
  });

  final String? providerName;
  final bool canRequestPickup;
  final String? blockReason;
  final bool isRetryMode;
  final bool isLoading;
  final VoidCallback onRequestPickup;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final provider = (providerName ?? '').trim().isNotEmpty
        ? providerName!.trim()
        : 'Courier';

    final emx = provider.toLowerCase().contains('emx');

    final buttonColor = isRetryMode ? AppColors.warning : AppColors.primary;

    final title = isRetryMode ? 'Retry Courier Booking' : 'Ready for Pickup';

    final subtitle = isRetryMode
        ? 'Last booking attempt failed — tap below to retry.'
        : '$provider will collect this parcel from your warehouse. '
              'Parcel should be packed & ready before pickup.';

    final buttonLabel = isRetryMode ? 'Retry Pickup' : 'Ready for Pickup';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: buttonColor.withValues(alpha: 0.30)),
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
          // HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: buttonColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isRetryMode
                      ? Icons.refresh_rounded
                      : emx
                      ? Icons.local_post_office_rounded
                      : Icons.sports_motorsports_rounded,
                  size: 22,
                  color: buttonColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    if (emx && !isRetryMode)
                      Text(
                        provider,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // SUBTITLE
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),

          // BLOCK REASON
          if (!canRequestPickup && !isRetryMode) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.backgroundSecondary),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      (blockReason ?? '').trim().isNotEmpty
                          ? blockReason!.trim()
                          : 'Pickup is currently not available for this order.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.navy,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (onOpenSettings != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onOpenSettings,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.settings_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Open Settings',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          // CUSTOM BUTTON
          if (canRequestPickup || isRetryMode) ...[
            const SizedBox(height: 14),

            CustomButton(
              text: buttonLabel,
              onPressed: onRequestPickup,
              type: CustomButtonType.primary,
              isLoading: isLoading,
              isEnabled: !isLoading,
              width: double.infinity,
              height: 52,
              borderRadius: 11,
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              gradient: LinearGradient(colors: [buttonColor, buttonColor]),
              icon: isRetryMode
                  ? Icons.refresh_rounded
                  : Icons.inventory_2_rounded,
              iconPosition: CustomButtonIconPosition.leading,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
