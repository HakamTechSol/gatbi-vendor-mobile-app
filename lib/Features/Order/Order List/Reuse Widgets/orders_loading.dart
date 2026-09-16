import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class OrdersLoading extends StatefulWidget {
  const OrdersLoading({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  State<OrdersLoading> createState() => _OrdersLoadingState();
}

class _OrdersLoadingState extends State<OrdersLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final position = _controller.value * 2 - 1;

            return LinearGradient(
              begin: Alignment(position - 1, 0),
              end: Alignment(position + 1, 0),
              colors: const [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight,
                AppColors.shimmerBase,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (_, __) {
          return const _OrderCardSkeleton();
        },
      ),
    );
  }
}

// ============================================================
// CARD SKELETON
// ============================================================

class _OrderCardSkeleton extends StatelessWidget {
  const _OrderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // Header
          // ----------------------------------------------------
          Row(
            children: const [
              Expanded(child: _SkeletonBox(width: 150, height: 15)),
              SizedBox(width: 16),
              _SkeletonBox(width: 78, height: 26, radius: 8),
            ],
          ),

          const SizedBox(height: 8),

          const _SkeletonBox(width: 145, height: 11),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // Customer
          // ----------------------------------------------------
          Row(
            children: const [
              _SkeletonBox(width: 38, height: 38, radius: 10),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 130, height: 13),
                    SizedBox(height: 6),
                    _SkeletonBox(width: 180, height: 10),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1, thickness: 1, color: AppColors.divider),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // Product
          // ----------------------------------------------------
          Row(
            children: const [
              _SkeletonBox(width: 56, height: 56, radius: 10),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 180, height: 13),
                    SizedBox(height: 7),
                    _SkeletonBox(width: 80, height: 10),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // Footer
          // ----------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 70, height: 10),
                  SizedBox(height: 6),
                  _SkeletonBox(width: 95, height: 15),
                ],
              ),
              _SkeletonBox(width: 65, height: 11),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SKELETON BOX
// ============================================================

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
