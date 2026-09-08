import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class TicketLoading extends StatelessWidget {
  const TicketLoading({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const _TicketLoadingCard();
      },
    );
  }
}

class _TicketLoadingCard extends StatelessWidget {
  const _TicketLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 88, height: 25),
              Spacer(),
              _SkeletonBox(width: 72, height: 25),
            ],
          ),
          SizedBox(height: 14),
          _SkeletonBox(width: double.infinity, height: 18),
          SizedBox(height: 8),
          _SkeletonBox(width: 210, height: 18),
          SizedBox(height: 14),
          Row(
            children: [
              _SkeletonBox(width: 74, height: 24),
              SizedBox(width: 8),
              _SkeletonBox(width: 68, height: 24),
            ],
          ),
          SizedBox(height: 15),
          _SkeletonBox(width: 120, height: 14),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
