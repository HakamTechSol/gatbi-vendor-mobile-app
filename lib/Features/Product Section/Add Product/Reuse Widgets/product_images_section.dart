import 'dart:io';

import 'package:flutter/material.dart';

import 'product_form_section.dart';
import 'product_gallery_picker.dart';
import 'product_image_picker.dart';
import 'product_section_header.dart';

class ProductImagesSection extends StatelessWidget {
  const ProductImagesSection({
    super.key,
    required this.primaryImage,
    required this.galleryImages,
    required this.onPickPrimaryImage,
    required this.onRemovePrimaryImage,
    required this.onAddGalleryImage,
    required this.onRemoveGalleryImage,
  });

  final File? primaryImage;
  final List<File> galleryImages;

  final VoidCallback onPickPrimaryImage;
  final VoidCallback onRemovePrimaryImage;

  final VoidCallback onAddGalleryImage;
  final ValueChanged<int> onRemoveGalleryImage;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductSectionHeader(
            title: 'Product Images',
            description:
                'Upload a primary image and additional product images.',
          ),

          const SizedBox(height: 24),

          ProductImagePicker(
            image: primaryImage,
            onPick: onPickPrimaryImage,
            onRemove: primaryImage != null ? onRemovePrimaryImage : null,
            title: 'Primary Product Image',
            subtitle: 'This image will be used as the main product image.',
            isRequired: true,
          ),

          const SizedBox(height: 28),

          ProductGalleryPicker(
            images: galleryImages,
            onAdd: onAddGalleryImage,
            onRemove: onRemoveGalleryImage,
            title: 'Additional Images',
            subtitle:
                'Add more images to give customers a better view of the product.',
            maxImages: 8,
          ),
        ],
      ),
    );
  }
}
