import 'update_product_category_model.dart';
import 'update_product_gallery_model.dart';
import 'update_product_variant_model.dart';

class UpdateProductModel {
  const UpdateProductModel({this.success = false, this.message, this.product});

  final bool success;
  final String? message;
  final UpdateProductItemModel? product;

  factory UpdateProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UpdateProductModel();
    }

    return UpdateProductModel(
      success: _parseBool(json['success']),
      message: json['message']?.toString(),
      product: json['product'] is Map
          ? UpdateProductItemModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'product': product?.toJson(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ============================================================
// Product
// ============================================================

class UpdateProductItemModel {
  const UpdateProductItemModel({
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
    this.category,
    this.sku,
    this.brand,
    this.priceOld,
    this.isActive = false,
    this.gallery = const [],
    this.variants = const [],
    this.attributes = const [],
    this.campaigns = const [],
  });

  final int? id;

  final String? name;

  final String? slug;

  final String? description;

  final String? shortDescription;

  final num? price;

  final num? regularPrice;

  final num? salePrice;

  final String? currency;

  final String? currencySymbol;

  final String? stockStatus;

  final int? stockQuantity;

  final bool hasVariants;

  final num? rating;

  final int? reviewCount;

  final bool onSale;

  final bool isFlashDeal;

  final num? flashDealPrice;

  final String? flashDealEnd;

  final int? dealCampaignId;

  final num? dealDiscountPercentage;

  final String? dealEventName;

  final String? dealEventSlug;

  final bool featured;

  final String? image;

  final int? merchantId;

  final String? merchantName;

  final String? createdAt;

  final String? updatedAt;

  final UpdateProductCategoryModel? category;

  final String? sku;

  final String? brand;

  final num? priceOld;

  final bool isActive;

  final List<UpdateProductGalleryModel> gallery;

  final List<UpdateProductVariantModel> variants;

  final List<dynamic> attributes;

  final List<dynamic> campaigns;

  factory UpdateProductItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UpdateProductItemModel();
    }

    return UpdateProductItemModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      shortDescription: json['short_description']?.toString(),
      price: _parseNum(json['price']),
      regularPrice: _parseNum(json['regular_price']),
      salePrice: _parseNum(json['sale_price']),
      currency: json['currency']?.toString(),
      currencySymbol: json['currency_symbol']?.toString(),
      stockStatus: json['stock_status']?.toString(),
      stockQuantity: _parseInt(json['stock_quantity']),
      hasVariants: _parseBool(json['has_variants']),
      rating: _parseNum(json['rating']),
      reviewCount: _parseInt(json['review_count']),
      onSale: _parseBool(json['on_sale']),
      isFlashDeal: _parseBool(json['is_flash_deal']),
      flashDealPrice: _parseNum(json['flash_deal_price']),
      flashDealEnd: json['flash_deal_end']?.toString(),
      dealCampaignId: _parseInt(json['deal_campaign_id']),
      dealDiscountPercentage: _parseNum(json['deal_discount_percentage']),
      dealEventName: json['deal_event_name']?.toString(),
      dealEventSlug: json['deal_event_slug']?.toString(),
      featured: _parseBool(json['featured']),
      image: json['image']?.toString(),
      merchantId: _parseInt(json['merchant_id']),
      merchantName: json['merchant_name']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      category: json['category'] is Map
          ? UpdateProductCategoryModel.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,
      sku: json['sku']?.toString(),
      brand: json['brand']?.toString(),
      priceOld: _parseNum(json['price_old']),
      isActive: _parseBool(json['is_active']),
      gallery: _parseList(json['gallery'], UpdateProductGalleryModel.fromJson),
      variants: _parseList(
        json['variants'],
        UpdateProductVariantModel.fromJson,
      ),
      attributes: json['attributes'] is List
          ? List<dynamic>.from(json['attributes'] as List)
          : const [],
      campaigns: json['campaigns'] is List
          ? List<dynamic>.from(json['campaigns'] as List)
          : const [],
    );
  }

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
      'category': category?.toJson(),
      'sku': sku,
      'brand': brand,
      'price_old': priceOld,
      'is_active': isActive,
      'gallery': gallery.map((e) => e.toJson()).toList(),
      'variants': variants.map((e) => e.toJson()).toList(),
      'attributes': attributes,
      'campaigns': campaigns,
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static num? _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
