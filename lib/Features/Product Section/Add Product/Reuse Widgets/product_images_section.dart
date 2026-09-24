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

    /// Existing primary image from API.
    this.primaryImageUrl,

    /// Existing gallery images from API.
    this.galleryImageUrls = const [],

    /// Remove existing API gallery image.
    this.onRemoveGalleryImageUrl,
  });

  // ==========================================================================
  // LOCAL IMAGES
  // ==========================================================================

  final File? primaryImage;
  final List<File> galleryImages;

  // ==========================================================================
  // LOCAL IMAGE CALLBACKS
  // ==========================================================================

  final VoidCallback onPickPrimaryImage;
  final VoidCallback onRemovePrimaryImage;

  final VoidCallback onAddGalleryImage;
  final ValueChanged<int> onRemoveGalleryImage;

  // ==========================================================================
  // API IMAGES
  // ==========================================================================

  final String? primaryImageUrl;
  final List<String> galleryImageUrls;

  /// Called when user removes an existing gallery image from API.
  final ValueChanged<int>? onRemoveGalleryImageUrl;

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

          // ==========================================================================
          // PRIMARY IMAGE
          // ==========================================================================
          ProductImagePicker(
            image: primaryImage,
            imageUrl: primaryImageUrl,
            onPick: onPickPrimaryImage,
            onRemove: primaryImage != null || _hasPrimaryImageUrl
                ? onRemovePrimaryImage
                : null,
            title: 'Primary Product Image',
            subtitle: 'This image will be used as the main product image.',
            isRequired: true,
          ),

          const SizedBox(height: 28),

          // ==========================================================================
          // GALLERY
          // ==========================================================================
          ProductGalleryPicker(
            images: galleryImages,
            networkImages: galleryImageUrls,
            onAdd: onAddGalleryImage,
            onRemove: onRemoveGalleryImage,
            onRemoveNetworkImage: onRemoveGalleryImageUrl,
            title: 'Additional Images',
            subtitle:
                'Add more images to give customers a better view of the product.',
            maxImages: 8,
          ),
        ],
      ),
    );
  }

  bool get _hasPrimaryImageUrl {
    return primaryImageUrl != null && primaryImageUrl!.trim().isNotEmpty;
  }
}
