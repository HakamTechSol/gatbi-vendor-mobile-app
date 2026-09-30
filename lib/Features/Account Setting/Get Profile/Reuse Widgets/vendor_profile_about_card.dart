import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileAboutCard extends StatelessWidget {
  const VendorProfileAboutCard({
    super.key,
    required this.about,
    this.title = 'About Business',
    this.subtitle = 'Business description',
    this.icon = Icons.info_outline_rounded,
  });

  final String? about;

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final hasAbout = about != null && about!.trim().isNotEmpty;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.purpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: AppColors.purple),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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
          // CONTENT
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
                Container(
                  width: 6,
                  constraints: const BoxConstraints(minHeight: 48),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    hasAbout
                        ? about!.trim()
                        : 'No business description available.',
                    style: hasAbout
                        ? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.6,
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
