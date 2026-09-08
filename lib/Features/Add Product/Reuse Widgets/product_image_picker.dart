import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker({
    super.key,
    this.image,
    required this.onPick,
    this.onRemove,
    this.title = 'Product Image',
    this.subtitle = 'Upload the main image of your product.',
    this.height = 220,
    this.isRequired = false,
    this.enabled = true,
  });

  final File? image;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  final String title;
  final String subtitle;

  final double height;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyles.formLabel),
            if (isRequired)
              Text(
                ' *',
                style: AppTextStyles.formLabel.copyWith(color: AppColors.error),
              ),
          ],
        ),

        const SizedBox(height: 8),

        Text(subtitle, style: AppTextStyles.formHelper),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: enabled ? onPick : null,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.inputBackground
                  : AppColors.inputDisabledBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: image != null ? _buildImagePreview() : _buildEmptyState(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(image!, fit: BoxFit.cover),

          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Change image',
                  onPressed: enabled ? onPick : null,
                ),

                if (onRemove != null) ...[
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Remove image',
                    onPressed: enabled ? onRemove : null,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.inputIconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.image_outlined,
            size: 28,
            color: AppColors.inputIcon,
          ),
        ),

        const SizedBox(height: 14),

        Text('Upload product image', style: AppTextStyles.bodyMedium),

        const SizedBox(height: 5),

        Text('Tap to choose an image', style: AppTextStyles.formHelper),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: Colors.white, size: 19),
          ),
        ),
      ),
    );
  }
}
