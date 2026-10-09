import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Theme/app_colors.dart';

/// ============================================================
/// DASHBOARD SHIMMER — Production Level (Updated UI Match)
/// ------------------------------------------------------------
/// Structure matches attached UI:
///   1. Header Bar (Avatar + Welcome Text + Approved Badge + Menu)
///   2. Net Payable Card (Highlighted Purple Top Banner)
///   3. Products Gross Card (Icon, Title, Value, Sub-boxes for Products/Shipping)
///   4. Gatbi Commission Card (Icon, Title, Percentage Badge, Value)
///   5. Affiliate Program Card (Header + Active Badge + Inner Container)
///   6. Stats Grid 2x2
///   7. Recent Orders Tiles
///   8. Product Preview Tiles
/// ============================================================

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key, this.horizontalPadding = 18});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------
          // 1. HEADER - FULL WIDTH
          // -----------------------------------------------------------
          const _HeaderCardShimmer(),

          // -----------------------------------------------------------
          // REST OF DASHBOARD CONTENT
          // -----------------------------------------------------------
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              16,
              horizontalPadding,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -----------------------------------------------------
                // 2. NET PAYABLE CARD (Purple Accent Hero Card)
                // -----------------------------------------------------
                const _NetPayableCardShimmer(),

                const SizedBox(height: 14),

                // -----------------------------------------------------
                // 3. PRODUCTS GROSS CARD (With Bottom Sub-boxes)
                // -----------------------------------------------------
                const _ProductsGrossCardShimmer(),

                const SizedBox(height: 14),

                // -----------------------------------------------------
                // 4. GATBI COMMISSION CARD (With Percentage Badge)
                // -----------------------------------------------------
                const _GatbiCommissionCardShimmer(),

                const SizedBox(height: 14),

                // -----------------------------------------------------
                // 5. AFFILIATE PROGRAM CARD
                // -----------------------------------------------------
                const _AffiliateCardShimmer(),

                const SizedBox(height: 24),

                // -----------------------------------------------------
                // 6. STATS SECTION (2x2 Grid)
                // -----------------------------------------------------
                const _SectionTitleShimmer(),
                const SizedBox(height: 12),

                const Row(
                  children: [
                    Expanded(child: _StatTileShimmer()),
                    SizedBox(width: 12),
                    Expanded(child: _StatTileShimmer()),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: _StatTileShimmer()),
                    SizedBox(width: 12),
                    Expanded(child: _StatTileShimmer()),
                  ],
                ),

                const SizedBox(height: 24),

                // -----------------------------------------------------
                // 7. RECENT ORDERS SECTION
                // -----------------------------------------------------
                const _SectionTitleShimmer(),
                const SizedBox(height: 12),

                const _RecentTileShimmer(),
                const SizedBox(height: 10),
                const _RecentTileShimmer(),
                const SizedBox(height: 10),
                const _RecentTileShimmer(),

                const SizedBox(height: 24),

                // -----------------------------------------------------
                // 8. PRODUCTS PREVIEW SECTION
                // -----------------------------------------------------
                const _SectionTitleShimmer(),
                const SizedBox(height: 12),

                const _ProductTileShimmer(),
                const SizedBox(height: 10),
                const _ProductTileShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SHIMMER WRAPPER BLOCK
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
// HEADER SHIMMER (Avatar + Title + Subtitle + Badge + Menu)
// ============================================================

class _HeaderCardShimmer extends StatelessWidget {
  const _HeaderCardShimmer();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 380;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 14 : 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.65)),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          _ShimmerBlock(
            width: isSmallScreen ? 44 : 48,
            height: isSmallScreen ? 44 : 48,
            radius: 50,
          ),
          SizedBox(width: isSmallScreen ? 10 : 12),

          // Title, Subtitle, & Status Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const _ShimmerBlock(width: 110, height: 16, radius: 4),
                    const SizedBox(width: 8),
                    // Approved badge skeleton
                    const _ShimmerBlock(width: 65, height: 18, radius: 12),
                  ],
                ),
                const SizedBox(height: 6),
                const _ShimmerBlock(width: 170, height: 10, radius: 4),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Menu button
          _ShimmerBlock(
            width: isSmallScreen ? 38 : 42,
            height: isSmallScreen ? 38 : 42,
            radius: 12,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 2. NET PAYABLE CARD (Purple Featured Card)
// ============================================================

class _NetPayableCardShimmer extends StatelessWidget {
  const _NetPayableCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Wallet Icon Box
          const _ShimmerBlock(width: 52, height: 52, radius: 16),
          const SizedBox(width: 14),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    _ShimmerBlock(width: 110, height: 12, radius: 4),
                    SizedBox(width: 8),
                    _ShimmerBlock(width: 16, height: 16, radius: 50),
                  ],
                ),
                const SizedBox(height: 8),
                const _ShimmerBlock(width: 130, height: 26, radius: 6),
                const SizedBox(height: 8),
                const _ShimmerBlock(width: 160, height: 9, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 3. PRODUCTS GROSS CARD (With Products & Shipping Inner Blocks)
// ============================================================

class _ProductsGrossCardShimmer extends StatelessWidget {
  const _ProductsGrossCardShimmer();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Title/Subtitle
          Row(
            children: [
              const _ShimmerBlock(width: 44, height: 44, radius: 12),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ShimmerBlock(width: 110, height: 13, radius: 4),
                  SizedBox(height: 6),
                  _ShimmerBlock(width: 90, height: 9, radius: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Big Amount
          const _ShimmerBlock(width: 140, height: 24, radius: 6),
          const SizedBox(height: 14),

          // Bottom Sub-Boxes Row (Products | Shipping)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const _ShimmerBlock(width: 28, height: 28, radius: 8),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _ShimmerBlock(width: 45, height: 9, radius: 3),
                          SizedBox(height: 4),
                          _ShimmerBlock(width: 55, height: 11, radius: 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const _ShimmerBlock(width: 28, height: 28, radius: 8),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _ShimmerBlock(width: 45, height: 9, radius: 3),
                          SizedBox(height: 4),
                          _ShimmerBlock(width: 55, height: 11, radius: 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 4. GATBI COMMISSION CARD (With Percentage Badge on Top Right)
// ============================================================

class _GatbiCommissionCardShimmer extends StatelessWidget {
  const _GatbiCommissionCardShimmer();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row with Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ShimmerBlock(width: 44, height: 44, radius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ShimmerBlock(width: 120, height: 13, radius: 4),
                    SizedBox(height: 6),
                    _ShimmerBlock(width: 100, height: 9, radius: 4),
                  ],
                ),
              ),
              // Percentage Badge
              const _ShimmerBlock(width: 45, height: 20, radius: 8),
            ],
          ),
          const SizedBox(height: 16),

          // Big Amount
          const _ShimmerBlock(width: 120, height: 24, radius: 6),
        ],
      ),
    );
  }
}

// ============================================================
// 5. AFFILIATE PROGRAM CARD (Header + Active Badge + Inner Tile)
// ============================================================

class _AffiliateCardShimmer extends StatelessWidget {
  const _AffiliateCardShimmer();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar with Active Badge
          Row(
            children: [
              const _ShimmerBlock(width: 40, height: 40, radius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ShimmerBlock(width: 110, height: 13, radius: 4),
                    SizedBox(height: 6),
                    _ShimmerBlock(width: 150, height: 9, radius: 4),
                  ],
                ),
              ),
              const _ShimmerBlock(width: 55, height: 20, radius: 10),
            ],
          ),
          const SizedBox(height: 16),

          // Inner Affiliate Sub-card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.shimmerBase.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const _ShimmerBlock(width: 44, height: 44, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _ShimmerBlock(width: 110, height: 10, radius: 3),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          _ShimmerBlock(width: 16, height: 18, radius: 4),
                          SizedBox(width: 6),
                          _ShimmerBlock(width: 50, height: 10, radius: 3),
                        ],
                      ),
                    ],
                  ),
                ),
                const _ShimmerBlock(width: 24, height: 24, radius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION TITLE SHIMMER
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
// STAT TILE SHIMMER
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
// RECENT ORDER TILE SHIMMER
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
// PRODUCT TILE SHIMMER
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
