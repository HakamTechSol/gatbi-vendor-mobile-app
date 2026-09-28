import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class PayoutDetailShimmerScreen extends StatefulWidget {
  const PayoutDetailShimmerScreen({super.key});

  @override
  State<PayoutDetailShimmerScreen> createState() =>
      _PayoutDetailShimmerScreenState();
}

class _PayoutDetailShimmerScreenState extends State<PayoutDetailShimmerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildSummaryCard()),
                SliverToBoxAdapter(child: _buildInformationCard()),
                SliverToBoxAdapter(child: _buildPeriodCard()),
                SliverToBoxAdapter(child: _buildFinancialCard()),
                SliverToBoxAdapter(child: _buildItemsCard()),
                SliverToBoxAdapter(child: _buildTimelineCard()),
                SliverToBoxAdapter(child: _buildNotesCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Row(
        children: [
          _shimmerBox(width: 44, height: 44, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 145, height: 17, radius: 5),
                const SizedBox(height: 7),
                _shimmerBox(width: 190, height: 12, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary
  // ---------------------------------------------------------------------------

  Widget _buildSummaryCard() {
    return Container(
      height: 165,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _shimmerBox(width: 105, height: 11, radius: 4),
          const SizedBox(height: 14),
          _shimmerBox(width: 175, height: 32, radius: 7),
          const SizedBox(height: 14),
          _shimmerBox(width: 82, height: 28, radius: 20),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Information
  // ---------------------------------------------------------------------------

  Widget _buildInformationCard() {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(width: 150),
          const SizedBox(height: 18),
          _buildInfoSkeleton(),
          _buildSkeletonDivider(),
          _buildInfoSkeleton(),
          _buildSkeletonDivider(),
          _buildInfoSkeleton(),
        ],
      ),
    );
  }

  Widget _buildInfoSkeleton() {
    return Row(
      children: [
        _shimmerBox(width: 34, height: 34, radius: 9),
        const SizedBox(width: 11),
        Expanded(child: _shimmerBox(width: 100, height: 12, radius: 4)),
        const SizedBox(width: 20),
        _shimmerBox(width: 95, height: 13, radius: 4),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Period
  // ---------------------------------------------------------------------------

  Widget _buildPeriodCard() {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(width: 120),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _dateSkeleton()),
              const SizedBox(width: 10),
              _shimmerBox(width: 30, height: 30, radius: 20),
              const SizedBox(width: 10),
              Expanded(child: _dateSkeleton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateSkeleton() {
    return Container(
      height: 74,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _shimmerBox(width: 70, height: 9, radius: 3),
          const SizedBox(height: 9),
          _shimmerBox(width: 95, height: 13, radius: 4),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Financial Summary
  // ---------------------------------------------------------------------------

  Widget _buildFinancialCard() {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(width: 145),
          const SizedBox(height: 18),
          _buildFinancialSkeleton(),
          _buildSkeletonDivider(),
          _buildFinancialSkeleton(),
          _buildSkeletonDivider(),
          _buildFinancialSkeleton(),
          _buildSkeletonDivider(),
          Container(
            height: 64,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                _shimmerBox(width: 38, height: 38, radius: 10),
                const SizedBox(width: 11),
                Expanded(child: _shimmerBox(width: 110, height: 13, radius: 4)),
                _shimmerBox(width: 85, height: 15, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSkeleton() {
    return Row(
      children: [
        _shimmerBox(width: 34, height: 34, radius: 9),
        const SizedBox(width: 11),
        Expanded(child: _shimmerBox(width: 90, height: 12, radius: 4)),
        _shimmerBox(width: 78, height: 13, radius: 4),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Items
  // ---------------------------------------------------------------------------

  Widget _buildItemsCard() {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSectionTitle(width: 125),
              const Spacer(),
              _shimmerBox(width: 32, height: 26, radius: 20),
            ],
          ),
          const SizedBox(height: 16),
          _itemSkeleton(),
          const SizedBox(height: 10),
          _itemSkeleton(),
        ],
      ),
    );
  }

  Widget _itemSkeleton() {
    return Container(
      height: 142,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _shimmerBox(width: 30, height: 30, radius: 9),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 40, height: 8, radius: 3),
                    const SizedBox(height: 5),
                    _shimmerBox(width: 165, height: 12, radius: 4),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          _shimmerBox(width: double.infinity, height: 10, radius: 4),
          const SizedBox(height: 9),
          _shimmerBox(width: double.infinity, height: 10, radius: 4),
          const SizedBox(height: 9),
          _shimmerBox(width: double.infinity, height: 10, radius: 4),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Timeline
  // ---------------------------------------------------------------------------

  Widget _buildTimelineCard() {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(width: 125),
          const SizedBox(height: 20),
          _timelineSkeleton(),
          _timelineSkeleton(),
          _timelineSkeleton(),
        ],
      ),
    );
  }

  Widget _timelineSkeleton() {
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(width: 24, height: 24, radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 75, height: 12, radius: 4),
                const SizedBox(height: 7),
                _shimmerBox(width: 150, height: 10, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Notes
  // ---------------------------------------------------------------------------

  Widget _buildNotesCard() {
    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(width: 55),
          const SizedBox(height: 16),
          Container(
            height: 76,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _shimmerBox(width: double.infinity, height: 10, radius: 4),
                const SizedBox(height: 9),
                _shimmerBox(width: 210, height: 10, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Common Card
  // ---------------------------------------------------------------------------

  Widget _cardShell({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle({required double width}) {
    return _shimmerBox(width: width, height: 16, radius: 5);
  }

  Widget _buildSkeletonDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Divider(height: 1, thickness: 1, color: AppColors.divider),
    );
  }

  // ---------------------------------------------------------------------------
  // Shimmer Box
  // ---------------------------------------------------------------------------

  Widget _shimmerBox({
    required double width,
    required double height,
    required double radius,
  }) {
    final value = _controller.value;

    final shimmerProgress = (value * 2) % 1;

    final baseColor = Color.lerp(
      AppColors.shimmerBase,
      AppColors.shimmerHighlight,
      shimmerProgress,
    )!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
