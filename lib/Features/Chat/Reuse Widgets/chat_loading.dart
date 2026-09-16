// lib/features/chat/presentation/screens/Reuse Widgets/chat_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../Theme/app_colors.dart';

class ChatLoading extends StatelessWidget {
  const ChatLoading({
    super.key,
    this.size,
    this.color,
    this.itemCount = 12,
    this.compact = false,
  });

  final double? size;
  final Color? color;
  final int itemCount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompactLoader(context);
    return _buildChatListShimmer(context);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FULL CHAT LIST SHIMMER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildChatListShimmer(BuildContext context) {
    final count = itemCount <= 0 ? 12 : itemCount;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: count,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          thickness: 0.8,
          color: AppColors.shimmerBase,
        ),
        itemBuilder: (context, index) {
          return const _ChatShimmerItem();
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPACT LOADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCompactLoader(BuildContext context) {
    final loaderSize = size ?? 24;
    return Center(
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: SizedBox(
          width: loaderSize,
          height: loaderSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CHAT SHIMMER ITEM
// ═════════════════════════════════════════════════════════════════════════════
class _ChatShimmerItem extends StatelessWidget {
  const _ChatShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ═══════════════════════════════════════════════════════════
          // CIRCULAR AVATAR (SR Icon)
          // ═══════════════════════════════════════════════════════════
          const _ShimmerBox(
            width: 48,
            height: 48,
            borderRadius: 24,
          ),

          const SizedBox(width: 12),

          // ═══════════════════════════════════════════════════════════
          // CONTENT
          // ═══════════════════════════════════════════════════════════
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Row 1: Name ---
                const _ShimmerBox(
                  width: 120,
                  height: 12,
                  borderRadius: 4,
                ),

                const SizedBox(height: 6),

                // --- Row 2: Email ---
                const _ShimmerBox(
                  width: 150,
                  height: 9,
                  borderRadius: 4,
                ),

                const SizedBox(height: 6),

                // --- Row 3: Product title ---
                const _ShimmerBox(
                  width: double.infinity,
                  height: 9,
                  borderRadius: 4,
                ),

                const SizedBox(height: 8),

                // --- Row 4: Last Message + Time (Aligned Right) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    // Last Message Skeleton
                    _ShimmerBox(
                      width: 80,
                      height: 9,
                      borderRadius: 4,
                    ),

                    // Timestamp Skeleton
                    _ShimmerBox(
                      width: 45,
                      height: 8,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SHIMMER BOX
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
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}