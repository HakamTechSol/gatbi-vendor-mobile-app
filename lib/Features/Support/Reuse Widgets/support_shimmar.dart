import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';

/// ============================================================
/// Support Screen Full Shimmer
/// ============================================================

class SupportScreenShimmer extends StatelessWidget {
  const SupportScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: const [
        // ========================================================
        // Header
        // ========================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
          sliver: SliverToBoxAdapter(child: SupportHeaderShimmer()),
        ),

        // ========================================================
        // Quick Actions
        // ========================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
          sliver: SliverToBoxAdapter(child: SupportQuickActionsShimmer()),
        ),

        // ========================================================
        // Quick Help
        // ========================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(child: SupportQuickHelpShimmer()),
        ),

        // ========================================================
        // Payments
        // ========================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(child: SupportPaymentsShimmer()),
        ),

        // ========================================================
        // Contact
        // ========================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
          sliver: SliverToBoxAdapter(child: SupportContactShimmer()),
        ),

        // ========================================================
        // Ticket
        // ========================================================
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 30),
          sliver: SliverToBoxAdapter(child: SupportTicketShimmer()),
        ),
      ],
    );
  }
}

/// ============================================================
/// Shimmer Base Box
/// ============================================================

class SupportShimmerBox extends StatelessWidget {
  const SupportShimmerBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 7,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// ============================================================
/// Header Shimmer
/// ============================================================

class SupportHeaderShimmer extends StatelessWidget {
  const SupportHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SupportShimmerBox(width: 44, height: 44, radius: 13),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SupportShimmerBox(width: 120, height: 17, radius: 6),

              SizedBox(height: 7),

              SupportShimmerBox(width: 190, height: 11, radius: 5),
            ],
          ),
        ),
      ],
    );
  }
}

/// ============================================================
/// Quick Actions Shimmer
/// ============================================================

class SupportQuickActionsShimmer extends StatelessWidget {
  const SupportQuickActionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 178,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: SupportQuickActionShimmerCard()),

          SizedBox(width: 12),

          Expanded(child: SupportQuickActionShimmerCard()),
        ],
      ),
    );
  }
}

/// ============================================================
/// Quick Action Card Shimmer
/// ============================================================

class SupportQuickActionShimmerCard extends StatelessWidget {
  const SupportQuickActionShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupportShimmerBox(width: 46, height: 46, radius: 13),

          Spacer(),

          SupportShimmerBox(width: 105, height: 14),

          SizedBox(height: 9),

          SupportShimmerBox(width: double.infinity, height: 10),

          SizedBox(height: 6),

          SupportShimmerBox(width: 90, height: 10),
        ],
      ),
    );
  }
}

/// ============================================================
/// Quick Help Shimmer
/// ============================================================

class SupportQuickHelpShimmer extends StatelessWidget {
  const SupportQuickHelpShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SupportShimmerBox(width: 100, height: 16),

        SizedBox(height: 8),

        SupportShimmerBox(width: 240, height: 11),

        SizedBox(height: 16),

        SupportHelpShimmerItem(),
        SupportHelpShimmerItem(),
        SupportHelpShimmerItem(),
      ],
    );
  }
}

/// ============================================================
/// Quick Help Item Shimmer
/// ============================================================

class SupportHelpShimmerItem extends StatelessWidget {
  const SupportHelpShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SupportShimmerBox(width: 42, height: 42, radius: 12),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SupportShimmerBox(width: 120, height: 13),

                  SizedBox(height: 8),

                  SupportShimmerBox(width: double.infinity, height: 10),

                  SizedBox(height: 5),

                  SupportShimmerBox(width: 150, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// Payments Shimmer
/// ============================================================

class SupportPaymentsShimmer extends StatelessWidget {
  const SupportPaymentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SupportShimmerBox(width: 44, height: 44, radius: 13),

              SizedBox(width: 12),

              SupportShimmerBox(width: 145, height: 15),
            ],
          ),

          const SizedBox(height: 16),

          const SupportShimmerBox(width: double.infinity, height: 11),

          const SizedBox(height: 7),

          const SupportShimmerBox(width: 280, height: 11),

          const SizedBox(height: 16),

          Container(
            height: 58,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// Contact Shimmer
/// ============================================================

class SupportContactShimmer extends StatelessWidget {
  const SupportContactShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SupportShimmerBox(width: 44, height: 44, radius: 13),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SupportShimmerBox(width: 130, height: 15),

                    SizedBox(height: 8),

                    SupportShimmerBox(width: 190, height: 10),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const SupportContactShimmerRow(),
          const SupportContactShimmerRow(),
          const SupportContactShimmerRow(),

          const SizedBox(height: 4),

          const SupportShimmerBox(width: 180, height: 10),
        ],
      ),
    );
  }
}

/// ============================================================
/// Contact Row Shimmer
/// ============================================================

class SupportContactShimmerRow extends StatelessWidget {
  const SupportContactShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// ============================================================
/// Ticket Shimmer
/// ============================================================

class SupportTicketShimmer extends StatelessWidget {
  const SupportTicketShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SupportShimmerBox(width: 46, height: 46, radius: 13),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SupportShimmerBox(width: 120, height: 14),

                SizedBox(height: 8),

                SupportShimmerBox(width: double.infinity, height: 10),

                SizedBox(height: 5),

                SupportShimmerBox(width: 170, height: 10),
              ],
            ),
          ),

          const SizedBox(width: 12),

          const SupportShimmerBox(width: 42, height: 42, radius: 11),
        ],
      ),
    );
  }
}
