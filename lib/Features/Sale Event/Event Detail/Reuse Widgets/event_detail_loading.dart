import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class EventDetailLoading extends StatefulWidget {
  const EventDetailLoading({super.key});

  @override
  State<EventDetailLoading> createState() => _EventDetailLoadingState();
}

class _EventDetailLoadingState extends State<EventDetailLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.45,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            _LoadingHero(opacity: _animation.value),
            const SizedBox(height: 14),
            _LoadingCard(opacity: _animation.value, height: 205),
            const SizedBox(height: 14),
            _LoadingCard(opacity: _animation.value, height: 165),
            const SizedBox(height: 14),
            _LoadingCard(opacity: _animation.value, height: 145),
          ],
        );
      },
    );
  }
}

class _LoadingHero extends StatelessWidget {
  const _LoadingHero({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 8.5,
            child: _ShimmerBlock(
              opacity: opacity,
              borderRadius: BorderRadius.zero,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBlock(opacity: opacity, width: 190, height: 20),
                const SizedBox(height: 10),
                _ShimmerBlock(
                  opacity: opacity,
                  width: 95,
                  height: 24,
                  borderRadius: BorderRadius.circular(999),
                ),
                const SizedBox(height: 14),
                _ShimmerBlock(opacity: opacity, width: 230, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.opacity, required this.height});

  final double opacity;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ShimmerBlock(
                opacity: opacity,
                width: 42,
                height: 42,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              _ShimmerBlock(opacity: opacity, width: 145, height: 18),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBlock(
                  opacity: opacity,
                  width: double.infinity,
                  height: 42,
                  borderRadius: BorderRadius.circular(13),
                ),
                const SizedBox(height: 10),
                _ShimmerBlock(
                  opacity: opacity,
                  width: MediaQuery.sizeOf(context).width * 0.58,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({
    required this.opacity,
    this.width,
    this.height,
    this.borderRadius,
  });

  final double opacity;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase.withValues(alpha: opacity),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}
