import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class AnalyticsLoading extends StatelessWidget {
  const AnalyticsLoading({
    super.key,
    this.showHeader = true,
    this.showStats = true,
    this.showProducts = true,
    this.showInsights = true,
  });

  final bool showHeader;
  final bool showStats;
  final bool showProducts;
  final bool showInsights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          const _AnalyticsHeaderSkeleton(),
          const SizedBox(height: 24),
        ],
        if (showStats) ...[
          const _AnalyticsStatsSkeleton(),
          const SizedBox(height: 24),
        ],
        if (showProducts) ...[
          const _AnalyticsSectionTitleSkeleton(),
          const SizedBox(height: 12),
          const _AnalyticsProductSkeletonList(),
          const SizedBox(height: 24),
        ],
        if (showInsights) ...[
          const _AnalyticsSectionTitleSkeleton(),
          const SizedBox(height: 12),
          const _AnalyticsInsightSkeletonList(),
        ],
      ],
    );
  }
}

class _AnalyticsHeaderSkeleton extends StatelessWidget {
  const _AnalyticsHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShimmerBox(width: 48, height: 48, borderRadius: 14),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(width: 130, height: 22, borderRadius: 6),
              const SizedBox(height: 8),
              _ShimmerBox(width: 230, height: 14, borderRadius: 5),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnalyticsStatsSkeleton extends StatelessWidget {
  const _AnalyticsStatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 360 ? 1 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: columns == 1 ? 2.35 : 1.08,
          ),
          itemBuilder: (context, index) {
            return const _StatCardSkeleton();
          },
        );
      },
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ShimmerBox(width: 42, height: 42, borderRadius: 12),
          const SizedBox(height: 14),
          const _ShimmerBox(width: 90, height: 13, borderRadius: 5),
          const SizedBox(height: 8),
          const _ShimmerBox(width: 125, height: 21, borderRadius: 6),
          const SizedBox(height: 7),
          const _ShimmerBox(width: 85, height: 12, borderRadius: 5),
        ],
      ),
    );
  }
}

class _AnalyticsSectionTitleSkeleton extends StatelessWidget {
  const _AnalyticsSectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShimmerBox(width: 125, height: 19, borderRadius: 6),
        SizedBox(height: 7),
        _ShimmerBox(width: 245, height: 13, borderRadius: 5),
      ],
    );
  }
}

class _AnalyticsProductSkeletonList extends StatelessWidget {
  const _AnalyticsProductSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: _ProductSkeleton(),
        ),
      ),
    );
  }
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          _ShimmerBox(width: 24, height: 16, borderRadius: 4),
          SizedBox(width: 10),
          _ShimmerBox(width: 52, height: 52, borderRadius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 150, height: 14, borderRadius: 5),
                SizedBox(height: 7),
                _ShimmerBox(width: 90, height: 11, borderRadius: 4),
                SizedBox(height: 7),
                _ShimmerBox(width: 80, height: 10, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShimmerBox(width: 72, height: 14, borderRadius: 5),
              SizedBox(height: 6),
              _ShimmerBox(width: 30, height: 10, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsInsightSkeletonList extends StatelessWidget {
  const _AnalyticsInsightSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: _InsightSkeleton(),
        ),
      ),
    );
  }
}

class _InsightSkeleton extends StatelessWidget {
  const _InsightSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: 40, height: 40, borderRadius: 11),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 120, height: 15, borderRadius: 5),
                SizedBox(height: 8),
                _ShimmerBox(
                  width: double.infinity,
                  height: 12,
                  borderRadius: 4,
                ),
                SizedBox(height: 6),
                _ShimmerBox(width: 190, height: 12, borderRadius: 4),
                SizedBox(height: 12),
                _ShimmerBox(width: 105, height: 30, borderRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.45,
      end: 1.0,
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
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}
