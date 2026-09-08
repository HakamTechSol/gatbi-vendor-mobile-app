import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';

class MyProductsLoading extends StatelessWidget {
  const MyProductsLoading({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const _ProductSkeletonCard();
      },
    );
  }
}

class _ProductSkeletonCard extends StatelessWidget {
  const _ProductSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 105, height: double.infinity, borderRadius: 14),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                _SkeletonBox(width: 145, height: 13, borderRadius: 6),

                const SizedBox(height: 9),

                _SkeletonBox(width: 85, height: 11, borderRadius: 6),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _SkeletonBox(width: 55, height: 24, borderRadius: 12),

                    const SizedBox(width: 8),

                    _SkeletonBox(width: 60, height: 24, borderRadius: 12),
                  ],
                ),

                const Spacer(),

                Row(
                  children: [
                    _SkeletonBox(width: 65, height: 10, borderRadius: 5),

                    const Spacer(),

                    _SkeletonBox(width: 22, height: 22, borderRadius: 7),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
