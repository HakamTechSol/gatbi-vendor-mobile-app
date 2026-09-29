import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Theme/app_colors.dart';

class EventsLoading extends StatelessWidget {
  const EventsLoading({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: itemCount,
            separatorBuilder: (_, __) {
              return const SizedBox(height: 16);
            },
            itemBuilder: (_, __) {
              return _EventShimmerCard();
            },
          ),
        ),
      ),
    );
  }
}

class _EventShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            height: 155,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _box(width: 90, height: 12),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: _box(width: 220, height: 18),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerLeft,
                  child: _box(width: double.infinity, height: 12),
                ),

                const SizedBox(height: 6),

                Align(
                  alignment: Alignment.centerLeft,
                  child: _box(width: 180, height: 12),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    _box(width: 125, height: 34),
                    const SizedBox(width: 10),
                    _box(width: 140, height: 34),
                  ],
                ),

                const SizedBox(height: 16),

                _box(width: double.infinity, height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _box({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
