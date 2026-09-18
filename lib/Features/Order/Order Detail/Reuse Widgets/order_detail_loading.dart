import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Theme/app_colors.dart';

/// ===============================================================
/// ORDER DETAIL HEADER LOADING
/// ===============================================================

class OrderDetailHeaderLoading extends StatelessWidget {
  const OrderDetailHeaderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Row(
          children: [
            // Back button skeleton
            const _ShimmerBox(width: 42, height: 42, borderRadius: 12),

            const SizedBox(width: 12),

            // Title + order number
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 150, height: 16, borderRadius: 4),
                  SizedBox(height: 6),
                  _ShimmerBox(width: 90, height: 11, borderRadius: 4),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Pending chip skeleton
            const _ShimmerBox(width: 64, height: 26, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// ORDER DETAIL FULL PAGE LOADING
/// ===============================================================

class OrderDetailLoading extends StatelessWidget {
  const OrderDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      children: const [
        // 1. ORDER SUMMARY CARD
        _OrderSummaryShimmerCard(),

        SizedBox(height: 14),

        // 2. CUSTOMER INFORMATION CARD
        _CustomerInfoShimmerCard(),

        SizedBox(height: 14),

        // 3. SHIPPING ADDRESS CARD
        _ShippingAddressShimmerCard(),
      ],
    );
  }
}

/// ===============================================================
/// 1. ORDER SUMMARY SHIMMER CARD
/// ===============================================================
class _OrderSummaryShimmerCard extends StatelessWidget {
  const _OrderSummaryShimmerCard();

  @override
  Widget build(BuildContext context) {
    return _ShimmerCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title with Icon
          Row(
            children: const [
              _ShimmerBox(width: 18, height: 18, borderRadius: 4),
              SizedBox(width: 10),
              _ShimmerBox(width: 120, height: 14, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 16),

          // Date & Items Grid Boxes
          Row(
            children: const [
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 58,
                  borderRadius: 12,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 58,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Subtotal
          _buildRowSkeleton(width1: 60, width2: 70),
          const SizedBox(height: 10),

          // Shipping
          _buildRowSkeleton(width1: 55, width2: 65),
          const SizedBox(height: 10),

          // Tax
          _buildRowSkeleton(width1: 30, width2: 55),
          const SizedBox(height: 14),

          const _ShimmerBox(width: double.infinity, height: 1, borderRadius: 0),
          const SizedBox(height: 14),

          // Total
          _buildRowSkeleton(width1: 45, width2: 85, height: 16),
        ],
      ),
    );
  }

  static Widget _buildRowSkeleton({
    required double width1,
    required double width2,
    double height = 12,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerBox(width: width1, height: height, borderRadius: 4),
        _ShimmerBox(width: width2, height: height, borderRadius: 4),
      ],
    );
  }
}

/// ===============================================================
/// 2. CUSTOMER INFORMATION SHIMMER CARD
/// ===============================================================
class _CustomerInfoShimmerCard extends StatelessWidget {
  const _CustomerInfoShimmerCard();

  @override
  Widget build(BuildContext context) {
    return _ShimmerCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: const [
              _ShimmerBox(width: 18, height: 18, borderRadius: 4),
              SizedBox(width: 10),
              _ShimmerBox(width: 150, height: 14, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 16),

          // Avatar + Name
          Row(
            children: [
              const _ShimmerBox(width: 44, height: 44, borderRadius: 22),
              const SizedBox(width: 12),
              const _ShimmerBox(width: 130, height: 14, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 14),

          // Email
          Row(
            children: const [
              _ShimmerBox(width: 18, height: 18, borderRadius: 4),
              SizedBox(width: 10),
              _ShimmerBox(width: 180, height: 11, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// 3. SHIPPING ADDRESS SHIMMER CARD
/// ===============================================================
class _ShippingAddressShimmerCard extends StatelessWidget {
  const _ShippingAddressShimmerCard();

  @override
  Widget build(BuildContext context) {
    return _ShimmerCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title & Address Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  _ShimmerBox(width: 36, height: 36, borderRadius: 10),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(width: 120, height: 13, borderRadius: 4),
                      SizedBox(height: 4),
                      _ShimmerBox(width: 80, height: 10, borderRadius: 4),
                    ],
                  ),
                ],
              ),
              _ShimmerBox(width: 65, height: 22, borderRadius: 12),
            ],
          ),
          const SizedBox(height: 14),

          // Contact Person Info
          Row(
            children: [
              const _ShimmerBox(width: 36, height: 36, borderRadius: 8),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ShimmerBox(width: 90, height: 12, borderRadius: 4),
                  SizedBox(height: 5),
                  _ShimmerBox(width: 110, height: 10, borderRadius: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address Container Block
          const _ShimmerBox(
            width: double.infinity,
            height: 42,
            borderRadius: 10,
          ),
          const SizedBox(height: 12),

          // Bottom Tags Row
          Row(
            children: const [
              _ShimmerBox(width: 75, height: 26, borderRadius: 6),
              SizedBox(width: 8),
              _ShimmerBox(width: 70, height: 26, borderRadius: 6),
              SizedBox(width: 8),
              _ShimmerBox(width: 50, height: 26, borderRadius: 6),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// REUSABLE SHIMMER CARD WRAPPER
/// ===============================================================
class _ShimmerCardWrapper extends StatelessWidget {
  const _ShimmerCardWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: child,
      ),
    );
  }
}

/// ===============================================================
/// REUSABLE SHIMMER BOX
/// ===============================================================
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
