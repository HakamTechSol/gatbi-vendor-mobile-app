import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TicketDetailsShimmerScreen extends StatelessWidget {
  const TicketDetailsShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ================= MAIN CHAT AREA CONTAINER =================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conversation Header Section (Icon + Text + Badge)
                      Row(
                        children: [
                          const ShimmerBox(
                            width: 36,
                            height: 36,
                            borderRadius: 10,
                          ),
                          const SizedBox(width: 10),
                          const ShimmerBox(
                            width: 110,
                            height: 16,
                            borderRadius: 4,
                          ),
                          const SizedBox(width: 8),
                          // Count Badge
                          const ShimmerBox(
                            width: 22,
                            height: 18,
                            borderRadius: 6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ================= CHAT MESSAGES LIST =================

                      // 1. USER MESSAGE (RIGHT ALIGNED)
                      const UserMessageShimmer(
                        bubbleWidth: 200,
                        bubbleHeight: 52,
                      ),
                      const SizedBox(height: 20),

                      // 2. ADMIN MESSAGE (LEFT ALIGNED)
                      const AdminMessageShimmer(
                        bubbleWidth: 180,
                        bubbleHeight: 48,
                      ),
                      const SizedBox(height: 20),

                      // 3. USER MESSAGE (RIGHT ALIGNED)
                      const UserMessageShimmer(
                        bubbleWidth: 160,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 20),

                      // 4. ADMIN MESSAGE (LEFT ALIGNED)
                      const AdminMessageShimmer(
                        bubbleWidth: 150,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 20),

                      // 5. USER MESSAGE (RIGHT ALIGNED)
                      const UserMessageShimmer(
                        bubbleWidth: 170,
                        bubbleHeight: 48,
                      ),
                      const SizedBox(height: 20),

                      // 6. ADMIN MESSAGE (LEFT ALIGNED)
                      const AdminMessageShimmer(
                        bubbleWidth: 140,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 20),

                      // 7. USER MESSAGE (RIGHT ALIGNED)
                      const UserMessageShimmer(
                        bubbleWidth: 160,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 20),

                      // 8. ADMIN MESSAGE (LEFT ALIGNED)
                      const AdminMessageShimmer(
                        bubbleWidth: 150,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 20),

                      // 9. USER MESSAGE (RIGHT ALIGNED)
                      const UserMessageShimmer(
                        bubbleWidth: 160,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 20),

                      // 10. ADMIN MESSAGE (LEFT ALIGNED)
                      const AdminMessageShimmer(
                        bubbleWidth: 150,
                        bubbleHeight: 44,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= USER MESSAGE SHIMMER (RIGHT) =================
class UserMessageShimmer extends StatelessWidget {
  final double bubbleWidth;
  final double bubbleHeight;

  const UserMessageShimmer({
    Key? key,
    required this.bubbleWidth,
    required this.bubbleHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Sender Name Line
        const Padding(
          padding: EdgeInsets.only(right: 42, bottom: 4),
          child: ShimmerBox(width: 90, height: 10, borderRadius: 3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Chat Bubble
            ShimmerBox(
              width: bubbleWidth,
              height: bubbleHeight,
              borderRadius: 16,
            ),
            const SizedBox(width: 8),
            // User Circle Avatar
            const ShimmerCircle(size: 32),
          ],
        ),
      ],
    );
  }
}

// ================= ADMIN MESSAGE SHIMMER (LEFT) =================
class AdminMessageShimmer extends StatelessWidget {
  final double bubbleWidth;
  final double bubbleHeight;

  const AdminMessageShimmer({
    Key? key,
    required this.bubbleWidth,
    required this.bubbleHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Admin Name & Support Badge Line
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 6),
          child: Row(
            children: const [
              ShimmerBox(width: 70, height: 10, borderRadius: 3),
              SizedBox(width: 6),
              ShimmerBox(width: 45, height: 14, borderRadius: 4), // Support Tag
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Admin Circle Avatar
            const ShimmerCircle(size: 32),
            const SizedBox(width: 8),
            // Chat Bubble
            ShimmerBox(
              width: bubbleWidth,
              height: bubbleHeight,
              borderRadius: 16,
            ),
          ],
        ),
      ],
    );
  }
}

// ================= REUSABLE RECTANGLE SHIMMER =================
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

// ================= REUSABLE CIRCULAR SHIMMER =================
class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
