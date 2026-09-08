import 'product_attribute_model.dart';
import 'product_variant_model.dart';

class ProductFormModel {
  const ProductFormModel({
    this.id,

    // Basic Information
    this.name = '',
    this.shortDescription = '',
    this.description = '',
    this.allowAffiliates = false,

    // Arabic Translation
    this.nameAr = '',
    this.shortDescriptionAr = '',
    this.descriptionAr = '',
    this.arabicMetaTitle = '',
    this.arabicMetaKeywords = '',
    this.arabicMetaDescription = '',

    // Pricing & Inventory
    this.price,
    this.compareAtPrice,
    this.costPrice,
    this.sku = '',
    this.stockQuantity = 0,

    // Product Classification
    this.categoryId,
    this.brandId,

    // Images
    this.mainImage,
    this.galleryImages = const [],

    // Variants
    this.hasVariants = false,
    this.attributes = const [],
    this.variants = const [],

    // SEO
    this.metaTitle = '',
    this.metaDescription = '',
    this.metaKeywords = '',

    // Status
    this.isActive = true,
  });

  final int? id;

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  final String name;
  final String shortDescription;
  final String description;
  final bool allowAffiliates;

  // ═══════════════════════════════════════════════════════════════════════════
  // ARABIC TRANSLATION
  // ═══════════════════════════════════════════════════════════════════════════

  final String nameAr;
  final String shortDescriptionAr;
  final String descriptionAr;
  final String arabicMetaTitle;
  final String arabicMetaKeywords;
  final String arabicMetaDescription;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICING & INVENTORY
  // ═══════════════════════════════════════════════════════════════════════════

  final double? price;
  final double? compareAtPrice;
  final double? costPrice;

  final String sku;
  final int stockQuantity;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT CLASSIFICATION
  // ═══════════════════════════════════════════════════════════════════════════

  final int? categoryId;
  final int? brandId;

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main product image.
  final String? mainImage;

  /// Product gallery.
  final List<String> galleryImages;

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  final bool hasVariants;

  final List<ProductAttributeModel> attributes;

  final List<ProductVariantModel> variants;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEO
  // ═══════════════════════════════════════════════════════════════════════════

  final String metaTitle;
  final String metaDescription;
  final String metaKeywords;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  final bool isActive;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  bool get hasStock {
    if (hasVariants) {
      return variants.any(
        (variant) => variant.isActive && variant.stockQuantity > 0,
      );
    }

    return stockQuantity > 0;
  }

  int get totalVariantStock {
    return variants.fold<int>(
      0,
      (total, variant) => total + variant.stockQuantity,
    );
  }

  ProductFormModel copyWith({
    int? id,

    String? name,
    String? shortDescription,
    String? description,
    bool? allowAffiliates,

    String? nameAr,
    String? shortDescriptionAr,
    String? descriptionAr,

    double? price,
    double? compareAtPrice,
    double? costPrice,
    String? sku,
    int? stockQuantity,

    int? categoryId,
    int? brandId,

    String? mainImage,
    List<String>? galleryImages,

    bool? hasVariants,
    List<ProductAttributeModel>? attributes,
    List<ProductVariantModel>? variants,

    String? metaTitle,
    String? metaDescription,
    String? metaKeywords,

    bool? isActive,
  }) {
    return ProductFormModel(
      id: id ?? this.id,

      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      allowAffiliates: allowAffiliates ?? this.allowAffiliates,

      nameAr: nameAr ?? this.nameAr,
      shortDescriptionAr: shortDescriptionAr ?? this.shortDescriptionAr,
      descriptionAr: descriptionAr ?? this.descriptionAr,

      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      costPrice: costPrice ?? this.costPrice,
      sku: sku ?? this.sku,
      stockQuantity: stockQuantity ?? this.stockQuantity,

      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,

      mainImage: mainImage ?? this.mainImage,
      galleryImages: galleryImages ?? this.galleryImages,

      hasVariants: hasVariants ?? this.hasVariants,
      attributes: attributes ?? this.attributes,
      variants: variants ?? this.variants,

      metaTitle: metaTitle ?? this.metaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      metaKeywords: metaKeywords ?? this.metaKeywords,

      isActive: isActive ?? this.isActive,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // JSON
  // ═══════════════════════════════════════════════════════════════════════════

  factory ProductFormModel.fromJson(Map<String, dynamic> json) {
    return ProductFormModel(
      id: _parseNullableInt(json['id']),

      name: json['name']?.toString() ?? '',
      shortDescription:
          json['short_description']?.toString() ??
          json['shortDescription']?.toString() ??
          '',
      description: json['description']?.toString() ?? '',
      allowAffiliates: _parseBool(
        json['allow_affiliates'] ?? json['allowAffiliates'],
        defaultValue: false,
      ),

      nameAr:
          json['name_ar']?.toString() ?? json['arabic_name']?.toString() ?? '',
      shortDescriptionAr: json['short_description_ar']?.toString() ?? '',
      descriptionAr: json['description_ar']?.toString() ?? '',

      price: _parseNullableDouble(json['price']),
      compareAtPrice: _parseNullableDouble(
        json['compare_at_price'] ??
            json['compareAtPrice'] ??
            json['original_price'],
      ),
      costPrice: _parseNullableDouble(json['cost_price'] ?? json['costPrice']),

      sku: json['sku']?.toString() ?? '',

      stockQuantity: _parseInt(
        json['stock_quantity'] ?? json['stock'] ?? json['quantity'],
      ),

      categoryId: _parseNullableInt(json['category_id'] ?? json['categoryId']),

      brandId: _parseNullableInt(json['brand_id'] ?? json['brandId']),

      mainImage: json['main_image']?.toString() ?? json['image']?.toString(),

      galleryImages: _parseStringList(
        json['gallery_images'] ?? json['gallery'],
      ),

      hasVariants: _parseBool(
        json['has_variants'] ?? json['hasVariants'],
        defaultValue: false,
      ),

      attributes: _parseAttributes(json['attributes']),

      variants: _parseVariants(json['variants']),

      metaTitle: json['meta_title']?.toString() ?? '',
      metaDescription: json['meta_description']?.toString() ?? '',
      metaKeywords: json['meta_keywords']?.toString() ?? '',

      isActive: _parseBool(
        json['is_active'] ?? json['active'],
        defaultValue: true,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,

      'name': name,
      'short_description': shortDescription,
      'description': description,
      'allow_affiliates': allowAffiliates,

      'name_ar': nameAr,
      'short_description_ar': shortDescriptionAr,
      'description_ar': descriptionAr,

      if (price != null) 'price': price,
      if (compareAtPrice != null) 'compare_at_price': compareAtPrice,
      if (costPrice != null) 'cost_price': costPrice,

      'sku': sku,
      'stock_quantity': stockQuantity,

      if (categoryId != null) 'category_id': categoryId,

      if (brandId != null) 'brand_id': brandId,

      if (mainImage != null) 'main_image': mainImage,

      'gallery_images': galleryImages,

      'has_variants': hasVariants,

      'attributes': attributes.map((attribute) => attribute.toJson()).toList(),

      'variants': variants.map((variant) => variant.toJson()).toList(),

      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,

      'is_active': isActive,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARSERS
  // ═══════════════════════════════════════════════════════════════════════════

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value, {required bool defaultValue}) {
    if (value is bool) return value;

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }

      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }

    return defaultValue;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => item?.toString() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static List<ProductAttributeModel> _parseAttributes(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) =>
              ProductAttributeModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static List<ProductVariantModel> _parseVariants(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) =>
              ProductVariantModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
