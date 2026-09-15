import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Theme/app_colors.dart';

class AnalyticsLoading extends StatelessWidget {
  const AnalyticsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Header Skeleton (Back button + Title + Subtitle)
        const _HeaderSkeleton(),
        const SizedBox(height: 24),

        // 2. Action Buttons (Orders & Products)
        const _ActionButtonsSkeleton(),
        const SizedBox(height: 20),

        // 3. Filter Card (Start Date & End Date)
        const _FilterSkeleton(),
        const SizedBox(height: 24),

        // 4. Overview Title
        const _SectionTitleSkeleton(),
        const SizedBox(height: 12),

        // 5. Stats Grid (2x2 Cards)
        const _StatsGridSkeleton(),
      ],
    );
  }
}

// ============================================================
// 1. Header Skeleton
// ============================================================
class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ShimmerBox(width: 44, height: 44, borderRadius: 12),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              _ShimmerBox(width: 120, height: 22, borderRadius: 6),
              SizedBox(height: 6),
              _ShimmerBox(width: 200, height: 14, borderRadius: 5),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 2. Action Buttons Skeleton
// ============================================================
class _ActionButtonsSkeleton extends StatelessWidget {
  const _ActionButtonsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: _ShimmerBox(width: 80, height: 18, borderRadius: 6),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: _ShimmerBox(width: 80, height: 18, borderRadius: 6),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 3. Filter Skeleton (Start & End Dates)
// ============================================================
class _FilterSkeleton extends StatelessWidget {
  const _FilterSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const _ShimmerBox(width: 32, height: 32, borderRadius: 8),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _ShimmerBox(width: 50, height: 10, borderRadius: 4),
                      SizedBox(height: 6),
                      _ShimmerBox(width: 70, height: 14, borderRadius: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                const _ShimmerBox(width: 32, height: 32, borderRadius: 8),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _ShimmerBox(width: 50, height: 10, borderRadius: 4),
                      SizedBox(height: 6),
                      _ShimmerBox(width: 70, height: 14, borderRadius: 5),
                    ],
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

// ============================================================
// 4. Section Title Skeleton (Overview)
// ============================================================
class _SectionTitleSkeleton extends StatelessWidget {
  const _SectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        _ShimmerBox(width: 100, height: 20, borderRadius: 6),
        SizedBox(height: 6),
        _ShimmerBox(width: 220, height: 13, borderRadius: 5),
      ],
    );
  }
}

// ============================================================
// 5. Stats Grid Skeleton (FIXED 2 COLUMNS - EXACT UI MATCH)
// ============================================================
class _StatsGridSkeleton extends StatelessWidget {
  const _StatsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    // Screen ki width le rahe hain
    final screenWidth = MediaQuery.of(context).size.width;

    // Horizontal padding (AnalyticsScrollView se aata hai, approx 16)
    const horizontalPadding = 16.0;
    const crossAxisSpacing = 12.0;

    // Available width for grid
    final availableWidth = screenWidth - (horizontalPadding * 2);

    // Har card ki width (2 columns)
    final cardWidth = (availableWidth - crossAxisSpacing) / 2;

    // Card ki height fix kar rahe hain (approx 155) taaki image jaisa lage
    const cardHeight = 155.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6, // 4 cards (2x2)
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // HAMESHA 2 columns, chahe screen choti ho ya badi
        mainAxisSpacing: 12,
        crossAxisSpacing: crossAxisSpacing,
        // Aspect ratio calculate kar rahe hain taaki exact height mile aur overflow na ho
        childAspectRatio: cardWidth / cardHeight,
      ),
      itemBuilder: (context, index) {
        return const _StatCardSkeleton();
      },
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  const _StatCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14), // Image ke hisaab se padding
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          // 1. Icon Box (Image mein 42x42 hai)
          _ShimmerBox(width: 42, height: 42, borderRadius: 12),

          SizedBox(height: 14),

          // 2. Title (e.g., "Gross Sales") - Image mein chota text hai
          _ShimmerBox(width: 75, height: 12, borderRadius: 4),

          SizedBox(height: 8),

          // 3. Big Value (e.g., "18.00") - Image mein bold aur bada hai
          _ShimmerBox(width: 85, height: 22, borderRadius: 5),

          SizedBox(height: 6),

          // 4. Subtitle (e.g., "Before commission") - Image mein sabse chota
          _ShimmerBox(width: 95, height: 10, borderRadius: 4),
        ],
      ),
    );
  }
}

// ============================================================
// Shimmer Box Wrapper
// ============================================================
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
