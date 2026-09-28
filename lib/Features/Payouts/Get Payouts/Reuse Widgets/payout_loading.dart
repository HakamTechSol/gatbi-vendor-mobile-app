import 'package:flutter/material.dart';
import '../../../../Theme/app_colors.dart';

class PayoutLoading extends StatefulWidget {
  const PayoutLoading({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  State<PayoutLoading> createState() => _PayoutLoadingState();
}

class _PayoutLoadingState extends State<PayoutLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = Tween<double>(
      begin: -1.2,
      end: 2.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  _shimmerWrapper(
                    child: _box(width: 44, height: 44, radius: 12),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerWrapper(
                        child: _box(width: 120, height: 18, radius: 5),
                      ),
                      const SizedBox(height: 6),
                      _shimmerWrapper(
                        child: _box(width: 180, height: 12, radius: 4),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ================= REQUEST BUTTON =================
              _shimmerWrapper(
                child: _box(width: double.infinity, height: 48, radius: 12),
              ),
              const SizedBox(height: 16),

              // ================= FILTER CHIPS (Horizontal Row) =================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: [
                    _shimmerWrapper(
                      child: _box(width: 50, height: 32, radius: 20),
                    ),
                    const SizedBox(width: 8),
                    _shimmerWrapper(
                      child: _box(width: 75, height: 32, radius: 20),
                    ),
                    const SizedBox(width: 8),
                    _shimmerWrapper(
                      child: _box(width: 85, height: 32, radius: 20),
                    ),
                    const SizedBox(width: 8),
                    _shimmerWrapper(
                      child: _box(width: 60, height: 32, radius: 20),
                    ),
                    const SizedBox(width: 8),
                    _shimmerWrapper(
                      child: _box(width: 70, height: 32, radius: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ================= 2 PAYOUT CARDS LIST =================
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.itemCount, // Default set to 2 cards
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildPayoutCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Exact Payout Card Structure Matching UI
  Widget _buildPayoutCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Yellow Indicator Bar Placeholder
              _shimmerWrapper(
                child: Container(
                  width: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Payout ID & Status Badge Placeholder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerWrapper(
                                child: _box(width: 50, height: 10, radius: 3),
                              ),
                              const SizedBox(height: 6),
                              _shimmerWrapper(
                                child: _box(width: 150, height: 16, radius: 4),
                              ),
                            ],
                          ),
                          // Status Badge Placeholder
                          _shimmerWrapper(
                            child: _box(width: 65, height: 26, radius: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Inner Amount Card Box Placeholder
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            // Icon Box Placeholder
                            _shimmerWrapper(
                              child: _box(width: 40, height: 40, radius: 10),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _shimmerWrapper(
                                    child: _box(
                                      width: 90,
                                      height: 10,
                                      radius: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  _shimmerWrapper(
                                    child: _box(
                                      width: 110,
                                      height: 18,
                                      radius: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _shimmerWrapper(
                              child: _box(width: 32, height: 12, radius: 3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Payment Method Line Placeholder
                      Row(
                        children: [
                          _shimmerWrapper(
                            child: _box(width: 16, height: 16, radius: 4),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerWrapper(
                                child: _box(width: 90, height: 10, radius: 3),
                              ),
                              const SizedBox(height: 4),
                              _shimmerWrapper(
                                child: _box(width: 110, height: 14, radius: 4),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Created Date Line Placeholder
                      Row(
                        children: [
                          _shimmerWrapper(
                            child: _box(width: 16, height: 16, radius: 4),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerWrapper(
                                child: _box(width: 60, height: 10, radius: 3),
                              ),
                              const SizedBox(height: 4),
                              _shimmerWrapper(
                                child: _box(width: 130, height: 14, radius: 4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer Effect Wrapper
  Widget _shimmerWrapper({required Widget child}) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, shimmerChild) {
                return FractionallySizedBox(
                  widthFactor: 0.45,
                  alignment: Alignment(_animation.value, 0),
                  child: shimmerChild,
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.shimmerBase.withValues(alpha: 0),
                      AppColors.shimmerHighlight.withValues(alpha: 0.75),
                      AppColors.shimmerBase.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widget for Shimmer Rectangles
  Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
