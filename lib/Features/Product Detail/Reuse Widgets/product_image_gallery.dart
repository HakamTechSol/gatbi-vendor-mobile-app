import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Model/product_detail_model.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({super.key, required this.product});

  final ProductDetailModel product;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selectedIndex = 0;

  List<String> get _images => widget.product.images;

  @override
  Widget build(BuildContext context) {
    if (_images.isEmpty) {
      return _buildEmptyGallery();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMainImage(),

          const SizedBox(height: 12),

          _buildThumbnailList(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN IMAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMainImage() {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              color: AppColors.surface,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Image.network(
                  _images[_selectedIndex],
                  key: ValueKey(_images[_selectedIndex]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return _buildImageLoader();
                  },
                  errorBuilder: (_, _, _) {
                    return _buildImageError();
                  },
                ),
              ),
            ),
          ),

          // Image counter
          Positioned(top: 12, right: 12, child: _buildImageCounter()),

          // Previous
          if (_selectedIndex > 0)
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavigationButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: _showPrevious,
                ),
              ),
            ),

          // Next
          if (_selectedIndex < _images.length - 1)
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavigationButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: _showNext,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE COUNTER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildImageCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.62),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            '${_selectedIndex + 1}/${_images.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(.92),
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, color: AppColors.navy, size: 22),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // THUMBNAILS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildThumbnailList() {
    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          return _buildThumbnail(index);
        },
      ),
    );
  }

  Widget _buildThumbnail(int index) {
    final isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 68,
        height: 68,
        padding: EdgeInsets.all(isSelected ? 2.5 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.network(
            _images[index],
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return Container(
                color: AppColors.surface,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE LOADING
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildImageLoader() {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE ERROR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildImageError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Image unavailable',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyGallery() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No product images',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showPrevious() {
    if (_selectedIndex <= 0) return;

    setState(() {
      _selectedIndex--;
    });
  }

  void _showNext() {
    if (_selectedIndex >= _images.length - 1) {
      return;
    }

    setState(() {
      _selectedIndex++;
    });
  }
}
