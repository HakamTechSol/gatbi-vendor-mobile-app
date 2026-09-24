import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';

import '../Controller/product_detail_controller.dart';
import '../Model/product_detail_item_model.dart';

import '../Reuse Widgets/product_basic_info.dart';
import '../Reuse Widgets/product_description_card.dart';
import '../Reuse Widgets/product_detail_header.dart';
import '../Reuse Widgets/product_details_shimmer_screen.dart';
import '../Reuse Widgets/product_image_gallery.dart';
import '../Reuse Widgets/product_price_card.dart';
import '../Reuse Widgets/product_seo_card.dart';
import '../Reuse Widgets/product_stock_card.dart';
import '../Reuse Widgets/product_variants_card.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId,});

  /// Product ID used to load the latest product detail
  /// directly from the vendor product detail API.
  final int productId;


  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  ProductDetailItemModel? _product;

  bool _isLoading = true;

  String? _errorMessage;

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _loadProduct();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadProduct() async {
    if (!mounted) {
      return;
    }

    // ------------------------------------------------------------
    // Always show shimmer whenever API is called.
    // This applies to:
    // 1. First screen open
    // 2. Pull-to-refresh
    // 3. Retry
    // ------------------------------------------------------------

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _product = null;
    });

    try {
      final controller = ref.read(productDetailControllerProvider);

      final response = await controller.getProductDetail(
        productId: widget.productId,
      );

      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // Validate product
      // ----------------------------------------------------------

      final product = response.product;

      if (product == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Product information is not available.';
        });

        return;
      }

      // ----------------------------------------------------------
      // Validate API success
      // ----------------------------------------------------------

      if (!response.success) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to load product details.';
        });

        return;
      }

      // ----------------------------------------------------------
      // Success
      // ----------------------------------------------------------

      setState(() {
        _product = product;
        _isLoading = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------
    // Loading / Refreshing
    // ------------------------------------------------------------

    if (_isLoading) {
      return const ProductDetailsShimmerScreen();
    }

    // ------------------------------------------------------------
    // Error
    // ------------------------------------------------------------

    if (_product == null) {
      return _buildErrorScreen();
    }

    // ------------------------------------------------------------
    // Product
    // ------------------------------------------------------------

    return _buildProductScreen(_product!);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT SCREEN
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductScreen(ProductDetailItemModel product) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          // ----------------------------------------------------------
          // Pull to refresh
          // ----------------------------------------------------------
          //
          // _loadProduct() sets _isLoading = true.
          // The complete screen switches to shimmer.
          //
          onRefresh: _loadProduct,

          color: AppColors.primary,
          backgroundColor: AppColors.white,

          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ────────────────────────────────────────────────────────
              // HEADER
              // ────────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: ProductDetailHeader(
                  product: product,
                ),
              ),

              // ────────────────────────────────────────────────────────
              // PRODUCT IMAGE
              // ────────────────────────────────────────────────────────
              if (_hasImages(product))
                SliverToBoxAdapter(
                  child: ProductImageGallery(product: product),
                ),

              // ────────────────────────────────────────────────────────
              // BASIC INFORMATION
              // ────────────────────────────────────────────────────────
              SliverToBoxAdapter(child: ProductBasicInfo(product: product)),

              // ────────────────────────────────────────────────────────
              // PRICE
              // ────────────────────────────────────────────────────────
              SliverToBoxAdapter(child: ProductPriceCard(product: product)),

              // ────────────────────────────────────────────────────────
              // STOCK
              // ────────────────────────────────────────────────────────
              SliverToBoxAdapter(child: ProductStockCard(product: product)),

              // ────────────────────────────────────────────────────────
              // DESCRIPTION
              // ────────────────────────────────────────────────────────
              if (_hasDescription(product))
                SliverToBoxAdapter(
                  child: ProductDescriptionCard(product: product),
                ),

              // ────────────────────────────────────────────────────────
              // VARIANTS
              // ────────────────────────────────────────────────────────
              if (product.variants.isNotEmpty)
                SliverToBoxAdapter(
                  child: ProductVariantsCard(product: product),
                ),

              // ────────────────────────────────────────────────────────
              // SEO
              // ────────────────────────────────────────────────────────
              if (_hasSeo(product))
                SliverToBoxAdapter(child: ProductSeoCard(product: product)),

              // ────────────────────────────────────────────────────────
              // BOTTOM SPACING
              // ────────────────────────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE CHECK
  // ═══════════════════════════════════════════════════════════════════════════

  bool _hasImages(ProductDetailItemModel product) {
    final image = product.image?.trim() ?? '';

    if (image.isNotEmpty) {
      return true;
    }

    return product.gallery.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DESCRIPTION CHECK
  // ═══════════════════════════════════════════════════════════════════════════

  bool _hasDescription(ProductDetailItemModel product) {
    final shortDescription = product.shortDescription?.trim() ?? '';

    final description = product.description?.trim() ?? '';

    return shortDescription.isNotEmpty || description.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEO CHECK
  // ═══════════════════════════════════════════════════════════════════════════

  bool _hasSeo(ProductDetailItemModel product) {
    final slug = product.slug?.trim() ?? '';

    return slug.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR SCREEN
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border.withOpacity(.65)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.025),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --------------------------------------------------------
                  // Error Icon
                  // --------------------------------------------------------
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(.09),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --------------------------------------------------------
                  // Title
                  // --------------------------------------------------------
                  Text(
                    'Unable to Load Product',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // --------------------------------------------------------
                  // Message
                  // --------------------------------------------------------
                  Text(
                    _errorMessage ??
                        'Product details could not be loaded. '
                            'Please try again.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --------------------------------------------------------
                  // Retry
                  // --------------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _loadProduct,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // --------------------------------------------------------
                  // Back
                  // --------------------------------------------------------
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Text(
                      'Go Back',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
