// lib/features/orders/presentation/screens/Reuse Widgets/orders_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Theme/app_colors.dart';

class OrdersLoading extends StatelessWidget {
  const OrdersLoading({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final count = itemCount <= 0 ? 5 : itemCount;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: count + 1,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const _OrderCardShimmerItem();
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ATTRACTIVE ORDER CARD SHIMMER ITEM
// ═════════════════════════════════════════════════════════════════════════════
class _OrderCardShimmerItem extends StatelessWidget {
  const _OrderCardShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard, // Solid White Card Background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ORDER ID, DATE & STATUS CHIP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 160, height: 14, borderRadius: 4),
                    SizedBox(height: 6),
                    _ShimmerBox(width: 110, height: 10, borderRadius: 4),
                  ],
                ),
                _ShimmerBox(width: 74, height: 24, borderRadius: 12),
              ],
            ),

            const SizedBox(height: 14),

            // 2. CUSTOMER DETAILS
            Row(
              children: [
                const _ShimmerBox(width: 36, height: 36, borderRadius: 10),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ShimmerBox(width: 120, height: 12, borderRadius: 4),
                    SizedBox(height: 6),
                    _ShimmerBox(width: 150, height: 10, borderRadius: 4),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Divider Line Placeholder
            const _ShimmerBox(
              width: double.infinity,
              height: 1,
              borderRadius: 0,
            ),

            const SizedBox(height: 14),

            // 3. PRODUCT DETAILS
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ShimmerBox(width: 56, height: 56, borderRadius: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _ShimmerBox(
                        width: double.infinity,
                        height: 12,
                        borderRadius: 4,
                      ),
                      SizedBox(height: 6),
                      _ShimmerBox(width: 140, height: 12, borderRadius: 4),
                      SizedBox(height: 8),
                      _ShimmerBox(width: 40, height: 10, borderRadius: 4),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 4. FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(width: 70, height: 10, borderRadius: 4),
                    SizedBox(height: 6),
                    _ShimmerBox(width: 90, height: 16, borderRadius: 4),
                  ],
                ),
                _ShimmerBox(width: 50, height: 12, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// REUSABLE SHIMMER BOX
// ═════════════════════════════════════════════════════════════════════════════
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors
            .white, // Shimmer widget automatically fills this color with baseColor & highlightColor
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
