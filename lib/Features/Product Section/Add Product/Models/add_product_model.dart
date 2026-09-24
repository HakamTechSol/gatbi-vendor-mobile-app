import 'add_product_attribute_group_model.dart';
import 'add_product_attribute_model.dart';
import 'add_product_campaign_model.dart';
import 'add_product_category_model.dart';
import 'add_product_variant_model.dart';

class AddProductModel {
  const AddProductModel({
    this.success = false,
    this.message,
    this.product,
  });

  final bool success;
  final String? message;
  final AddProductProductModel? product;

  factory AddProductModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const AddProductModel();
    }

    return AddProductModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      product: json['product'] is Map
          ? AddProductProductModel.fromJson(
              Map<String, dynamic>.from(
                json['product'] as Map,
              ),
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
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    return value.toString();
  }
}

// ============================================================
// Product
// ============================================================

class AddProductProductModel {
  const AddProductProductModel({
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

  final List<AddProductVariantModel> variants;

  final num? basePrice;
  final num? basePriceOld;

  final num? dealRate;

  final List<AddProductAttributeGroupModel> attributeGroups;

  final num? priceMin;
  final num? priceMax;
  final num? priceFrom;

  final AddProductCategoryModel? category;

  final String? sku;
  final String? brand;

  final num? priceOld;

  final bool isActive;

  /// API sample mein gallery [] hai.
  ///
  /// String URLs ko support karta hai.
  final List<String> gallery;

  final List<AddProductAttributeModel> attributes;

  final List<AddProductCampaignModel> campaigns;

  factory AddProductProductModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const AddProductProductModel();
    }

    return AddProductProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      description: _parseString(json['description']),
      shortDescription: _parseString(json['short_description']),
      price: _parseNum(json['price']),
      regularPrice: _parseNum(json['regular_price']),
      salePrice: _parseNum(json['sale_price']),
      currency: _parseString(json['currency']),
      currencySymbol: _parseString(json['currency_symbol']),
      stockStatus: _parseString(json['stock_status']),
      stockQuantity: _parseInt(json['stock_quantity']),
      hasVariants: _parseBool(json['has_variants']),
      rating: _parseNum(json['rating']),
      reviewCount: _parseInt(json['review_count']),
      onSale: _parseBool(json['on_sale']),
      isFlashDeal: _parseBool(json['is_flash_deal']),
      flashDealPrice: _parseNum(json['flash_deal_price']),
      flashDealEnd: _parseString(json['flash_deal_end']),
      dealCampaignId: _parseInt(json['deal_campaign_id']),
      dealDiscountPercentage: _parseNum(
        json['deal_discount_percentage'],
      ),
      dealEventName: _parseString(json['deal_event_name']),
      dealEventSlug: _parseString(json['deal_event_slug']),
      featured: _parseBool(json['featured']),
      image: _parseString(json['image']),
      merchantId: _parseInt(json['merchant_id']),
      merchantName: _parseString(json['merchant_name']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      variants: _parseList(
        json['variants'],
        AddProductVariantModel.fromJson,
      ),
      basePrice: _parseNum(json['base_price']),
      basePriceOld: _parseNum(json['base_price_old']),
      dealRate: _parseNum(json['deal_rate']),
      attributeGroups: _parseList(
        json['attribute_groups'],
        AddProductAttributeGroupModel.fromJson,
      ),
      priceMin: _parseNum(json['price_min']),
      priceMax: _parseNum(json['price_max']),
      priceFrom: _parseNum(json['price_from']),
      category: json['category'] is Map
          ? AddProductCategoryModel.fromJson(
              Map<String, dynamic>.from(
                json['category'] as Map,
              ),
            )
          : null,
      sku: _parseString(json['sku']),
      brand: _parseString(json['brand']),
      priceOld: _parseNum(json['price_old']),
      isActive: _parseBool(json['is_active']),
      gallery: _parseStringList(json['gallery']),
      attributes: _parseList(
        json['attributes'],
        AddProductAttributeModel.fromJson,
      ),
      campaigns: _parseList(
        json['campaigns'],
        AddProductCampaignModel.fromJson,
      ),
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
      'variants': variants.map((e) => e.toJson()).toList(),
      'base_price': basePrice,
      'base_price_old': basePriceOld,
      'deal_rate': dealRate,
      'attribute_groups':
          attributeGroups.map((e) => e.toJson()).toList(),
      'price_min': priceMin,
      'price_max': priceMax,
      'price_from': priceFrom,
      'category': category?.toJson(),
      'sku': sku,
      'brand': brand,
      'price_old': priceOld,
      'is_active': isActive,
      'gallery': gallery,
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'campaigns': campaigns.map((e) => e.toJson()).toList(),
    };
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

  static num? _parseNum(dynamic value) {
    if (value is num) return value;

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    return value.toString();
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
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
        .map(
          (item) => fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}