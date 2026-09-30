// lib/features/events/presentation/widgets/events_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Theme/app_colors.dart';

class EventsLoading extends StatelessWidget {
  const EventsLoading({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // 1. HEADER (Back button + "Events" + subtitle + right icon)
              // ============================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmer(child: _box(width: 46, height: 46, radius: 12)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmer(child: _box(width: 90, height: 22, radius: 6)),
                        const SizedBox(height: 8),
                        _shimmer(
                          child: _box(width: 220, height: 13, radius: 5),
                        ),
                        const SizedBox(height: 5),
                        _shimmer(
                          child: _box(width: 180, height: 13, radius: 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _shimmer(child: _box(width: 46, height: 46, radius: 12)),
                ],
              ),
              const SizedBox(height: 20),

              // ============================================================
              // 2. GROW CARD (Purple gradient "Grow with special events")
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmer(
                            child: _box(width: 200, height: 18, radius: 6),
                          ),
                          const SizedBox(height: 12),
                          _shimmer(
                            child: _box(
                              width: double.infinity,
                              height: 12,
                              radius: 5,
                            ),
                          ),
                          const SizedBox(height: 7),
                          _shimmer(
                            child: _box(width: 210, height: 12, radius: 5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Rocket icon box
                    _shimmer(child: _box(width: 52, height: 52, radius: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ============================================================
              // 3. SECTION HEADER ("Available events" + count)
              // ============================================================
              _shimmer(child: _box(width: 165, height: 20, radius: 6)),
              const SizedBox(height: 8),
              _shimmer(child: _box(width: 130, height: 12, radius: 5)),
              const SizedBox(height: 16),

              // ============================================================
              // 4. EVENT CARDS LIST
              // ============================================================
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildEventCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EVENT CARD (Exact UI structure — Banner + Body + Buttons)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildEventCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // BANNER (Full-width event banner placeholder)
            // =========================================================
            _shimmer(
              child: _box(width: double.infinity, height: 160, radius: 0),
            ),

            // =========================================================
            // CARD BODY
            // =========================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------------------------------------
                  // Row 1: "Vendor Event" (left) + "● Open" badge (right)
                  // -------------------------------------------------
                  Row(
                    children: [
                      _shimmer(child: _box(width: 90, height: 14, radius: 5)),
                      const Spacer(),
                      Row(
                        children: [
                          _shimmer(child: _box(width: 8, height: 8, radius: 4)),
                          const SizedBox(width: 6),
                          _shimmer(
                            child: _box(width: 42, height: 14, radius: 5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // -------------------------------------------------
                  // Title: "Sale Event"
                  // -------------------------------------------------
                  _shimmer(child: _box(width: 150, height: 22, radius: 6)),
                  const SizedBox(height: 10),

                  // -------------------------------------------------
                  // Description: "Sale Event For Vender"
                  // -------------------------------------------------
                  _shimmer(
                    child: _box(width: double.infinity, height: 13, radius: 5),
                  ),
                  const SizedBox(height: 16),

                  // -------------------------------------------------
                  // Info Pills: Date + Discount
                  // -------------------------------------------------
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _shimmer(child: _box(width: 200, height: 34, radius: 9)),
                      _shimmer(child: _box(width: 140, height: 34, radius: 9)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // -------------------------------------------------
                  // Action Buttons Row
                  // -------------------------------------------------
                  Row(
                    children: [
                      Expanded(
                        child: _shimmer(
                          child: _box(
                            width: double.infinity,
                            height: 48,
                            radius: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _shimmer(
                          child: _box(
                            width: double.infinity,
                            height: 48,
                            radius: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
  // BOX HELPER (Basic shape for shimmer)
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
