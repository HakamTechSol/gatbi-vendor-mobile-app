import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Theme/app_colors.dart';

class ChatDetailShimmer extends StatelessWidget {
  const ChatDetailShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase, // #E2E6EC
      highlightColor: AppColors.shimmerHighlight, // #F5F7FA
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final isVendor = index.isOdd;
          final isProductCard = index == 0;

          return _MessageSkeleton(
            isVendor: isVendor,
            isProductCard: isProductCard,
          );
        },
      ),
    );
  }
}

// ============================================================
// MESSAGE SKELETON
// ============================================================

class _MessageSkeleton extends StatelessWidget {
  const _MessageSkeleton({required this.isVendor, this.isProductCard = false});

  final bool isVendor;
  final bool isProductCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isVendor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Avatar (For non-vendor)
          if (!isVendor) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.shimmerCard,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble Content
          Flexible(
            child: Column(
              crossAxisAlignment: isVendor
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender Name placeholder for Left side
                if (!isVendor) ...[
                  Container(
                    width: 90,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerCard,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

                // Main Message Box / Product Card Skeleton
                if (isProductCard)
                  _buildProductCardSkeleton()
                else
                  _buildTextMessageSkeleton(),

                // Timestamp placeholder
                const SizedBox(height: 4),
                Container(
                  width: 45,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerCard,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),

          // Right Avatar (For vendor)
          if (isVendor) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.shimmerCard,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Text Bubble Layout
  Widget _buildTextMessageSkeleton() {
    return Container(
      constraints: BoxConstraints(maxWidth: isVendor ? 160 : 220),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 10,
            width: isVendor ? 80 : 130,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // Large Product Card Layout (Image + Details)
  Widget _buildProductCardSkeleton() {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 140,
            width: double.infinity,
            color: AppColors.shimmerBase,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category line
                Container(
                  width: 60,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Title lines
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 140,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                // Price Tag
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
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

// ============================================================
// TOP PAGINATION SHIMMER
// ============================================================

class ChatOlderMessagesShimmer extends StatelessWidget {
  const ChatOlderMessagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Center(
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.shimmerCard,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
