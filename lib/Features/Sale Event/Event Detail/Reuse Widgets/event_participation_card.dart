import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/event_detail_model.dart';

class EventParticipationCard extends StatelessWidget {
  const EventParticipationCard({super.key, required this.event});

  final EventDetailItemModel event;

  @override
  Widget build(BuildContext context) {
    final participation = event.myParticipation;

    final hasParticipation = participation != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // Header
          // ======================================================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: hasParticipation
                      ? AppColors.successLight
                      : AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasParticipation
                      ? Icons.check_circle_outline_rounded
                      : Icons.event_available_outlined,
                  size: 21,
                  color: hasParticipation ? AppColors.success : AppColors.info,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'My Participation',
                  style: AppTextStyles.titleMedium,
                ),
              ),

              _ParticipationBadge(
                status: participation?.status,
                isParticipating: hasParticipation,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // Not Participating
          // ======================================================
          if (!hasParticipation) _buildNotParticipating(),

          // ======================================================
          // Participation Details
          // ======================================================
          if (hasParticipation) _buildParticipationDetails(participation),
        ],
      ),
    );
  }

  // ============================================================
  // Not Participating
  // ============================================================

  Widget _buildNotParticipating() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.info,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You are not participating in this event yet.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Participation Details
  // ============================================================

  Widget _buildParticipationDetails(EventParticipationModel participation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------
        // Success Message
        // --------------------------------------------------------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.successBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 20,
                color: AppColors.success,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'You are participating in this event.',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.successDark,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // --------------------------------------------------------
        // Participation Information
        // --------------------------------------------------------
        _buildParticipationInfo(participation),

        // --------------------------------------------------------
        // Products
        // --------------------------------------------------------
        if (participation.products.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildProductsSection(participation.products),
        ],
      ],
    );
  }

  // ============================================================
  // Participation Information
  // ============================================================

  Widget _buildParticipationInfo(EventParticipationModel participation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ParticipationInfoRow(
            icon: Icons.campaign_outlined,
            label: 'Campaign ID',
            value: '${participation.campaignId ?? 'N/A'}',
          ),

          const SizedBox(height: 11),

          _ParticipationInfoRow(
            icon: Icons.pending_actions_outlined,
            label: 'Status',
            value: _formatStatus(participation.status),
          ),

          const SizedBox(height: 11),

          _ParticipationInfoRow(
            icon: Icons.percent_rounded,
            label: 'Requested Discount',
            value: _formatPercentage(participation.requestedDiscountPercentage),
          ),

          const SizedBox(height: 11),

          _ParticipationInfoRow(
            icon: Icons.verified_outlined,
            label: 'Approved Discount',
            value: _formatPercentage(participation.discountPercentage),
          ),

          const SizedBox(height: 11),

          _ParticipationInfoRow(
            icon: Icons.inventory_2_outlined,
            label: 'Selected Products',
            value: '${participation.products.length}',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Products Section
  // ============================================================

  Widget _buildProductsSection(List<EventParticipationProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Selected Products',
                style: AppTextStyles.titleMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderPrimary),
              ),
              child: Text(
                '${products.length} Products',
                style: AppTextStyles.statusBadge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return _ParticipationProductCard(product: products[index]);
          },
        ),
      ],
    );
  }

  // ============================================================
  // Helpers
  // ============================================================

  String _formatStatus(String? status) {
    if (status == null || status.trim().isEmpty) {
      return 'Pending';
    }

    final normalized = status.trim().toLowerCase();

    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  String _formatPercentage(num? value) {
    if (value == null) {
      return 'Not approved';
    }

    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }

    return '$value%';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Participation Product Card
// ═══════════════════════════════════════════════════════════════════════════

class _ParticipationProductCard extends StatelessWidget {
  const _ParticipationProductCard({required this.product});

  final EventParticipationProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // Product Image
          // ======================================================
          _ProductImage(imageUrl: product.image),

          const SizedBox(width: 12),

          // ======================================================
          // Product Information
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name ?? 'Unnamed Product',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelLarge,
                      ),
                    ),

                    if (product.hasVariants)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Variants',
                          style: AppTextStyles.statusBadge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                if (product.id != null)
                  Text(
                    'Product #${product.id}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),

                const SizedBox(height: 8),

                _buildPriceSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ============================================================
  // Price Section
  // ============================================================

  Widget _buildPriceSection() {
    final dealMax = product.dealPriceMax;
    final priceMin = product.priceMin;
    final priceMax = product.priceMax;

    final hasPrice = priceMin != null || priceMax != null;

    if (dealMax == null && !hasPrice) {
      return Text('Price N/A', style: AppTextStyles.labelLarge);
    }

    return Row(
      children: [
        // ========================================================
        // Deal Price - Only dealPriceMax
        // ========================================================
        if (dealMax != null)
          Text(
            'AED ${_formatNumber(dealMax)}',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.successDark,
              fontWeight: FontWeight.w800,
            ),
          ),

        // ========================================================
        // Original Price
        // ========================================================
        if (dealMax != null && hasPrice) const SizedBox(width: 8),

        if (hasPrice)
          Flexible(
            child: Text(
              _formatPriceRange(priceMin, priceMax),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // Original Price Range
  // ============================================================

  String _formatPriceRange(num? min, num? max) {
    if (min == null && max == null) {
      return 'Price N/A';
    }

    if (min != null && max != null && min != max) {
      return 'AED ${_formatNumber(min)} - AED ${_formatNumber(max)}';
    }

    final value = min ?? max!;

    return 'AED ${_formatNumber(value)}';
  }

  // ============================================================
  // Number Formatter
  // ============================================================

  String _formatNumber(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Product Image
// ═══════════════════════════════════════════════════════════════════════════

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 82,
      height: 82,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return _buildPlaceholder(loading: true);
              },
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder({bool loading = false}) {
    return Center(
      child: Icon(
        loading ? Icons.image_outlined : Icons.inventory_2_outlined,
        size: 28,
        color: AppColors.iconSecondary,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Participation Info Row
// ═══════════════════════════════════════════════════════════════════════════

class _ParticipationInfoRow extends StatelessWidget {
  const _ParticipationInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          value,
          textAlign: TextAlign.end,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Participation Badge
// ═══════════════════════════════════════════════════════════════════════════

class _ParticipationBadge extends StatelessWidget {
  const _ParticipationBadge({
    required this.status,
    required this.isParticipating,
  });

  final String? status;
  final bool isParticipating;

  @override
  Widget build(BuildContext context) {
    final normalized = status?.trim().toLowerCase();

    Color backgroundColor;
    Color foregroundColor;

    if (!isParticipating) {
      backgroundColor = AppColors.surfaceMuted;
      foregroundColor = AppColors.textSecondary;
    } else if (normalized == 'approved') {
      backgroundColor = AppColors.successLight;
      foregroundColor = AppColors.successDark;
    } else if (normalized == 'rejected') {
      backgroundColor = AppColors.errorLight;
      foregroundColor = AppColors.errorDark;
    } else if (normalized == 'cancelled') {
      backgroundColor = AppColors.surfaceMuted;
      foregroundColor = AppColors.textSecondary;
    } else {
      backgroundColor = AppColors.infoLight;
      foregroundColor = AppColors.infoDark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isParticipating ? _formatStatus(status) : 'Not Joined',
        style: AppTextStyles.statusBadge.copyWith(color: foregroundColor),
      ),
    );
  }

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pending';
    }

    final normalized = value.trim().toLowerCase();

    return normalized[0].toUpperCase() + normalized.substring(1);
  }
}
