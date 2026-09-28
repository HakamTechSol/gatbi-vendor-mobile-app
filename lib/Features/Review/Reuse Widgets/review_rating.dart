import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewRating extends StatelessWidget {
  const ReviewRating({
    super.key,
    required this.rating,
    this.showValue = true,
    this.starSize = 17,
    this.spacing = 2,
  });

  final double? rating;
  final bool showValue;
  final double starSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final value = rating ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStars(value),

        if (showValue) ...[
          const SizedBox(width: 7),

          Text(
            value.toStringAsFixed(1),
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStars(double value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final position = index + 1;

        IconData icon;

        if (value >= position) {
          icon = Icons.star_rounded;
        } else if (value >= position - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }

        return Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : spacing),
          child: Icon(icon, size: starSize, color: AppColors.warning),
        );
      }),
    );
  }
}
