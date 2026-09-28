import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class ReviewLoading extends StatefulWidget {
  const ReviewLoading({super.key, this.itemCount = 3, this.showSummary = true});

  // ===========================================================================
  // Fields
  // ===========================================================================

  final int itemCount;
  final bool showSummary;

  @override
  State<ReviewLoading> createState() => _ReviewLoadingState();
}

class _ReviewLoadingState extends State<ReviewLoading>
    with SingleTickerProviderStateMixin {
  // ===========================================================================
  // Animation
  // ===========================================================================

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final count = widget.itemCount < 1 ? 1 : widget.itemCount;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          children: [
            if (widget.showSummary) ...[
              _buildSummarySkeleton(),
              const SizedBox(height: 20),
            ],
            ...List.generate(
              count,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildReviewSkeleton(),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // Summary Skeleton
  // ===========================================================================

  Widget _buildSummarySkeleton() {
    return _skeletonContainer(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // Header
            // -----------------------------------------------------------------
            Row(
              children: [
                _box(width: 42, height: 42, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 145, height: 17, radius: 6),
                      const SizedBox(height: 7),
                      _box(width: 220, height: 12, radius: 5),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // -----------------------------------------------------------------
            // Rating
            // -----------------------------------------------------------------
            _box(width: double.infinity, height: 108, radius: 16),

            const SizedBox(height: 18),

            // -----------------------------------------------------------------
            // Metrics
            // -----------------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: _box(width: double.infinity, height: 64, radius: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _box(width: double.infinity, height: 64, radius: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _box(width: double.infinity, height: 64, radius: 14),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // Breakdown
            // -----------------------------------------------------------------
            _box(width: 125, height: 15, radius: 5),

            const SizedBox(height: 15),

            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  children: [
                    _box(width: 30, height: 12, radius: 5),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _box(width: double.infinity, height: 7, radius: 5),
                    ),
                    const SizedBox(width: 10),
                    _box(width: 18, height: 12, radius: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Review Skeleton
  // ===========================================================================

  Widget _buildReviewSkeleton() {
    return _skeletonContainer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(17, 17, 17, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // Product
            // -----------------------------------------------------------------
            Row(
              children: [
                _box(width: 66, height: 66, radius: 14),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 60, height: 10, radius: 4),
                      const SizedBox(height: 8),
                      _box(width: double.infinity, height: 15, radius: 5),
                      const SizedBox(height: 6),
                      _box(width: 150, height: 15, radius: 5),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildDivider(),

            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // Customer
            // -----------------------------------------------------------------
            Row(
              children: [
                _box(width: 48, height: 48, radius: 24),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 125, height: 14, radius: 5),
                      const SizedBox(height: 7),
                      _box(width: 145, height: 11, radius: 5),
                    ],
                  ),
                ),
                _box(width: 65, height: 27, radius: 8),
              ],
            ),

            const SizedBox(height: 15),

            // -----------------------------------------------------------------
            // Rating
            // -----------------------------------------------------------------
            _box(width: double.infinity, height: 43, radius: 12),

            const SizedBox(height: 14),

            // -----------------------------------------------------------------
            // Comment
            // -----------------------------------------------------------------
            _box(width: double.infinity, height: 91, radius: 14),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Skeleton Container
  // ===========================================================================

  Widget _skeletonContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ===========================================================================
  // Skeleton Box
  // ===========================================================================

  Widget _box({
    required double width,
    required double height,
    required double radius,
  }) {
    final value = _animationController.value;

    final opacity = 0.55 + (value * 0.25);

    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Color.lerp(
            AppColors.shimmerBase,
            AppColors.shimmerHighlight,
            value,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  // ===========================================================================
  // Divider
  // ===========================================================================

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: AppColors.divider,
    );
  }
}
