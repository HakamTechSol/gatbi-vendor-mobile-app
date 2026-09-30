import 'package:flutter/material.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';

class VariantFormCard extends StatelessWidget {
  const VariantFormCard({
    super.key,
    required this.children,
    this.title = 'Variant Details',
    this.subtitle = 'Enter the details for this variant.',
    this.icon = Icons.tune_outlined,
  });

  final List<Widget> children;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            ..._buildChildren(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppColors.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.formSectionTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.formHelper.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    final result = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);

      if (i < children.length - 1) {
        result.add(const SizedBox(height: 18));
      }
    }

    return result;
  }
}
