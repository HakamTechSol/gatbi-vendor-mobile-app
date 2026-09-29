import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class AttributesLoading extends StatelessWidget {
  const AttributesLoading({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return const _AttributeSkeletonCard();
      },
    );
  }
}

class _AttributeSkeletonCard extends StatelessWidget {
  const _AttributeSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SkeletonBox(width: 46, height: 46, radius: 13),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 150, height: 16, radius: 6),
                    SizedBox(height: 8),
                    _SkeletonBox(width: 105, height: 11, radius: 5),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const _SkeletonBox(width: 32, height: 32, radius: 9),
              const SizedBox(width: 7),
              const _SkeletonBox(width: 32, height: 32, radius: 9),
            ],
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SkeletonBox(width: 72, height: 28, radius: 20),
              _SkeletonBox(width: 84, height: 28, radius: 20),
              _SkeletonBox(width: 64, height: 28, radius: 20),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),
          const _SkeletonBox(width: 190, height: 13, radius: 5),
          const SizedBox(height: 13),
          const _SkeletonBox(width: double.infinity, height: 48, radius: 10),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.isFinite ? width : double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
