import 'product_detail_attribute_group_model.dart';
import 'product_detail_attribute_model.dart';
import 'product_detail_campaign_model.dart';
import 'product_detail_category_model.dart';
import 'product_detail_gellary_model.dart';
import 'product_detail_variant_model.dart';

class ProductDetailItemModel {
  const ProductDetailItemModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.shortDescription,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.currency,
    this.currencySymbol,
    this.stockStatus,
    this.stockQuantity,
    this.hasVariants = false,
    this.rating,
    this.reviewCount,
    this.onSale = false,
    this.isFlashDeal = false,
    this.flashDealPrice,
    this.flashDealEnd,
    this.dealCampaignId,
    this.dealDiscountPercentage,
    this.dealEventName,
    this.dealEventSlug,
    this.featured = false,
    this.image,
    this.merchantId,
    this.merchantName,
    this.createdAt,
    this.updatedAt,
    this.variants = const [],
    this.basePrice,
    this.basePriceOld,
    this.dealRate,
    this.attributeGroups = const [],
    this.priceMin,
    this.priceMax,
    this.priceFrom,
    this.category,
    this.sku,
    this.brand,
    this.priceOld,
    this.isActive = false,
    this.gallery = const [],
    this.attributes = const [],
    this.campaigns = const [],
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? shortDescription;

  final List<ProductDetailGalleryModel> gallery;

  final double? price;
  final double? regularPrice;
  final double? salePrice;

  final String? currency;
  final String? currencySymbol;

  final String? stockStatus;
  final int? stockQuantity;

  final bool hasVariants;

  final double? rating;
  final int? reviewCount;

  final bool onSale;
  final bool isFlashDeal;

  final double? flashDealPrice;
  final String? flashDealEnd;

  final int? dealCampaignId;
  final double? dealDiscountPercentage;

  final String? dealEventName;
  final String? dealEventSlug;

  final bool featured;

  final String? image;

  final int? merchantId;
  final String? merchantName;

  final String? createdAt;
  final String? updatedAt;

  final List<ProductDetailVariantModel> variants;

  final double? basePrice;
  final double? basePriceOld;
  final double? dealRate;

  final List<ProductDetailAttributeGroupModel> attributeGroups;

  final double? priceMin;
  final double? priceMax;
  final double? priceFrom;

  final ProductDetailCategoryModel? category;

  final String? sku;
  final String? brand;
  final double? priceOld;

  final bool isActive;

  final List<ProductDetailAttributeModel> attributes;

  final List<ProductDetailCampaignModel> campaigns;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailItemModel();
    }

    return ProductDetailItemModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      shortDescription: json['short_description']?.toString(),

      price: _parseDouble(json['price']),
      regularPrice: _parseDouble(json['regular_price']),
      salePrice: _parseDouble(json['sale_price']),

      currency: json['currency']?.toString(),
      currencySymbol: json['currency_symbol']?.toString(),

      stockStatus: json['stock_status']?.toString(),
      stockQuantity: _parseInt(json['stock_quantity']),

      hasVariants: _parseBool(json['has_variants']),

      rating: _parseDouble(json['rating']),
      reviewCount: _parseInt(json['review_count']),

      onSale: _parseBool(json['on_sale']),
      isFlashDeal: _parseBool(json['is_flash_deal']),

      flashDealPrice: _parseDouble(json['flash_deal_price']),
      flashDealEnd: json['flash_deal_end']?.toString(),

      dealCampaignId: _parseInt(json['deal_campaign_id']),
      dealDiscountPercentage: _parseDouble(json['deal_discount_percentage']),

      dealEventName: json['deal_event_name']?.toString(),
      dealEventSlug: json['deal_event_slug']?.toString(),

      featured: _parseBool(json['featured']),

      image: json['image']?.toString(),

      merchantId: _parseInt(json['merchant_id']),
      merchantName: json['merchant_name']?.toString(),

      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),

      variants: _parseList(
        json['variants'],
        ProductDetailVariantModel.fromJson,
      ),

      basePrice: _parseDouble(json['base_price']),
      basePriceOld: _parseDouble(json['base_price_old']),
      dealRate: _parseDouble(json['deal_rate']),

      attributeGroups: _parseList(
        json['attribute_groups'],
        ProductDetailAttributeGroupModel.fromJson,
      ),

      priceMin: _parseDouble(json['price_min']),
      priceMax: _parseDouble(json['price_max']),
      priceFrom: _parseDouble(json['price_from']),

      category: json['category'] is Map
          ? ProductDetailCategoryModel.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,

      sku: json['sku']?.toString(),
      brand: json['brand']?.toString(),
      priceOld: _parseDouble(json['price_old']),

      isActive: _parseBool(json['is_active']),

      gallery: _parseGallery(json['gallery']),

      attributes: _parseList(
        json['attributes'],
        ProductDetailAttributeModel.fromJson,
      ),

      campaigns: _parseList(
        json['campaigns'],
        ProductDetailCampaignModel.fromJson,
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'short_description': shortDescription,

      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,

      'currency': currency,
      'currency_symbol': currencySymbol,

      'stock_status': stockStatus,
      'stock_quantity': stockQuantity,

      'has_variants': hasVariants,

      'rating': rating,
      'review_count': reviewCount,

      'on_sale': onSale,
      'is_flash_deal': isFlashDeal,

      'flash_deal_price': flashDealPrice,
      'flash_deal_end': flashDealEnd,

      'deal_campaign_id': dealCampaignId,
      'deal_discount_percentage': dealDiscountPercentage,

      'deal_event_name': dealEventName,
      'deal_event_slug': dealEventSlug,

      'featured': featured,

      'image': image,

      'merchant_id': merchantId,
      'merchant_name': merchantName,

      'created_at': createdAt,
      'updated_at': updatedAt,

      'variants': variants.map((e) => e.toJson()).toList(),

      'base_price': basePrice,
      'base_price_old': basePriceOld,
      'deal_rate': dealRate,

      'attribute_groups': attributeGroups.map((e) => e.toJson()).toList(),

      'price_min': priceMin,
      'price_max': priceMax,
      'price_from': priceFrom,

      'category': category?.toJson(),

      'sku': sku,
      'brand': brand,
      'price_old': priceOld,

      'is_active': isActive,

      'gallery': gallery.map((item) => item.toJson()).toList(),

      'attributes': attributes.map((e) => e.toJson()).toList(),

      'campaigns': campaigns.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static List<ProductDetailGalleryModel> _parseGallery(dynamic value) {
    if (value is! List) {
      return const [];
    }
    return value
        .whereType<Map>()
        .map(
          (item) => ProductDetailGalleryModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
