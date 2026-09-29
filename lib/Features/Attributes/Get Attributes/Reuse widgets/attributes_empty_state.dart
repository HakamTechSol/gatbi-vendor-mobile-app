import 'package:flutter/material.dart';

import '../../../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../../../Theme/app_colors.dart';
import '../../../../../../Theme/app_text_styles.dart';

class AttributesEmptyState extends StatelessWidget {
  const AttributesEmptyState({
    super.key,
    this.title = 'No Attributes Found',
    this.description = 'There are no product attributes available yet.',
    this.icon = Icons.tune_rounded,
    this.actionText,
    this.onAddAttribute,
  });

  final String title;
  final String description;
  final IconData icon;

  final String? actionText;
  final VoidCallback? onAddAttribute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyStateTitle,
          ),
          const SizedBox(height: 7),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription,
            ),
          ),
          if (actionText != null && onAddAttribute !=null) ...[
            const SizedBox(height: 20),
            CustomButton(
              text: actionText!,
              width: 150,
              height: 44,
              icon: Icons.add_rounded,
              onPressed: onAddAttribute,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: AppColors.softGradient,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 31, color: AppColors.primary),
      ),
    );
  }
}
