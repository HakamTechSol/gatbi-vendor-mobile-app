import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AttributesLoading extends StatelessWidget {
  const AttributesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // ❌ Scaffold aur SingleChildScrollView hata diya gaya hai
    // ✅ Sirf Column return kar raha hai taaki parent scroll view ke sath conflict na ho
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= TOP HEADER (Back Button + Title + Subtitle) =================
        Row(
          children: [
            _shimmer(child: _box(width: 44, height: 44, radius: 12)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(
                  child: _box(width: 140, height: 24, radius: 4),
                ), // Attributes title
                const SizedBox(height: 6),
                _shimmer(
                  child: _box(width: 200, height: 14, radius: 4),
                ), // Subtitle
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ================= ADD ATTRIBUTE BUTTON =================
        _shimmer(child: _box(width: double.infinity, height: 50, radius: 12)),
        const SizedBox(height: 24),

        // ================= 2x2 STATS GRID =================
        Row(
          children: [
            Expanded(child: _buildStatCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard()),
          ],
        ),
        const SizedBox(height: 28),

        // ================= ALL ATTRIBUTES HEADER =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shimmer(child: _box(width: 120, height: 20, radius: 4)),
            _shimmer(
              child: _box(width: 80, height: 20, radius: 10),
            ), // "5 attributes" badge
          ],
        ),
        const SizedBox(height: 16),

        // ================= ATTRIBUTE CARD =================
        _buildAttributeCard(),

        const SizedBox(height: 14),
        // Ek aur card dikhane ke liye (list continuation)
        _buildAttributeCard(),
      ],
    );
  }

  // ================= STAT CARD (Total Attributes, Total Values, etc.) =================
  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(
            child: _box(width: 90, height: 12, radius: 4),
          ), // Title (Total Attributes)
          const SizedBox(height: 16),
          _shimmer(child: _box(width: 30, height: 28, radius: 4)), // Value (5)
          const SizedBox(height: 10),
          _shimmer(
            child: _box(width: 100, height: 10, radius: 4),
          ), // Subtitle (Available attributes)
        ],
      ),
    );
  }

  // ================= ATTRIBUTE CARD =================
  Widget _buildAttributeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- Card Header: Icon + Title/Tag + Options Menu -----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Icon
              _shimmer(child: _box(width: 48, height: 48, radius: 12)),
              const SizedBox(width: 12),

              // Title, Custom Tag, No Label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmer(
                      child: _box(width: 140, height: 18, radius: 4),
                    ), // Active Attributes
                    const SizedBox(height: 8),
                    _shimmer(
                      child: _box(width: 70, height: 22, radius: 12),
                    ), // Custom badge
                    const SizedBox(height: 8),
                    _shimmer(
                      child: _box(width: 80, height: 12, radius: 4),
                    ), // No admin label
                  ],
                ),
              ),

              // 3-dot menu button
              _shimmer(child: _box(width: 32, height: 32, radius: 8)),
            ],
          ),
          const SizedBox(height: 16),

          // ----- Slug Tag (co-active-attributes-v29) -----
          _shimmer(child: _box(width: 160, height: 24, radius: 8)),
          const SizedBox(height: 10),

          // ----- Type Tag (Switch) -----
          _shimmer(child: _box(width: 80, height: 24, radius: 8)),
          const SizedBox(height: 20),

          // ----- Divider -----
          _shimmer(child: _box(width: double.infinity, height: 1, radius: 0)),
          const SizedBox(height: 16),

          // ----- Available Values Header -----
          Row(
            children: [
              // Left Icon
              _shimmer(child: _box(width: 32, height: 32, radius: 8)),
              const SizedBox(width: 10),
              // "Available Values" text
              _shimmer(child: _box(width: 110, height: 14, radius: 4)),
              const Spacer(),
              // Value Count Badge (e.g. 3)
              _shimmer(child: _box(width: 28, height: 24, radius: 12)),
              const SizedBox(width: 8),
              // Expand Arrow
              _shimmer(child: _box(width: 20, height: 20, radius: 4)),
            ],
          ),
          const SizedBox(height: 16),

          // ----- Value Rows (Like Brown, etc.) -----
          _buildValueRow(),
          const SizedBox(height: 10),
          _buildValueRow(),
        ],
      ),
    );
  }

  // ================= VALUE ROW (Inside Attribute Card) =================
  Widget _buildValueRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Light background for row items
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left Icon (Color circle etc.)
          _shimmer(child: _box(width: 24, height: 24, radius: 12)),
          const SizedBox(width: 12),

          // Value Name (Brown)
          Expanded(
            child: _shimmer(child: _box(width: 60, height: 14, radius: 4)),
          ),

          // Action Icons (Edit / Delete)
          _shimmer(child: _box(width: 28, height: 28, radius: 8)),
          const SizedBox(width: 8),
          _shimmer(child: _box(width: 28, height: 28, radius: 8)),
        ],
      ),
    );
  }

  // ================= GENERIC SHIMMER WRAPPER =================
  Widget _shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0), // Image ka light grey base
      highlightColor: const Color(0xFFF8FAFC),
      child: child,
    );
  }

  // ================= HELPER BOX =================
  Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
