import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({
    super.key,
    required this.address,
    this.title = 'Shipping Address',
  });

  final Map<String, dynamic>? address;
  final String title;

  @override
  Widget build(BuildContext context) {
    final lines = _buildAddressLines();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppColors.iconPrimary,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (lines.isEmpty)
            Text(
              'No shipping address available',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.home_outlined,
                  size: 19,
                  color: AppColors.iconSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lines.join('\n'),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<String> _buildAddressLines() {
    if (address == null || address!.isEmpty) {
      return [];
    }

    final keys = [
      'name',
      'address',
      'address_line_1',
      'address_line_2',
      'street',
      'area',
      'city',
      'state',
      'country',
      'postal_code',
      'zip_code',
    ];

    final lines = <String>[];

    for (final key in keys) {
      final value = address![key];

      if (value != null && value.toString().trim().isNotEmpty) {
        final text = value.toString().trim();

        if (!lines.contains(text)) {
          lines.add(text);
        }
      }
    }

    return lines;
  }
}
