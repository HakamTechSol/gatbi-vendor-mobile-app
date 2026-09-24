class GetEditProductModel {
  const GetEditProductModel({
    this.success = false,
    this.product,
    this.translation,
  });

  final bool success;
  final GetEditProductItemModel? product;
  final GetEditProductTranslationModel? translation;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetEditProductModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductModel();
    }

    return GetEditProductModel(
      success: _parseBool(json['success']),
      product: json['product'] is Map
          ? GetEditProductItemModel.fromJson(
              Map<String, dynamic>.from(
                json['product'] as Map,
              ),
            )
          : null,
      translation: json['translation'] is Map
          ? GetEditProductTranslationModel.fromJson(
              Map<String, dynamic>.from(
                json['translation'] as Map,
              ),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'product': product?.toJson(),
      'translation': translation?.toJson(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ================================================================
// Product
// ================================================================

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
    this.priceOld,
    this.isActive = false,
    this.gallery = const [],
    this.attributes = const [],
    this.campaigns = const [],
  });

  // ============================================================
  // Basic Product Fields
  // ============================================================

  final int? id;

  final String? name;

  final String? slug;

  final String? description;

  final String? shortDescription;

  // ============================================================
  // Pricing
  // ============================================================

  final num? price;

  final num? regularPrice;

  final num? salePrice;

  final String? currency;

  final String? currencySymbol;

  // ============================================================
  // Stock
  // ============================================================

  final String? stockStatus;

  final int? stockQuantity;

  // ============================================================
  // Product Flags
  // ============================================================

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

  // ============================================================
  // Image
  // ============================================================

  final String? image;

  // ============================================================
  // Merchant
  // ============================================================

  final int? merchantId;

  final String? merchantName;

  // ============================================================
  // Dates
  // ============================================================

  final String? createdAt;

  final String? updatedAt;

  // ============================================================
  // Variants
  // ============================================================

  final List<GetEditProductVariantModel> variants;

  // ============================================================
  // Base Pricing
  // ============================================================

  final num? basePrice;

  final num? basePriceOld;

  final num? dealRate;

  // ============================================================
  // Attribute Groups
  // ============================================================

  final List<GetEditProductAttributeGroupModel> attributeGroups;

  // ============================================================
  // Price Range
  // ============================================================

  final num? priceMin;

  final num? priceMax;

  final num? priceFrom;

  // ============================================================
  // Category
  // ============================================================

  final GetEditProductCategoryModel? category;

  // ============================================================
  // SKU / Brand
  // ============================================================

  final String? sku;

  final String? brand;

  final num? priceOld;

  // ============================================================
  // Status
  // ============================================================

  final bool isActive;

  // ============================================================
  // Gallery
  // ============================================================

  final List<GetEditProductGalleryModel> gallery;

  // ============================================================
  // Product Attributes
  // ============================================================

  final List<GetEditProductAttributeModel> attributes;

  // ============================================================
  // Campaigns
  // ============================================================

  final List<dynamic> campaigns;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetEditProductItemModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductItemModel();
    }

    return GetEditProductItemModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      description: _parseString(json['description']),
      shortDescription: _parseString(
        json['short_description'],
      ),

      price: _parseNum(json['price']),
      regularPrice: _parseNum(json['regular_price']),
      salePrice: _parseNum(json['sale_price']),

      currency: _parseString(json['currency']),
      currencySymbol: _parseString(
        json['currency_symbol'],
      ),

      stockStatus: _parseString(
        json['stock_status'],
      ),

      stockQuantity: _parseInt(
        json['stock_quantity'],
      ),

      hasVariants: _parseBool(
        json['has_variants'],
      ),

      rating: _parseNum(json['rating']),

      reviewCount: _parseInt(
        json['review_count'],
      ),

      onSale: _parseBool(
        json['on_sale'],
      ),

      isFlashDeal: _parseBool(
        json['is_flash_deal'],
      ),

      flashDealPrice: _parseNum(
        json['flash_deal_price'],
      ),

      flashDealEnd: _parseString(
        json['flash_deal_end'],
      ),

      dealCampaignId: _parseInt(
        json['deal_campaign_id'],
      ),

      dealDiscountPercentage: _parseNum(
        json['deal_discount_percentage'],
      ),

      dealEventName: _parseString(
        json['deal_event_name'],
      ),

      dealEventSlug: _parseString(
        json['deal_event_slug'],
      ),

      featured: _parseBool(
        json['featured'],
      ),

      image: _parseString(
        json['image'],
      ),

      merchantId: _parseInt(
        json['merchant_id'],
      ),

      merchantName: _parseString(
        json['merchant_name'],
      ),

      createdAt: _parseString(
        json['created_at'],
      ),

      updatedAt: _parseString(
        json['updated_at'],
      ),

      variants: _parseList(
        json['variants'],
        GetEditProductVariantModel.fromJson,
      ),

      basePrice: _parseNum(
        json['base_price'],
      ),

      basePriceOld: _parseNum(
        json['base_price_old'],
      ),

      dealRate: _parseNum(
        json['deal_rate'],
      ),

      attributeGroups: _parseList(
        json['attribute_groups'],
        GetEditProductAttributeGroupModel.fromJson,
      ),

      priceMin: _parseNum(
        json['price_min'],
      ),

      priceMax: _parseNum(
        json['price_max'],
      ),

      priceFrom: _parseNum(
        json['price_from'],
      ),

      category: json['category'] is Map
          ? GetEditProductCategoryModel.fromJson(
              Map<String, dynamic>.from(
                json['category'] as Map,
              ),
            )
          : null,

      sku: _parseString(
        json['sku'],
      ),

      brand: _parseString(
        json['brand'],
      ),

      priceOld: _parseNum(
        json['price_old'],
      ),

      isActive: _parseBool(
        json['is_active'],
      ),

      gallery: _parseList(
        json['gallery'],
        GetEditProductGalleryModel.fromJson,
      ),

      attributes: _parseList(
        json['attributes'],
        GetEditProductAttributeModel.fromJson,
      ),

      campaigns: _parseDynamicList(
        json['campaigns'],
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
      'gallery': gallery.map((e) => e.toJson()).toList(),
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'campaigns': campaigns,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
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

  static List<dynamic> _parseDynamicList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return List<dynamic>.from(value);
  }
}

// ================================================================
// Product Variant
// ================================================================

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

  /// Example:
  /// {
  ///   "3": 6,
  ///   "4": 9
  /// }
  final Map<String, dynamic> attributes;

  final List<GetEditProductOptionValueModel> optionValues;

  factory GetEditProductVariantModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductVariantModel();
    }

    return GetEditProductVariantModel(
      id: _parseInt(json['id']),
      sku: _parseString(json['sku']),
      price: _parseNum(json['price']),
      priceOld: _parseNum(json['price_old']),
      stockQty: _parseInt(json['stock_qty']),
      weight: _parseNum(json['weight']),
      barcode: _parseString(json['barcode']),
      isActive: _parseBool(json['is_active']),
      isPriceOverride: _parseBool(
        json['is_price_override'],
      ),
      attributes: _parseMap(json['attributes']),
      optionValues: _parseList(
        json['option_values'],
        GetEditProductOptionValueModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'option_values':
          optionValues.map((e) => e.toJson()).toList(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }

    return Map<String, dynamic>.from(value);
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

// ================================================================
// Variant Option Value
// ================================================================

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

  factory GetEditProductOptionValueModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductOptionValueModel();
    }

    return GetEditProductOptionValueModel(
      attributeId: _parseInt(
        json['attribute_id'],
      ),
      attribute: _parseString(
        json['attribute'],
      ),
      attributeValueId: _parseInt(
        json['attribute_value_id'],
      ),
      value: _parseString(
        json['value'],
      ),
      code: _parseString(
        json['code'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'attribute': attribute,
      'attribute_value_id': attributeValueId,
      'value': value,
      'code': code,
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ================================================================
// Attribute Group
// ================================================================

class GetEditProductAttributeGroupModel {
  const GetEditProductAttributeGroupModel({
    this.attributeId,
    this.name,
    this.values = const [],
  });

  final int? attributeId;

  final String? name;

  final List<GetEditProductAttributeGroupValueModel> values;

  factory GetEditProductAttributeGroupModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductAttributeGroupModel();
    }

    return GetEditProductAttributeGroupModel(
      attributeId: _parseInt(
        json['attribute_id'],
      ),
      name: _parseString(
        json['name'],
      ),
      values: _parseList(
        json['values'],
        GetEditProductAttributeGroupValueModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'name': name,
      'values': values.map((e) => e.toJson()).toList(),
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
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

// ================================================================
// Attribute Group Value
// ================================================================

class GetEditProductAttributeGroupValueModel {
  const GetEditProductAttributeGroupValueModel({
    this.attributeValueId,
    this.value,
    this.priceModifier,
  });

  final int? attributeValueId;

  final String? value;

  final num? priceModifier;

  factory GetEditProductAttributeGroupValueModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductAttributeGroupValueModel();
    }

    return GetEditProductAttributeGroupValueModel(
      attributeValueId: _parseInt(
        json['attribute_value_id'],
      ),
      value: _parseString(
        json['value'],
      ),
      priceModifier: _parseNum(
        json['price_modifier'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_value_id': attributeValueId,
      'value': value,
      'price_modifier': priceModifier,
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ================================================================
// Product Category
// ================================================================

class GetEditProductCategoryModel {
  const GetEditProductCategoryModel({
    this.id,
    this.name,
  });

  final int? id;

  final String? name;

  factory GetEditProductCategoryModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductCategoryModel();
    }

    return GetEditProductCategoryModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ================================================================
// Gallery
// ================================================================

class GetEditProductGalleryModel {
  const GetEditProductGalleryModel({
    this.id,
    this.image,
    this.sortOrder,
  });

  final int? id;

  final String? image;

  final int? sortOrder;

  factory GetEditProductGalleryModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductGalleryModel();
    }

    return GetEditProductGalleryModel(
      id: _parseInt(json['id']),
      image: _parseString(json['image']),
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'sort_order': sortOrder,
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ================================================================
// Product Attribute
// ================================================================

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

  factory GetEditProductAttributeModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductAttributeModel();
    }

    return GetEditProductAttributeModel(
      id: _parseInt(json['id']),
      attributeId: _parseInt(
        json['attribute_id'],
      ),
      name: _parseString(json['name']),
      inputType: _parseString(
        json['input_type'],
      ),
      isRequired: _parseBool(
        json['is_required'],
      ),
      displayOrder: _parseInt(
        json['display_order'],
      ),
      values: _parseList(
        json['values'],
        GetEditProductAttributeValueModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_id': attributeId,
      'name': name,
      'input_type': inputType,
      'is_required': isRequired,
      'display_order': displayOrder,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes';
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
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

// ================================================================
// Product Attribute Value
// ================================================================

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

  factory GetEditProductAttributeValueModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductAttributeValueModel();
    }

    return GetEditProductAttributeValueModel(
      id: _parseInt(json['id']),
      attributeValueId: _parseInt(
        json['attribute_value_id'],
      ),
      value: _parseString(json['value']),
      code: _parseString(json['code']),
      priceModifier: _parseNum(
        json['price_modifier'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_value_id': attributeValueId,
      'value': value,
      'code': code,
      'price_modifier': priceModifier,
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ================================================================
// Translation
// ================================================================

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

  factory GetEditProductTranslationModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const GetEditProductTranslationModel();
    }

    return GetEditProductTranslationModel(
      nameAr: _parseString(json['name_ar']),
      shortDescriptionAr: _parseString(
        json['short_description_ar'],
      ),
      descriptionAr: _parseString(
        json['description_ar'],
      ),
      metaTitleAr: _parseString(
        json['meta_title_ar'],
      ),
      metaDescriptionAr: _parseString(
        json['meta_description_ar'],
      ),
      metaKeywordsAr: _parseString(
        json['meta_keywords_ar'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_ar': nameAr,
      'short_description_ar': shortDescriptionAr,
      'description_ar': descriptionAr,
      'meta_title_ar': metaTitleAr,
      'meta_description_ar': metaDescriptionAr,
      'meta_keywords_ar': metaKeywordsAr,
    };
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}