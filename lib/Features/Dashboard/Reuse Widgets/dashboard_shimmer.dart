import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Theme/app_colors.dart';

/// ============================================================
/// DASHBOARD SHIMMER  —  Production Level
/// ------------------------------------------------------------
/// Structure matches real dashboard:
///   1. Header card (circle icon + 2 lines + dots)
///   2. Four info cards (Gross / Commission / Net / Affiliate)
///   3. Stats grid 2x2
///   4. Recent orders tiles
///   5. Product preview tiles
///
/// NOTE:
///   • Card background = WHITE (real card look)
///   • Skeleton blocks = GREY (visible inside white card)
///   • No text is rendered — only grey skeleton blocks
/// ============================================================

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key, this.horizontalPadding = 18});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        30,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER CARD
          _HeaderCardShimmer(),
          SizedBox(height: 16),

          // 2. GROSS CARD
          _InfoCardShimmer(
            lines: [
              _LineSpec(widthFactor: 0.45, height: 11),
              _LineSpec(widthFactor: 0.35, height: 24, topGap: 12),
              _LineSpec(widthFactor: 0.42, height: 10, topGap: 14),
              _LineSpec(widthFactor: 0.38, height: 10, topGap: 8),
            ],
          ),
          SizedBox(height: 14),

          // 3. COMMISSION CARD
          _InfoCardShimmer(
            lines: [
              _LineSpec(widthFactor: 0.55, height: 11),
              _LineSpec(widthFactor: 0.30, height: 24, topGap: 12),
              _LineSpec(widthFactor: 0.58, height: 10, topGap: 14),
            ],
          ),
          SizedBox(height: 14),

          // 4. NET PAYABLE CARD
          _InfoCardShimmer(
            lines: [
              _LineSpec(widthFactor: 0.42, height: 11),
              _LineSpec(widthFactor: 0.36, height: 24, topGap: 12),
              _LineSpec(widthFactor: 0.52, height: 10, topGap: 14),
            ],
          ),
          SizedBox(height: 14),

          // 5. AFFILIATE-READY CARD
          _InfoCardShimmer(
            lines: [
              _LineSpec(widthFactor: 0.58, height: 11),
              _LineSpec(widthFactor: 0.10, height: 24, topGap: 12),
              _LineSpec(widthFactor: 0.45, height: 10, topGap: 14),
            ],
          ),

          SizedBox(height: 24),

          // 6. STATS SECTION
          _SectionTitleShimmer(),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatTileShimmer()),
              SizedBox(width: 12),
              Expanded(child: _StatTileShimmer()),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatTileShimmer()),
              SizedBox(width: 12),
              Expanded(child: _StatTileShimmer()),
            ],
          ),

          SizedBox(height: 24),

          // 7. RECENT ORDERS
          _SectionTitleShimmer(),
          SizedBox(height: 12),
          _RecentTileShimmer(),
          SizedBox(height: 10),
          _RecentTileShimmer(),
          SizedBox(height: 10),
          _RecentTileShimmer(),

          SizedBox(height: 24),

          // 8. PRODUCTS PREVIEW
          _SectionTitleShimmer(),
          SizedBox(height: 12),
          _ProductTileShimmer(),
          SizedBox(height: 10),
          _ProductTileShimmer(),
        ],
      ),
    );
  }
}

// ============================================================
// SHIMMER WRAPPER
// ------------------------------------------------------------
// Wraps any widget with shimmer.
// Cards themselves stay WHITE — only inner blocks shimmer.
// ============================================================

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1400),
      direction: ShimmerDirection.ltr,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

// ============================================================
// LINE SPEC
// ============================================================

class _LineSpec {
  const _LineSpec({
    required this.widthFactor,
    required this.height,
    this.topGap = 0,
  });

  final double widthFactor;
  final double height;
  final double topGap;
}

// ============================================================
// HEADER CARD
// ============================================================

class _HeaderCardShimmer extends StatelessWidget {
  const _HeaderCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle icon
          const _ShimmerBlock(width: 52, height: 52, radius: 26),

          const SizedBox(width: 14),

          // Text lines
          Expanded(
            child: LayoutBuilder(
              builder: (_, c) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBlock(width: c.maxWidth * 0.55, height: 16),
                  const SizedBox(height: 10),
                  _ShimmerBlock(width: c.maxWidth * 0.95, height: 11),
                  const SizedBox(height: 6),
                  _ShimmerBlock(width: c.maxWidth * 0.75, height: 11),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Menu dots
          const _ShimmerBlock(width: 36, height: 36, radius: 10),
        ],
      ),
    );
  }
}

// ============================================================
// INFO CARD
// ============================================================

class _InfoCardShimmer extends StatelessWidget {
  const _InfoCardShimmer({required this.lines});

  final List<_LineSpec> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          const _ShimmerBlock(width: 48, height: 48, radius: 14),

          const SizedBox(width: 14),

          // Text lines
          Expanded(
            child: LayoutBuilder(
              builder: (_, c) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in lines) ...[
                    if (line.topGap > 0) SizedBox(height: line.topGap),
                    _ShimmerBlock(
                      width: c.maxWidth * line.widthFactor,
                      height: line.height,
                      radius: line.height >= 18 ? 8 : 6,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitleShimmer extends StatelessWidget {
  const _SectionTitleShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerBlock(width: 140, height: 14, radius: 6),
        _ShimmerBlock(width: 60, height: 12, radius: 6),
      ],
    );
  }
}

// ============================================================
// STAT TILE
// ============================================================

class _StatTileShimmer extends StatelessWidget {
  const _StatTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ShimmerBlock(width: 36, height: 36, radius: 10),
          SizedBox(height: 14),
          _ShimmerBlock(width: 55, height: 18, radius: 6),
          SizedBox(height: 10),
          _ShimmerBlock(width: 85, height: 10, radius: 6),
        ],
      ),
    );
  }
}

// ============================================================
// RECENT ORDER TILE
// ============================================================

class _RecentTileShimmer extends StatelessWidget {
  const _RecentTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          _ShimmerBlock(width: 42, height: 42, radius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBlock(width: 130, height: 12, radius: 6),
                SizedBox(height: 8),
                _ShimmerBlock(width: 85, height: 10, radius: 6),
              ],
            ),
          ),
          SizedBox(width: 10),
          _ShimmerBlock(width: 60, height: 22, radius: 8),
        ],
      ),
    );
  }
}

// ============================================================
// PRODUCT TILE
// ============================================================

class _ProductTileShimmer extends StatelessWidget {
  const _ProductTileShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          _ShimmerBlock(width: 56, height: 56, radius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBlock(width: 170, height: 12, radius: 6),
                SizedBox(height: 8),
                _ShimmerBlock(width: 100, height: 10, radius: 6),
                SizedBox(height: 10),
                _ShimmerBlock(width: 70, height: 12, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
