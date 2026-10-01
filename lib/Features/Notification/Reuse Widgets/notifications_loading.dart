import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsLoading extends StatelessWidget {
  const NotificationsLoading({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final count = itemCount < 1 ? 1 : itemCount;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ────────────────────────────────────────────────
          // 1. HEADER: Back button + "Notifications" + subtitle
          // ────────────────────────────────────────────────
          _buildHeader(),

          const SizedBox(height: 20),

          // ────────────────────────────────────────────────
          // 2. FILTER CHIPS: All (active) + Read + Unread
          // ────────────────────────────────────────────────
          _buildFilters(),

          const SizedBox(height: 18),

          // ────────────────────────────────────────────────
          // 3. NOTIFICATION CARDS
          // ────────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: count,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => _buildNotificationCard(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. HEADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _shimmer(child: _box(width: 46, height: 46, radius: 12)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmer(child: _box(width: 160, height: 24, radius: 6)),
              const SizedBox(height: 8),
              _shimmer(child: _box(width: 240, height: 13, radius: 5)),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. FILTER CHIPS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          // "All" — active filter (filled circle)
          _shimmer(child: _box(width: 65, height: 40, radius: 20)),
          const SizedBox(width: 10),
          // "Read"
          _shimmer(child: _box(width: 75, height: 40, radius: 20)),
          const SizedBox(width: 10),
          // "Unread"
          _shimmer(child: _box(width: 85, height: 40, radius: 20)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. NOTIFICATION CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildNotificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────────────────────
          // LEFT: Icon Box (rounded square)
          // ─────────────────────────────────────────────
          _shimmer(child: _box(width: 46, height: 46, radius: 12)),

          const SizedBox(width: 12),

          // ─────────────────────────────────────────────
          // RIGHT: Content (Title + Description + Bottom row)
          // ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (e.g. "Profile Updated")
                _shimmer(child: _box(width: 150, height: 15, radius: 5)),

                const SizedBox(height: 10),

                // Description line 1 (full width)
                _shimmer(
                  child: _box(width: double.infinity, height: 12, radius: 4),
                ),

                const SizedBox(height: 7),

                // Description line 2 (partial)
                _shimmer(child: _box(width: 200, height: 12, radius: 4)),

                const SizedBox(height: 12),

                // Bottom row: "Security" + • + "1 hour ago"
                Row(
                  children: [
                    // Category label ("Security")
                    _shimmer(child: _box(width: 60, height: 11, radius: 4)),
                    const SizedBox(width: 8),
                    // Bullet dot
                    _shimmer(child: _box(width: 4, height: 4, radius: 2)),
                    const SizedBox(width: 8),
                    // Time ("1 hour ago")
                    _shimmer(child: _box(width: 65, height: 11, radius: 4)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHIMMER WRAPPER (per-box shimmer — Campaigns pattern)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: child,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOX HELPER
  // ═══════════════════════════════════════════════════════════════════════════
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
