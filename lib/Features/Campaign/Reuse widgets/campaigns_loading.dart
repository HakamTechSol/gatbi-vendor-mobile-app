import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CampaignsLoading extends StatelessWidget {
  const CampaignsLoading({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= TOP HEADER (Back Button + Title) =================
              Row(
                children: [
                  _shimmer(child: _box(width: 44, height: 44, radius: 12)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmer(child: _box(width: 110, height: 20, radius: 4)),
                      const SizedBox(height: 6),
                      _shimmer(child: _box(width: 220, height: 12, radius: 4)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ================= ACTION BUTTONS (Pick Products & Request Campaign) =================
              _shimmer(
                child: _box(width: double.infinity, height: 48, radius: 12),
              ),
              const SizedBox(height: 10),
              _shimmer(
                child: _box(width: double.infinity, height: 48, radius: 12),
              ),
              const SizedBox(height: 24),

              // ================= SECTION TITLE ("Your campaigns") =================
              _shimmer(child: _box(width: 140, height: 18, radius: 4)),
              const SizedBox(height: 6),
              _shimmer(child: _box(width: 80, height: 12, radius: 4)),
              const SizedBox(height: 16),

              // ================= FILTER CHIPS (Horizontal Row) =================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: [
                    _shimmer(child: _box(width: 65, height: 36, radius: 20)),
                    const SizedBox(width: 8),
                    _shimmer(child: _box(width: 80, height: 36, radius: 20)),
                    const SizedBox(width: 8),
                    _shimmer(child: _box(width: 90, height: 36, radius: 20)),
                    const SizedBox(width: 8),
                    _shimmer(child: _box(width: 75, height: 36, radius: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ================= CAMPAIGN CARDS LIST =================
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildCampaignCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Exact Campaign Card Structure Matching Provided UI Image
  Widget _buildCampaignCard() {
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
          // Header Row: Megaphone Icon + Category Tag + Pending Review Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _shimmer(child: _box(width: 40, height: 40, radius: 10)),
                  const SizedBox(width: 10),
                  _shimmer(child: _box(width: 80, height: 12, radius: 4)),
                ],
              ),
              _shimmer(child: _box(width: 105, height: 26, radius: 14)),
            ],
          ),
          const SizedBox(height: 14),

          // Campaign Title & Subtitle Placeholder
          _shimmer(child: _box(width: 230, height: 18, radius: 4)),
          const SizedBox(height: 8),
          _shimmer(child: _box(width: 100, height: 13, radius: 4)),
          const SizedBox(height: 16),

          // Metadata Row (Products + Date Range Placeholders)
          Row(
            children: [
              _shimmer(child: _box(width: 75, height: 14, radius: 4)),
              const SizedBox(width: 12),
              _shimmer(child: _box(width: 85, height: 14, radius: 4)),
              const SizedBox(width: 12),
              _shimmer(child: _box(width: 85, height: 14, radius: 4)),
            ],
          ),
          const SizedBox(height: 14),

          // Bottom Input / Note Box
          _shimmer(child: _box(width: double.infinity, height: 42, radius: 10)),
        ],
      ),
    );
  }

  // Generic Package Wrapper for Shimmer Effect
  Widget _shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: child,
    );
  }

  // Helper Widget for Shimmer Boxes
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
