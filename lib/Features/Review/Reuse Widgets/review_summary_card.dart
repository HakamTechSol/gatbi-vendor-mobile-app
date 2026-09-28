import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Review Summary/Models/review_summary_model.dart';
import 'review_rating.dart';
import 'review_summary_item.dart';

class ReviewSummaryCard extends StatelessWidget {
  const ReviewSummaryCard({super.key, required this.summary});

  // ===========================================================================
  // Fields
  // ===========================================================================

  final ReviewSummaryModel summary;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _buildMainRating(),
            const SizedBox(height: 18),
            _buildMetrics(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 18),
            _buildBreakdown(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Header
  // ===========================================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.star_rounded, color: AppColors.warning, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review Summary',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Overview of your customer feedback',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Main Rating
  // ===========================================================================

  Widget _buildMainRating() {
    final averageRating = _averageRating;
    final totalReviews = _totalReviews;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        children: [
          // -------------------------------------------------------------------
          // Average Rating
          // -------------------------------------------------------------------
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'out of 5',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          // -------------------------------------------------------------------
          // Rating Details
          // -------------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewRating(
                  rating: averageRating,
                  showValue: false,
                  starSize: 18,
                  spacing: 2,
                ),
                const SizedBox(height: 6),
                Text(
                  _ratingMessage(averageRating),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'} received',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Metrics
  // ===========================================================================

  Widget _buildMetrics() {
    return Row(
      children: [
        ReviewSummaryItem(
          title: 'Total',
          value: _totalReviews.toString(),
          iconBackgroundColor: AppColors.primaryLight,
        ),
        const SizedBox(width: 10),
        ReviewSummaryItem(
          title: 'Approved',
          value: _approvedReviews.toString(),
          iconBackgroundColor: AppColors.successLight,
        ),
        const SizedBox(width: 10),
        ReviewSummaryItem(
          title: 'Pending',
          value: _pendingReviews.toString(),
          iconBackgroundColor: AppColors.warningLight,
        ),
      ],
    );
  }

  // ===========================================================================
  // Divider
  // ===========================================================================

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }

  // ===========================================================================
  // Rating Breakdown
  // ===========================================================================

  Widget _buildBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating Breakdown',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(5, (index) {
          final rating = 5 - index;
          final count = _ratingCount(rating);
          final percentage = _ratingPercentage(count);

          return Padding(
            padding: EdgeInsets.only(bottom: rating == 1 ? 0 : 9),
            child: _buildRatingRow(
              rating: rating,
              count: count,
              percentage: percentage,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRatingRow({
    required int rating,
    required int count,
    required double percentage,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Row(
            children: [
              Text(
                '$rating',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 3),
              Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: percentage,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 25,
          child: Text(
            count.toString(),
            textAlign: TextAlign.end,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Safe Summary Values
  // ===========================================================================

  double get _averageRating {
    final value = summary.summary?.averageRating;

    if (value == null) {
      return 0;
    }

    return value.toDouble().clamp(0.0, 5.0);
  }

  int get _totalReviews {
    return summary.summary?.totalReviews ?? 0;
  }

  int get _approvedReviews {
    return summary.summary?.approvedReviews ?? 0;
  }

  int get _pendingReviews {
    return summary.summary?.pendingReviews ?? 0;
  }

  // ===========================================================================
  // Rating Breakdown Helpers
  // ===========================================================================

  int _ratingCount(int rating) {
    final breakdown = summary.summary?.ratingBreakdown;

    if (breakdown == null) {
      return 0;
    }

    final value = breakdown[rating.toString()];

    if (value == null) {
      return 0;
    }

    return value;
  }

  double _ratingPercentage(int count) {
    if (_totalReviews <= 0 || count <= 0) {
      return 0;
    }

    return (count / _totalReviews).clamp(0.0, 1.0);
  }

  // ===========================================================================
  // Rating Message
  // ===========================================================================

  String _ratingMessage(double rating) {
    if (rating >= 4.5) {
      return 'Excellent customer feedback';
    }

    if (rating >= 4.0) {
      return 'Very positive customer feedback';
    }

    if (rating >= 3.0) {
      return 'Good customer feedback';
    }

    if (rating >= 2.0) {
      return 'Mixed customer feedback';
    }

    if (rating > 0) {
      return 'Customer feedback needs attention';
    }

    return 'No ratings available yet';
  }
}
