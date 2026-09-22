import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KycShimmerScreen extends StatelessWidget {
  const KycShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Professional Shimmer Colors
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER SECTION =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button Skeleton
                  ShimmerBox(width: 44, height: 44, borderRadius: 12),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Title Skeleton
                        ShimmerBox(width: 160, height: 20, borderRadius: 6),
                        const SizedBox(height: 8),
                        // Subtitle Line 1 Skeleton
                        ShimmerBox(width: double.infinity, height: 12, borderRadius: 4),
                        const SizedBox(height: 4),
                        // Subtitle Line 2 Skeleton
                        ShimmerBox(width: 140, height: 12, borderRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ================= MAIN KYC CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    // Center Big Avatar Circle
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title Placeholder
                    ShimmerBox(width: 150, height: 20, borderRadius: 6),
                    const SizedBox(height: 8),

                    // Subtitle Placeholder
                    ShimmerBox(width: 90, height: 14, borderRadius: 4),
                    const SizedBox(height: 16),

                    // Status Badge Pill Placeholder
                    ShimmerBox(width: 120, height: 36, borderRadius: 20),
                    const SizedBox(height: 12),

                    // Submission Count Placeholder
                    ShimmerBox(width: 110, height: 12, borderRadius: 4),
                    const SizedBox(height: 20),

                    // Alert / Info Box Container
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Small Icon Circle
                          Shimmer.fromColors(
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerBox(width: double.infinity, height: 12, borderRadius: 4),
                                const SizedBox(height: 6),
                                ShimmerBox(width: double.infinity, height: 12, borderRadius: 4),
                                const SizedBox(height: 6),
                                ShimmerBox(width: 160, height: 12, borderRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Refresh Button Placeholder
                    ShimmerBox(width: double.infinity, height: 48, borderRadius: 12),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ================= SUBMITTED INFORMATION CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row (Icon + Text)
                    Row(
                      children: [
                        ShimmerBox(width: 44, height: 44, borderRadius: 12),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(width: 160, height: 18, borderRadius: 6),
                            const SizedBox(height: 6),
                            ShimmerBox(width: 190, height: 12, borderRadius: 4),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Input Field Box 1 (Owner Name)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: 80, height: 10, borderRadius: 4),
                          const SizedBox(height: 8),
                          ShimmerBox(width: 120, height: 14, borderRadius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Field Box 2 (Owner Email)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: 80, height: 10, borderRadius: 4),
                          const SizedBox(height: 8),
                          ShimmerBox(width: 180, height: 14, borderRadius: 4),
                        ],
                      ),
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

// Reusable Helper Widget for Shimmer Rectangles
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