import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class OrdersLoading extends StatelessWidget {
  const OrdersLoading({
    super.key,
    this.itemCount = 5,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 24,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return const _OrderCardSkeleton();
      },
    );
  }
}

class _OrderCardSkeleton extends StatelessWidget {
  const _OrderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SkeletonBox(
                  width: 120,
                  height: 15,
                ),
              ),
              const SizedBox(width: 16),
              const _SkeletonBox(
                width: 78,
                height: 26,
              ),
            ],
          ),

          const SizedBox(height: 10),

          const _SkeletonBox(
            width: 150,
            height: 11,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const _SkeletonBox(
                width: 38,
                height: 38,
                radius: 10,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SkeletonBox(
                    width: 130,
                    height: 13,
                  ),
                  SizedBox(height: 6),
                  _SkeletonBox(
                    width: 180,
                    height: 10,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(
            height: 1,
            color: AppColors.divider,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const _SkeletonBox(
                width: 46,
                height: 46,
                radius: 10,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SkeletonBox(
                    width: 150,
                    height: 13,
                  ),
                  SizedBox(height: 6),
                  _SkeletonBox(
                    width: 100,
                    height: 10,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(
                    width: 40,
                    height: 10,
                  ),
                  SizedBox(height: 6),
                  _SkeletonBox(
                    width: 90,
                    height: 15,
                  ),
                ],
              ),
              _SkeletonBox(
                width: 60,
                height: 11,
              ),
            ],
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
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}