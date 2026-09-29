import 'package:flutter/material.dart';

import '../../../../../../Theme/app_colors.dart';
import '../../../../../../Theme/app_text_styles.dart';

import '../Models/get_attributes_model.dart';

class AttributeValueRow extends StatelessWidget {
  const AttributeValueRow({
    super.key,
    required this.value,
    this.onEdit,
    this.onDelete,
  });

  final GetAttributeValueModel value;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          _buildIcon(),

          const SizedBox(width: 10),

          Expanded(child: _buildValueInfo()),

          // ====================================================
          // EDIT
          //
          // null hone par icon completely hide hoga.
          // ====================================================
          if (onEdit != null) ...[const SizedBox(width: 8), _buildEditButton()],

          // ====================================================
          // DELETE
          //
          // null hone par icon completely hide hoga.
          // ====================================================
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            _buildDeleteButton(),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  Widget _buildIcon() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Icon(
        Icons.sell_outlined,
        size: 17,
        color: AppColors.primary,
      ),
    );
  }

  // ============================================================
  // VALUE INFO
  // ============================================================

  Widget _buildValueInfo() {
    final valueText = value.value?.trim();

    final displayValue = valueText == null || valueText.isEmpty
        ? 'Unnamed Value'
        : valueText;

    final code = value.code?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayValue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall,
        ),

        if (code != null && code.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            'Code: $code',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ],
      ],
    );
  }

  // ============================================================
  // EDIT
  // ============================================================

  Widget _buildEditButton() {
    return _buildActionButton(
      icon: Icons.edit_outlined,
      tooltip: 'Edit Value',
      color: AppColors.primary,
      backgroundColor: AppColors.primaryLight,
      onPressed: onEdit,
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  Widget _buildDeleteButton() {
    return _buildActionButton(
      icon: Icons.delete_outline_rounded,
      tooltip: 'Delete Value',
      color: AppColors.error,
      backgroundColor: AppColors.errorLight,
      onPressed: onDelete,
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required Color backgroundColor,
    required VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(icon, size: 17, color: color),
          ),
        ),
      ),
    );
  }
}
