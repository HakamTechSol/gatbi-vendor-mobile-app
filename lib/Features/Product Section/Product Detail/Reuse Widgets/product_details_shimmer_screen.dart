import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmerScreen extends StatelessWidget {
  const ProductDetailsShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= TOP APP BAR / HEADER =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button Skeleton
                  const ShimmerBox(width: 44, height: 44, borderRadius: 12),
                  const SizedBox(width: 12),
                  // Title & SKU Subtitle Skeleton
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 180, height: 16, borderRadius: 4),
                        SizedBox(height: 6),
                        ShimmerBox(width: 120, height: 12, borderRadius: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Edit Button Skeleton
                  const ShimmerBox(width: 72, height: 38, borderRadius: 10),
                ],
              ),
              const SizedBox(height: 16),

              // ================= IMAGE GALLERY CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    // Main Large Image Placeholder with Image Counter Badge
                    Stack(
                      children: [
                        const ShimmerBox(
                          width: double.infinity,
                          height: 280,
                          borderRadius: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Gallery Thumbnails Row (3 Image Thumbnails)
                    Row(
                      children: const [
                        Expanded(
                          child: ShimmerBox(
                            width: double.infinity,
                            height: 70,
                            borderRadius: 12,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ShimmerBox(
                            width: double.infinity,
                            height: 70,
                            borderRadius: 12,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ShimmerBox(
                            width: double.infinity,
                            height: 70,
                            borderRadius: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ================= PRODUCT DETAILS CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header (Icon + Title + Subtitle)
                    Row(
                      children: [
                        const ShimmerBox(
                          width: 40,
                          height: 40,
                          borderRadius: 12,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerBox(width: 130, height: 16, borderRadius: 4),
                            SizedBox(height: 6),
                            ShimmerBox(width: 180, height: 11, borderRadius: 4),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ================= 2x2 GRID METRICS =================
                    // Row 1: Stock & Stock Status
                    Row(
                      children: const [
                        Expanded(child: GridMetricCardShimmer()),
                        SizedBox(width: 12),
                        Expanded(child: GridMetricCardShimmer()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 2: Category & Brand
                    Row(
                      children: const [
                        Expanded(child: GridMetricCardShimmer()),
                        SizedBox(width: 12),
                        Expanded(child: GridMetricCardShimmer()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= REUSABLE GRID CARD SHIMMER =================
class GridMetricCardShimmer extends StatelessWidget {
  const GridMetricCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              ShimmerBox(width: 24, height: 24, borderRadius: 6),
              SizedBox(width: 10),
              ShimmerBox(width: 60, height: 10, borderRadius: 3),
            ],
          ),
          const SizedBox(height: 10),
          const ShimmerBox(width: 80, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}

// ================= REUSABLE SHIMMER BOX =================
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
