import 'package:flutter/material.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';
import '../../../Get Attributes/Models/get_attributes_model.dart';

class AddVariantHeader extends StatelessWidget {
  const AddVariantHeader({super.key, required this.attribute});

  final GetAttributeModel attribute;

  @override
  Widget build(BuildContext context) {
    final attributeName = attribute.name?.trim().isNotEmpty == true
        ? attribute.name!.trim()
        : 'Attribute';

    final attributeLabel = attribute.adminLabel?.trim().isNotEmpty == true
        ? attribute.adminLabel!.trim()
        : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 14),
            Expanded(
              child: _buildContent(
                attributeName: attributeName,
                attributeLabel: attributeLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
      ),
      child: const Icon(
        Icons.add_box_outlined,
        color: AppColors.white,
        size: 25,
      ),
    );
  }

  Widget _buildContent({
    required String attributeName,
    required String? attributeLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Variant',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Add a new value to your attribute.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textOnPrimarySecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _buildInfoChip(icon: Icons.category_outlined, text: attributeName),
            if (attributeLabel != null)
              _buildInfoChip(icon: Icons.label_outline, text: attributeLabel),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.white),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
