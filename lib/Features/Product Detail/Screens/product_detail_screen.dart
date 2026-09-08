import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';

import '../Model/product_detail_model.dart';
import '../Reuse Widgets/product_arabic_card.dart';
import '../Reuse Widgets/product_basic_info.dart';
import '../Reuse Widgets/product_description_card.dart';
import '../Reuse Widgets/product_detail_header.dart';
import '../Reuse Widgets/product_image_gallery.dart';
import '../Reuse Widgets/product_price_card.dart';
import '../Reuse Widgets/product_seo_card.dart';
import '../Reuse Widgets/product_stock_card.dart';
import '../Reuse Widgets/product_variants_card.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product, this.onEdit});

  /// Product data.
  ///
  /// UI is completely independent from API.
  /// Later repository/API can simply provide ProductDetailModel.
  final ProductDetailModel product;

  /// Edit product callback.
  final VoidCallback? onEdit;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailModel get product => widget.product;

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ───────────────────────────────────────────────────────────────
            // HEADER
            // ───────────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: ProductDetailHeader(
                product: product,
                onEdit: widget.onEdit,
              ),
            ),

            // ───────────────────────────────────────────────────────────────
            // PRODUCT IMAGE
            // ───────────────────────────────────────────────────────────────
            if (product.hasImages)
              SliverToBoxAdapter(child: ProductImageGallery(product: product)),

            // ───────────────────────────────────────────────────────────────
            // BASIC INFORMATION
            // ───────────────────────────────────────────────────────────────
            SliverToBoxAdapter(child: ProductBasicInfo(product: product)),

            // ───────────────────────────────────────────────────────────────
            // PRICE
            // ───────────────────────────────────────────────────────────────
            SliverToBoxAdapter(child: ProductPriceCard(product: product)),

            // ───────────────────────────────────────────────────────────────
            // STOCK
            // ───────────────────────────────────────────────────────────────
            SliverToBoxAdapter(child: ProductStockCard(product: product)),

            // ───────────────────────────────────────────────────────────────
            // PRODUCT INFORMATION
            // ───────────────────────────────────────────────────────────────
            // SliverToBoxAdapter(child: ProductInformationCard(product: product)),

            // ───────────────────────────────────────────────────────────────
            // DESCRIPTION
            // ───────────────────────────────────────────────────────────────
            if (product.shortDescription != null ||
                product.fullDescription != null)
              SliverToBoxAdapter(
                child: ProductDescriptionCard(product: product),
              ),

            // ───────────────────────────────────────────────────────────────
            // ARABIC CONTENT
            // ───────────────────────────────────────────────────────────────
            if (product.hasArabicContent)
              SliverToBoxAdapter(child: ProductArabicCard(product: product)),

            // ───────────────────────────────────────────────────────────────
            // VARIANTS
            // ───────────────────────────────────────────────────────────────
            if (product.hasVariants)
              SliverToBoxAdapter(child: ProductVariantsCard(product: product)),

            // ───────────────────────────────────────────────────────────────
            // SEO
            // ───────────────────────────────────────────────────────────────
            if (product.hasSeo)
              SliverToBoxAdapter(child: ProductSeoCard(product: product)),

            // ───────────────────────────────────────────────────────────────
            // ANALYTICS
            // ───────────────────────────────────────────────────────────────
            SliverToBoxAdapter(child: _ProductAnalyticsCard(product: product)),

            // Bottom safe spacing
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ANALYTICS CARD
// ═════════════════════════════════════════════════════════════════════════════

class _ProductAnalyticsCard extends StatelessWidget {
  const _ProductAnalyticsCard({required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.09),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Product sales & engagement',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _AnalyticsItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Total Sales',
                  value: product.totalSales.toString(),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _AnalyticsItem(
                  icon: Icons.visibility_outlined,
                  label: 'Views',
                  value: product.views.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ANALYTICS ITEM
// ═════════════════════════════════════════════════════════════════════════════

class _AnalyticsItem extends StatelessWidget {
  const _AnalyticsItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withOpacity(.7)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
