// lib/features/profile/presentation/widgets/vendor_profile_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class VendorProfileLoading extends StatelessWidget {
  const VendorProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ══════════════════════════════════════════════════════════════
          // 1. HERO CARD (Purple gradient with avatar, name, email, badge)
          // ══════════════════════════════════════════════════════════════
          _buildHeroCard(),

          const SizedBox(height: 16),

          // ══════════════════════════════════════════════════════════════
          // 2. BUSINESS INFORMATION CARD
          // ══════════════════════════════════════════════════════════════
          _buildBusinessInfoCard(),

          const SizedBox(height: 16),

          // ══════════════════════════════════════════════════════════════
          // 3. ABOUT BUSINESS CARD
          // ══════════════════════════════════════════════════════════════
          _buildAboutCard(),

          const SizedBox(height: 16),

          // ══════════════════════════════════════════════════════════════
          // 4. WAREHOUSE / ADDITIONAL CARD
          // ══════════════════════════════════════════════════════════════
          _buildWarehouseCard(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. HERO CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // ───────────── Avatar (circular) ─────────────
          _shimmer(child: _circleBox(size: 90)),

          const SizedBox(height: 16),

          // ───────────── Name ("Beauty") ─────────────
          _shimmer(child: _box(width: 130, height: 26, radius: 8)),

          const SizedBox(height: 12),

          // ───────────── Email Row (icon + text) ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shimmer(child: _box(width: 16, height: 16, radius: 4)),
              const SizedBox(width: 8),
              _shimmer(child: _box(width: 210, height: 13, radius: 4)),
            ],
          ),

          const SizedBox(height: 16),

          // ───────────── "Approved" Badge (pill) ─────────────
          _shimmer(child: _box(width: 120, height: 32, radius: 16)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. BUSINESS INFORMATION CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBusinessInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────────── Header Row: Icon + Title + Subtitle ─────────────
          Row(
            children: [
              _shimmer(child: _box(width: 44, height: 44, radius: 12)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmer(child: _box(width: 160, height: 18, radius: 5)),
                    const SizedBox(height: 6),
                    _shimmer(child: _box(width: 210, height: 12, radius: 4)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ───────────── Row 1: Email Address ─────────────
          _buildInfoRow(iconSize: 44, labelWidth: 100, valueWidth: 240),

          const SizedBox(height: 18),

          // ───────────── Row 2: Phone Number ─────────────
          _buildInfoRow(iconSize: 44, labelWidth: 100, valueWidth: 170),

          const SizedBox(height: 18),

          // ───────────── Row 3: Account Status ─────────────
          _buildInfoRow(iconSize: 44, labelWidth: 110, valueWidth: 100),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INFO ROW (Icon + Label + Value)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildInfoRow({
    required double iconSize,
    required double labelWidth,
    required double valueWidth,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _shimmer(
          child: _box(width: iconSize, height: iconSize, radius: 12),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label (e.g., "Email Address")
              _shimmer(child: _box(width: labelWidth, height: 12, radius: 4)),
              const SizedBox(height: 8),
              // Value (e.g., "samamarashid58...")
              _shimmer(child: _box(width: valueWidth, height: 16, radius: 5)),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. ABOUT BUSINESS CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildAboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────────── Header Row: Icon + Title + Subtitle ─────────────
          Row(
            children: [
              _shimmer(child: _box(width: 44, height: 44, radius: 12)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmer(child: _box(width: 140, height: 18, radius: 5)),
                    const SizedBox(height: 6),
                    _shimmer(child: _box(width: 150, height: 12, radius: 4)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ───────────── Description box (grey rounded card) ─────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(
                  child: _box(width: double.infinity, height: 13, radius: 4),
                ),
                const SizedBox(height: 10),
                _shimmer(child: _box(width: 220, height: 13, radius: 4)),
                const SizedBox(height: 10),
                _shimmer(child: _box(width: 180, height: 13, radius: 4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. WAREHOUSE / ADDITIONAL CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildWarehouseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _shimmer(child: _box(width: 44, height: 44, radius: 12)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmer(child: _box(width: 150, height: 18, radius: 5)),
                    const SizedBox(height: 6),
                    _shimmer(child: _box(width: 170, height: 12, radius: 4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _shimmer(child: _box(width: double.infinity, height: 13, radius: 4)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHIMMER WRAPPER (CampaignsLoading pattern — per-box shimmer)
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

  // ═══════════════════════════════════════════════════════════════════════════
  // CIRCLE BOX HELPER (For avatar)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _circleBox({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
    );
  }
}
