import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class QuestionLoading extends StatefulWidget {
  const QuestionLoading({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  State<QuestionLoading> createState() => _QuestionLoadingState();
}

class _QuestionLoadingState extends State<QuestionLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.itemCount < 1 ? 1 : widget.itemCount;

    return Column(children: List.generate(count, (index) => _buildCard()));
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final opacity = 0.45 + (_animationController.value * 0.35);

        return Opacity(opacity: opacity, child: child);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _buildTopAccent(),
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductSkeleton(),
                  const SizedBox(height: 14),
                  _buildDivider(),
                  const SizedBox(height: 14),
                  _buildCustomerSkeleton(),
                  const SizedBox(height: 13),
                  _buildStatusSkeleton(),
                  const SizedBox(height: 13),
                  _buildQuestionSkeleton(),
                  const SizedBox(height: 13),
                  _buildAnswerSkeleton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAccent() {
    return Container(
      height: 4,
      width: double.infinity,
      color: AppColors.border,
    );
  }

  Widget _buildProductSkeleton() {
    return Row(
      children: [
        _buildSkeletonBox(width: 52, height: 52, radius: 14),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonBox(width: 55, height: 10, radius: 5),
              const SizedBox(height: 7),
              _buildSkeletonBox(width: double.infinity, height: 13, radius: 6),
              const SizedBox(height: 6),
              _buildSkeletonBox(width: 70, height: 9, radius: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSkeleton() {
    return Row(
      children: [
        _buildSkeletonBox(width: 42, height: 42, radius: 21),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonBox(width: 120, height: 12, radius: 6),
              const SizedBox(height: 7),
              _buildSkeletonBox(width: 145, height: 9, radius: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSkeleton() {
    return Row(
      children: [
        _buildSkeletonBox(width: 45, height: 10, radius: 5),
        const Spacer(),
        _buildSkeletonBox(width: 105, height: 28, radius: 14),
      ],
    );
  }

  Widget _buildQuestionSkeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBox(width: 34, height: 34, radius: 10),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(width: 115, height: 10, radius: 5),
                const SizedBox(height: 8),
                _buildSkeletonBox(
                  width: double.infinity,
                  height: 11,
                  radius: 5,
                ),
                const SizedBox(height: 6),
                _buildSkeletonBox(width: 180, height: 11, radius: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSkeleton() {
    return Container(
      width: double.infinity,
      height: 105,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSkeletonBox(width: 32, height: 32, radius: 9),
              const SizedBox(width: 9),
              _buildSkeletonBox(width: 110, height: 11, radius: 5),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildSkeletonBox(
              width: double.infinity,
              height: double.infinity,
              radius: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: AppColors.border);
  }

  Widget _buildSkeletonBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
