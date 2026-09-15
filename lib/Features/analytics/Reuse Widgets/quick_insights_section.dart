import 'package:flutter/material.dart';

class PendingOrdersInsightCard extends StatelessWidget {
  const PendingOrdersInsightCard({
    super.key,
    required this.pendingOrders,
    this.onReviewPressed, // Baad mein use karenge
  });

  final int pendingOrders;
  final VoidCallback? onReviewPressed;

  @override
  Widget build(BuildContext context) {
    // Agar pending orders 0 hain, toh card show na karein
    if (pendingOrders <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light yellow background (image jaisa)
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFE082), // Slightly darker yellow border
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------
          // Warning Icon (Left Side)
          // ------------------------------------------------
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 28,
              color: Color(0xFFF57C00), // Dark orange
            ),
          ),

          const SizedBox(width: 12),

          // ------------------------------------------------
          // Content (Title + Description + Button)
          // ------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Pending orders',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6D4C00), // Dark brown/yellow text
                  ),
                ),

                const SizedBox(height: 6),

                // Description
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF6D4C00),
                    ),
                    children: [
                      const TextSpan(text: 'You currently have '),
                      TextSpan(
                        text: '$pendingOrders',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' pending order(s). Process them to improve customer satisfaction.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // Button (Outlined) - Abhi disabled hai
                // ------------------------------------------------
                OutlinedButton(
                  onPressed: onReviewPressed, // null = disabled
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF57C00),
                    side: const BorderSide(color: Color(0xFFF57C00)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Review pending',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
