import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class CampaignDetailLoading extends StatelessWidget {
  const CampaignDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderLoading(),
        Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: const [
              _OverviewLoadingCard(),
              SizedBox(height: 14),
              _DiscountLoadingCard(),
              SizedBox(height: 14),
              _DateLoadingCard(),
              SizedBox(height: 14),
              _ProductsLoadingCard(),
              SizedBox(height: 14),
              _NotesLoadingCard(),
              SizedBox(height: 14),
              _TimelineLoadingCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderLoading extends StatelessWidget {
  const _HeaderLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _ShimmerBox(width: 42, height: 42, radius: 12),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 190, height: 17, radius: 6),
                  SizedBox(height: 8),
                  _ShimmerBox(width: 105, height: 12, radius: 5),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _ShimmerBox(width: 72, height: 30, radius: 999),
          ],
        ),
      ),
    );
  }
}

class _OverviewLoadingCard extends StatelessWidget {
  const _OverviewLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeaderLoading(),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _InfoLoading()),
              SizedBox(width: 12),
              Expanded(child: _InfoLoading()),
            ],
          ),
          SizedBox(height: 12),
          _ShimmerBox(width: double.infinity, height: 64, radius: 13),
        ],
      ),
    );
  }
}

class _DiscountLoadingCard extends StatelessWidget {
  const _DiscountLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingCard(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeaderLoading(),
          Spacer(),
          _ShimmerBox(width: 100, height: 38, radius: 8),
          SizedBox(height: 14),
          _ShimmerBox(width: double.infinity, height: 42, radius: 12),
        ],
      ),
    );
  }
}

class _DateLoadingCard extends StatelessWidget {
  const _DateLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeaderLoading(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 72,
                  radius: 14,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 72,
                  radius: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductsLoadingCard extends StatelessWidget {
  const _ProductsLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeaderLoading(),
          SizedBox(height: 18),
          _ShimmerBox(width: double.infinity, height: 60, radius: 13),
          SizedBox(height: 10),
          _ShimmerBox(width: double.infinity, height: 60, radius: 13),
          SizedBox(height: 10),
          _ShimmerBox(width: double.infinity, height: 60, radius: 13),
        ],
      ),
    );
  }
}

class _NotesLoadingCard extends StatelessWidget {
  const _NotesLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeaderLoading(),
          SizedBox(height: 18),
          _ShimmerBox(width: double.infinity, height: 78, radius: 14),
          SizedBox(height: 12),
          _ShimmerBox(width: double.infinity, height: 78, radius: 14),
        ],
      ),
    );
  }
}

class _TimelineLoadingCard extends StatelessWidget {
  const _TimelineLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const _LoadingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeaderLoading(),
          SizedBox(height: 20),
          _TimelineLoadingItem(),
          _TimelineLoadingItem(),
          _TimelineLoadingItem(),
          _TimelineLoadingItem(),
        ],
      ),
    );
  }
}

class _TimelineLoadingItem extends StatelessWidget {
  const _TimelineLoadingItem();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          _ShimmerBox(width: 34, height: 34, radius: 999),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 100, height: 14, radius: 5),
                SizedBox(height: 7),
                _ShimmerBox(width: 150, height: 11, radius: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeaderLoading extends StatelessWidget {
  const _CardHeaderLoading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ShimmerBox(width: 42, height: 42, radius: 12),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(width: 145, height: 15, radius: 5),
              SizedBox(height: 7),
              _ShimmerBox(width: 190, height: 11, radius: 5),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoLoading extends StatelessWidget {
  const _InfoLoading();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerBox(width: double.infinity, height: 64, radius: 13);
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.45,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: child);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
