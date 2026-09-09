import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Data/support_dummy_data.dart';

class SupportUsefulLinks extends StatelessWidget {
  const SupportUsefulLinks({
    super.key,
    required this.links,
    required this.onLinkTap,
  });

  final List<SupportUsefulLink> links;
  final ValueChanged<SupportUsefulLink> onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Useful Links', style: AppTextStyles.labelMedium),
        const SizedBox(height: 4),
        Text(
          'Quick access to commonly used vendor sections.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: links.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, index) {
            final link = links[index];

            return _UsefulLinkCard(link: link, onTap: () => onLinkTap(link));
          },
        ),
      ],
    );
  }
}

class _UsefulLinkCard extends StatelessWidget {
  const _UsefulLinkCard({required this.link, required this.onTap});

  final SupportUsefulLink link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.link_rounded,
                  color: AppColors.iconPrimary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  link.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
