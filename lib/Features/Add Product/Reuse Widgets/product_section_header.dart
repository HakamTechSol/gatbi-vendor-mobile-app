import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class ProductSectionHeader extends StatelessWidget {
  const ProductSectionHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
  });

  final String title;
  final String? description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        // Small screens par title aur button vertically show honge.
        final bool isSmallScreen = width < 600;

        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(),

              if (trailing != null) ...[
                const SizedBox(height: 14),

                SizedBox(width: double.infinity, child: trailing!),
              ],
            ],
          );
        }

        // Tablet/Desktop
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTitleSection()),

            if (trailing != null) ...[
              const SizedBox(width: 16),

              // Important:
              // trailing ko finite width dena zaroori hai.
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.40),
                child: trailing!,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
          ),
        ),

        if (description != null && description!.trim().isNotEmpty) ...[
          const SizedBox(height: 5),

          Text(
            description!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
