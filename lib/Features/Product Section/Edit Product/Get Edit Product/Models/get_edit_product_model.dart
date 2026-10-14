typedef JsonMap = Map<String, dynamic>;

bool parseJsonBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
        return true;
      case 'false':
      case '0':
      case 'no':
        return false;
    }
  }

  return fallback;
}

int? parseJsonInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

num? parseJsonNum(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value.trim());
  return null;
}

String? parseJsonString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

JsonMap parseJsonMap(dynamic value) {
  if (value is! Map) return <String, dynamic>{};
  return Map<String, dynamic>.from(value);
}

List<T> parseJsonList<T>(dynamic value, T Function(JsonMap json) fromJson) {
  if (value is! List) return <T>[];

  return value
      .whereType<Map>()
      .map((item) => fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

class GetEditProductModel {
  const GetEditProductModel({
    this.success = false,
    this.product,
    this.translation,
  });

  final bool success;
  final GetEditProductItemModel? product;
  final GetEditProductTranslationModel? translation;

  factory GetEditProductModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductModel();

    return GetEditProductModel(
      success: parseJsonBool(json['success']),
      product: json['product'] is Map
          ? GetEditProductItemModel.fromJson(parseJsonMap(json['product']))
          : null,
      translation: json['translation'] is Map
          ? GetEditProductTranslationModel.fromJson(
              parseJsonMap(json['translation']),
            )
          : null,
    );
  }

  JsonMap toJson() => {
    'success': success,
    'product': product?.toJson(),
    'translation': translation?.toJson(),
  };
}

class GetEditProductItemModel {
  const GetEditProductItemModel({
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
    this.brandId,
    this.priceOld,
    this.isActive = false,
    this.gallery = const [],
    this.attributes = const [],
    this.campaigns = const [],
    this.allowAffiliate = false,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.affiliateMetaTitle,
    this.affiliateMetaDescription,
    this.affiliateMetaKeywords,
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

  final List<GetEditProductVariantModel> variants;
  final num? basePrice;
  final num? basePriceOld;
  final num? dealRate;
  final List<GetEditProductAttributeGroupModel> attributeGroups;
  final num? priceMin;
  final num? priceMax;
  final num? priceFrom;

  final GetEditProductCategoryModel? category;
  final String? sku;
  final String? brand;
  final int? brandId;
  final num? priceOld;
  final bool isActive;

  final List<GetEditProductGalleryModel> gallery;
  final List<GetEditProductAttributeModel> attributes;
  final List<GetEditProductCampaignModel> campaigns;

  final bool allowAffiliate;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;
  final String? affiliateMetaTitle;
  final String? affiliateMetaDescription;
  final String? affiliateMetaKeywords;

  factory GetEditProductItemModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductItemModel();

    return GetEditProductItemModel(
      id: parseJsonInt(json['id']),
      name: parseJsonString(json['name']),
      slug: parseJsonString(json['slug']),
      description: parseJsonString(json['description']),
      shortDescription: parseJsonString(json['short_description']),
      price: parseJsonNum(json['price']),
      regularPrice: parseJsonNum(json['regular_price']),
      salePrice: parseJsonNum(json['sale_price']),
      currency: parseJsonString(json['currency']),
      currencySymbol: parseJsonString(json['currency_symbol']),
      stockStatus: parseJsonString(json['stock_status']),
      stockQuantity: parseJsonInt(json['stock_quantity']),
      hasVariants: parseJsonBool(json['has_variants']),
      rating: parseJsonNum(json['rating']),
      reviewCount: parseJsonInt(json['review_count']),
      onSale: parseJsonBool(json['on_sale']),
      isFlashDeal: parseJsonBool(json['is_flash_deal']),
      flashDealPrice: parseJsonNum(json['flash_deal_price']),
      flashDealEnd: parseJsonString(json['flash_deal_end']),
      dealCampaignId: parseJsonInt(json['deal_campaign_id']),
      dealDiscountPercentage: parseJsonNum(json['deal_discount_percentage']),
      dealEventName: parseJsonString(json['deal_event_name']),
      dealEventSlug: parseJsonString(json['deal_event_slug']),
      featured: parseJsonBool(json['featured']),
      image: parseJsonString(json['image']),
      merchantId: parseJsonInt(json['merchant_id']),
      merchantName: parseJsonString(json['merchant_name']),
      createdAt: parseJsonString(json['created_at']),
      updatedAt: parseJsonString(json['updated_at']),
      variants: parseJsonList(
        json['variants'],
        GetEditProductVariantModel.fromJson,
      ),
      basePrice: parseJsonNum(json['base_price']),
      basePriceOld: parseJsonNum(json['base_price_old']),
      dealRate: parseJsonNum(json['deal_rate']),
      attributeGroups: parseJsonList(
        json['attribute_groups'],
        GetEditProductAttributeGroupModel.fromJson,
      ),
      priceMin: parseJsonNum(json['price_min']),
      priceMax: parseJsonNum(json['price_max']),
      priceFrom: parseJsonNum(json['price_from']),
      category: json['category'] is Map
          ? GetEditProductCategoryModel.fromJson(parseJsonMap(json['category']))
          : null,
      sku: parseJsonString(json['sku']),
      brand: parseJsonString(json['brand']),
      brandId: parseJsonInt(json['brand_id']),
      priceOld: parseJsonNum(json['price_old']),
      isActive: parseJsonBool(json['is_active']),
      gallery: parseJsonList(
        json['gallery'],
        GetEditProductGalleryModel.fromJson,
      ),
      attributes: parseJsonList(
        json['attributes'],
        GetEditProductAttributeModel.fromJson,
      ),
      campaigns: parseJsonList(
        json['campaigns'],
        GetEditProductCampaignModel.fromJson,
      ),
      allowAffiliate: parseJsonBool(json['allow_affiliate']),
      metaTitle: parseJsonString(json['meta_title']),
      metaDescription: parseJsonString(json['meta_description']),
      metaKeywords: parseJsonString(json['meta_keywords']),
      affiliateMetaTitle: parseJsonString(json['affiliate_meta_title']),
      affiliateMetaDescription: parseJsonString(
        json['affiliate_meta_description'],
      ),
      affiliateMetaKeywords: parseJsonString(json['affiliate_meta_keywords']),
    );
  }

  JsonMap toJson() => {
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
    'brand_id': brandId,
    'price_old': priceOld,
    'is_active': isActive,
    'gallery': gallery.map((e) => e.toJson()).toList(),
    'attributes': attributes.map((e) => e.toJson()).toList(),
    'campaigns': campaigns.map((e) => e.toJson()).toList(),
    'allow_affiliate': allowAffiliate,
    'meta_title': metaTitle,
    'meta_description': metaDescription,
    'meta_keywords': metaKeywords,
    'affiliate_meta_title': affiliateMetaTitle,
    'affiliate_meta_description': affiliateMetaDescription,
    'affiliate_meta_keywords': affiliateMetaKeywords,
  };
}

class GetEditProductVariantModel {
  const GetEditProductVariantModel({
    this.id,
    this.sku,
    this.price,
    this.priceOld,
    this.stockQty,
    this.weight,
    this.barcode,
    this.isActive = false,
    this.isPriceOverride = false,
    this.attributes = const {},
    this.optionValues = const [],
  });

  final int? id;
  final String? sku;
  final num? price;
  final num? priceOld;
  final int? stockQty;
  final num? weight;
  final String? barcode;
  final bool isActive;
  final bool isPriceOverride;
  final Map<String, dynamic> attributes;
  final List<GetEditProductOptionValueModel> optionValues;

  factory GetEditProductVariantModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductVariantModel();

    return GetEditProductVariantModel(
      id: parseJsonInt(json['id']),
      sku: parseJsonString(json['sku']),
      price: parseJsonNum(json['price']),
      priceOld: parseJsonNum(json['price_old']),
      stockQty: parseJsonInt(json['stock_qty']),
      weight: parseJsonNum(json['weight']),
      barcode: parseJsonString(json['barcode']),
      isActive: parseJsonBool(json['is_active']),
      isPriceOverride: parseJsonBool(json['is_price_override']),
      attributes: parseJsonMap(json['attributes']),
      optionValues: parseJsonList(
        json['option_values'],
        GetEditProductOptionValueModel.fromJson,
      ),
    );
  }

  JsonMap toJson() => {
    'id': id,
    'sku': sku,
    'price': price,
    'price_old': priceOld,
    'stock_qty': stockQty,
    'weight': weight,
    'barcode': barcode,
    'is_active': isActive,
    'is_price_override': isPriceOverride,
    'attributes': attributes,
    'option_values': optionValues.map((e) => e.toJson()).toList(),
  };
}

class GetEditProductOptionValueModel {
  const GetEditProductOptionValueModel({
    this.attributeId,
    this.attribute,
    this.attributeValueId,
    this.value,
    this.code,
  });

  final int? attributeId;
  final String? attribute;
  final int? attributeValueId;
  final String? value;
  final String? code;

  factory GetEditProductOptionValueModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductOptionValueModel();

    return GetEditProductOptionValueModel(
      attributeId: parseJsonInt(json['attribute_id']),
      attribute: parseJsonString(json['attribute']),
      attributeValueId: parseJsonInt(json['attribute_value_id']),
      value: parseJsonString(json['value']),
      code: parseJsonString(json['code']),
    );
  }

  JsonMap toJson() => {
    'attribute_id': attributeId,
    'attribute': attribute,
    'attribute_value_id': attributeValueId,
    'value': value,
    'code': code,
  };
}

class GetEditProductAttributeGroupModel {
  const GetEditProductAttributeGroupModel({
    this.attributeId,
    this.name,
    this.inputType,
    this.values = const [],
  });

  final int? attributeId;
  final String? name;
  final String? inputType;
  final List<GetEditProductAttributeGroupValueModel> values;

  factory GetEditProductAttributeGroupModel.fromJson(JsonMap? json) {
    if (json == null) {
      return const GetEditProductAttributeGroupModel();
    }

    return GetEditProductAttributeGroupModel(
      attributeId: parseJsonInt(json['attribute_id']),
      name: parseJsonString(json['name']),
      inputType: parseJsonString(json['input_type']),
      values: parseJsonList(
        json['values'],
        GetEditProductAttributeGroupValueModel.fromJson,
      ),
    );
  }

  JsonMap toJson() => {
    'attribute_id': attributeId,
    'name': name,
    'input_type': inputType,
    'values': values.map((e) => e.toJson()).toList(),
  };
}

class GetEditProductAttributeGroupValueModel {
  const GetEditProductAttributeGroupValueModel({
    this.attributeValueId,
    this.value,
    this.code,
    this.priceModifier,
  });

  final int? attributeValueId;
  final String? value;
  final String? code;
  final num? priceModifier;

  factory GetEditProductAttributeGroupValueModel.fromJson(JsonMap? json) {
    if (json == null) {
      return const GetEditProductAttributeGroupValueModel();
    }

    return GetEditProductAttributeGroupValueModel(
      attributeValueId: parseJsonInt(json['attribute_value_id']),
      value: parseJsonString(json['value']),
      code: parseJsonString(json['code']),
      priceModifier: parseJsonNum(json['price_modifier']),
    );
  }

  JsonMap toJson() => {
    'attribute_value_id': attributeValueId,
    'value': value,
    'code': code,
    'price_modifier': priceModifier,
  };
}

class GetEditProductCategoryModel {
  const GetEditProductCategoryModel({this.id, this.name});

  final int? id;
  final String? name;

  factory GetEditProductCategoryModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductCategoryModel();

    return GetEditProductCategoryModel(
      id: parseJsonInt(json['id']),
      name: parseJsonString(json['name']),
    );
  }

  JsonMap toJson() => {'id': id, 'name': name};
}

class GetEditProductGalleryModel {
  const GetEditProductGalleryModel({this.id, this.image, this.sortOrder});

  final int? id;
  final String? image;
  final int? sortOrder;

  factory GetEditProductGalleryModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductGalleryModel();

    return GetEditProductGalleryModel(
      id: parseJsonInt(json['id']),
      image: parseJsonString(json['image']),
      sortOrder: parseJsonInt(json['sort_order']),
    );
  }

  JsonMap toJson() => {'id': id, 'image': image, 'sort_order': sortOrder};
}

class GetEditProductAttributeModel {
  const GetEditProductAttributeModel({
    this.id,
    this.attributeId,
    this.name,
    this.inputType,
    this.isRequired = false,
    this.displayOrder,
    this.values = const [],
  });

  final int? id;
  final int? attributeId;
  final String? name;
  final String? inputType;
  final bool isRequired;
  final int? displayOrder;
  final List<GetEditProductAttributeValueModel> values;

  factory GetEditProductAttributeModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductAttributeModel();

    return GetEditProductAttributeModel(
      id: parseJsonInt(json['id']),
      attributeId: parseJsonInt(json['attribute_id']),
      name: parseJsonString(json['name']),
      inputType: parseJsonString(json['input_type']),
      isRequired: parseJsonBool(json['is_required']),
      displayOrder: parseJsonInt(json['display_order']),
      values: parseJsonList(
        json['values'],
        GetEditProductAttributeValueModel.fromJson,
      ),
    );
  }

  JsonMap toJson() => {
    'id': id,
    'attribute_id': attributeId,
    'name': name,
    'input_type': inputType,
    'is_required': isRequired,
    'display_order': displayOrder,
    'values': values.map((e) => e.toJson()).toList(),
  };
}

class GetEditProductAttributeValueModel {
  const GetEditProductAttributeValueModel({
    this.id,
    this.attributeValueId,
    this.value,
    this.code,
    this.priceModifier,
  });

  final int? id;
  final int? attributeValueId;
  final String? value;
  final String? code;
  final num? priceModifier;

  factory GetEditProductAttributeValueModel.fromJson(JsonMap? json) {
    if (json == null) {
      return const GetEditProductAttributeValueModel();
    }

    return GetEditProductAttributeValueModel(
      id: parseJsonInt(json['id']),
      attributeValueId: parseJsonInt(json['attribute_value_id']),
      value: parseJsonString(json['value']),
      code: parseJsonString(json['code']),
      priceModifier: parseJsonNum(json['price_modifier']),
    );
  }

  JsonMap toJson() => {
    'id': id,
    'attribute_value_id': attributeValueId,
    'value': value,
    'code': code,
    'price_modifier': priceModifier,
  };
}

class GetEditProductCampaignModel {
  const GetEditProductCampaignModel({
    this.id,
    this.name,
    this.campaignType,
    this.status,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.eventId,
  });

  final int? id;
  final String? name;
  final String? campaignType;
  final String? status;
  final num? discountPercentage;
  final String? startDate;
  final String? endDate;
  final int? eventId;

  factory GetEditProductCampaignModel.fromJson(JsonMap? json) {
    if (json == null) return const GetEditProductCampaignModel();

    return GetEditProductCampaignModel(
      id: parseJsonInt(json['id']),
      name: parseJsonString(json['name']),
      campaignType: parseJsonString(json['campaign_type']),
      status: parseJsonString(json['status']),
      discountPercentage: parseJsonNum(json['discount_percentage']),
      startDate: parseJsonString(json['start_date']),
      endDate: parseJsonString(json['end_date']),
      eventId: parseJsonInt(json['event_id']),
    );
  }

  JsonMap toJson() => {
    'id': id,
    'name': name,
    'campaign_type': campaignType,
    'status': status,
    'discount_percentage': discountPercentage,
    'start_date': startDate,
    'end_date': endDate,
    'event_id': eventId,
  };
}

class GetEditProductTranslationModel {
  const GetEditProductTranslationModel({
    this.nameAr,
    this.shortDescriptionAr,
    this.descriptionAr,
    this.metaTitleAr,
    this.metaDescriptionAr,
    this.metaKeywordsAr,
  });

  final String? nameAr;
  final String? shortDescriptionAr;
  final String? descriptionAr;
  final String? metaTitleAr;
  final String? metaDescriptionAr;
  final String? metaKeywordsAr;

  factory GetEditProductTranslationModel.fromJson(JsonMap? json) {
    if (json == null) {
      return const GetEditProductTranslationModel();
    }

    return GetEditProductTranslationModel(
      nameAr: parseJsonString(json['name_ar']),
      shortDescriptionAr: parseJsonString(json['short_description_ar']),
      descriptionAr: parseJsonString(json['description_ar']),
      metaTitleAr: parseJsonString(json['meta_title_ar']),
      metaDescriptionAr: parseJsonString(json['meta_description_ar']),
      metaKeywordsAr: parseJsonString(json['meta_keywords_ar']),
    );
  }

  JsonMap toJson() => {
    'name_ar': nameAr,
    'short_description_ar': shortDescriptionAr,
    'description_ar': descriptionAr,
    'meta_title_ar': metaTitleAr,
    'meta_description_ar': metaDescriptionAr,
    'meta_keywords_ar': metaKeywordsAr,
  };
}
