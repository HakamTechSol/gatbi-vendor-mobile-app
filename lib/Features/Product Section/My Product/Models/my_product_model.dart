import 'my_product_attribute_group_model.dart';
import 'my_product_category_model.dart';
import 'my_product_variant_model.dart';

class MyProductModel {
  const MyProductModel({
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
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? shortDescription;

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

  final List<MyProductVariantModel> variants;

  final double? basePrice;
  final double? basePriceOld;
  final double? dealRate;

  final List<MyProductAttributeGroupModel> attributeGroups;

  final double? priceMin;
  final double? priceMax;
  final double? priceFrom;

  final MyProductCategoryModel? category;

  final String? sku;
  final String? brand;
  final double? priceOld;

  final bool isActive;

  factory MyProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductModel();
    }

    return MyProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      description: _parseString(json['description']),
      shortDescription: _parseString(json['short_description']),

      price: _parseDouble(json['price']),
      regularPrice: _parseDouble(json['regular_price']),
      salePrice: _parseDouble(json['sale_price']),

      currency: _parseString(json['currency']),
      currencySymbol: _parseString(json['currency_symbol']),

      stockStatus: _parseString(json['stock_status']),
      stockQuantity: _parseInt(json['stock_quantity']),

      hasVariants: _parseBool(json['has_variants']),

      rating: _parseDouble(json['rating']),
      reviewCount: _parseInt(json['review_count']),

      onSale: _parseBool(json['on_sale']),

      isFlashDeal: _parseBool(json['is_flash_deal']),
      flashDealPrice: _parseDouble(json['flash_deal_price']),
      flashDealEnd: _parseString(json['flash_deal_end']),

      dealCampaignId: _parseInt(json['deal_campaign_id']),
      dealDiscountPercentage: _parseDouble(json['deal_discount_percentage']),

      dealEventName: _parseString(json['deal_event_name']),
      dealEventSlug: _parseString(json['deal_event_slug']),

      featured: _parseBool(json['featured']),

      image: _parseString(json['image']),

      merchantId: _parseInt(json['merchant_id']),
      merchantName: _parseString(json['merchant_name']),

      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),

      variants: _parseVariants(json['variants']),

      basePrice: _parseDouble(json['base_price']),
      basePriceOld: _parseDouble(json['base_price_old']),
      dealRate: _parseDouble(json['deal_rate']),

      attributeGroups: _parseAttributeGroups(json['attribute_groups']),

      priceMin: _parseDouble(json['price_min']),
      priceMax: _parseDouble(json['price_max']),
      priceFrom: _parseDouble(json['price_from']),

      category: json['category'] is Map
          ? MyProductCategoryModel.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,

      sku: _parseString(json['sku']),
      brand: _parseString(json['brand']),
      priceOld: _parseDouble(json['price_old']),

      isActive: _parseBool(json['is_active']),
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
      'attribute_groups': attributeGroups.map((e) => e.toJson()).toList(),
      'price_min': priceMin,
      'price_max': priceMax,
      'price_from': priceFrom,
      'category': category?.toJson(),
      'sku': sku,
      'brand': brand,
      'price_old': priceOld,
      'is_active': isActive,
    };
  }

  static List<MyProductVariantModel> _parseVariants(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) =>
              MyProductVariantModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static List<MyProductAttributeGroupModel> _parseAttributeGroups(
    dynamic value,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => MyProductAttributeGroupModel.fromJson(
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}
