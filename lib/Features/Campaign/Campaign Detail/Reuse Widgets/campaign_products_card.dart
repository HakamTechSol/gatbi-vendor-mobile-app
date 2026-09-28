import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/campaign_detail_model.dart';

class CampaignProductsCard extends StatelessWidget {
  const CampaignProductsCard({super.key, required this.campaign});

  final CampaignDetailData campaign;

  @override
  Widget build(BuildContext context) {
    final products = campaign.products;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(products.length),

          const SizedBox(height: 18),

          if (products.isEmpty)
            _buildEmptyState()
          else
            _buildProductList(products),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(int count) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            size: 21,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Products',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                count == 0
                    ? 'No products assigned'
                    : '$count ${count == 1 ? 'product' : 'products'} included',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // PRODUCT LIST
  // ============================================================

  Widget _buildProductList(List<CampaignDetailProductModel> products) {
    return Column(
      children: List.generate(products.length, (index) {
        final product = products[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == products.length - 1 ? 0 : 10,
          ),
          child: _CampaignProductItem(product: product, index: index + 1),
        );
      }),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 30,
            color: AppColors.textTertiary,
          ),

          const SizedBox(height: 8),

          Text(
            'No products assigned',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Products associated with this campaign will appear here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CAMPAIGN PRODUCT ITEM
// ============================================================

class _CampaignProductItem extends StatelessWidget {
  const _CampaignProductItem({required this.product, required this.index});

  final CampaignDetailProductModel product;
  final int index;

  @override
  Widget build(BuildContext context) {
    final hasImage = product.image != null && product.image!.trim().isNotEmpty;

    final originalPrice = product.price;

    final dealPrice = product.dealPrice;

    final discountAmount = originalPrice != null && dealPrice != null
        ? originalPrice - dealPrice
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // PRODUCT IMAGE
          // ----------------------------------------------------
          Stack(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasImage
                    ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return _buildImagePlaceholder(isLoading: true);
                        },
                      )
                    : _buildImagePlaceholder(),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------
          // PRODUCT INFORMATION
          // ----------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name?.trim().isNotEmpty == true
                      ? product.name!.trim()
                      : 'Unnamed Product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                // ------------------------------------------------
                // PRICE
                // ------------------------------------------------
                Row(
                  children: [
                    if (dealPrice != null)
                      Text(
                        'AED ${_formatPrice(dealPrice)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                    if (originalPrice != null && dealPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'AED ${_formatPrice(originalPrice)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],

                    if (dealPrice == null && originalPrice != null)
                      Text(
                        'AED ${_formatPrice(originalPrice)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),

                // ------------------------------------------------
                // SAVING
                // ------------------------------------------------
                if (discountAmount != null && discountAmount > 0) ...[
                  const SizedBox(height: 4),

                  Text(
                    'Save AED ${_formatPrice(discountAmount)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _buildImagePlaceholder({bool isLoading = false}) {
    return Container(
      color: AppColors.surfaceMuted,
      alignment: Alignment.center,
      child: Icon(
        isLoading
            ? Icons.hourglass_empty_rounded
            : Icons.image_not_supported_outlined,
        size: 25,
        color: AppColors.textMuted,
      ),
    );
  }

  // ============================================================
  // PRICE FORMAT
  // ============================================================

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
