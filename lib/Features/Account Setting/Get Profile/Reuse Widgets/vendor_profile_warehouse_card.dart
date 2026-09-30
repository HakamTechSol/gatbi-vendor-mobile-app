import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileWarehouseCard extends StatelessWidget {
  const VendorProfileWarehouseCard({super.key, this.address});

  final String? address;

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null && address!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // HEADER
          // ==========================================================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 21,
                  color: AppColors.info,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Warehouse Address', style: AppTextStyles.titleMedium),

                    const SizedBox(height: 2),

                    Text(
                      'Your registered warehouse location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.settingsSubtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==========================================================
          // ADDRESS CONTAINER
          // ==========================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------------------------------------------------
                // LOCATION ICON
                // ----------------------------------------------------
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.place_outlined,
                    size: 18,
                    color: AppColors.info,
                  ),
                ),

                const SizedBox(width: 12),

                // ----------------------------------------------------
                // ADDRESS
                // ----------------------------------------------------
                Expanded(
                  child: Text(
                    hasAddress
                        ? address!.trim()
                        : 'No warehouse address available.',
                    style: hasAddress
                        ? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.55,
                            fontWeight: FontWeight.w500,
                          )
                        : AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
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
