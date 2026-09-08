import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ProductGalleryPicker extends StatelessWidget {
  const ProductGalleryPicker({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
    this.title = 'Product Gallery',
    this.subtitle = 'Add additional images to showcase your product.',
    this.maxImages = 8,
    this.enabled = true,
  });

  final List<File> images;

  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  final String title;
  final String subtitle;

  final int maxImages;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canAddMore = images.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.formLabel),

        const SizedBox(height: 8),

        Text(subtitle, style: AppTextStyles.formHelper),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...List.generate(images.length, (index) {
              return _GalleryImage(
                image: images[index],
                onRemove: enabled ? () => onRemove(index) : null,
              );
            }),

            if (canAddMore) _AddImageButton(onTap: enabled ? onAdd : null),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          '${images.length}/$maxImages images',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.image, this.onRemove});

  final File image;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(image, fit: BoxFit.cover),
            ),
          ),

          if (onRemove != null)
            Positioned(
              top: 6,
              right: 6,
              child: Material(
                color: Colors.black.withValues(alpha: 0.6),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddImageButton extends StatelessWidget {
  const _AddImageButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 28,
              color: AppColors.inputIcon,
            ),

            const SizedBox(height: 8),

            Text(
              'Add Image',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
