/// Product Detail Model
///
/// Designed for:
/// 1. Dummy/local UI data
/// 2. API JSON data later
///
/// UI should not need to change when API integration starts.
/// Only repository/API layer will provide ProductDetailModel.fromJson().
class ProductDetailModel {
  const ProductDetailModel({
    required this.id,
    required this.productName,

    // Basic Information
    this.shortDescription,
    this.fullDescription,
    this.arabicName,
    this.arabicShortDescription,
    this.arabicFullDescription,
    this.allowAffiliates = false,

    // Pricing & Inventory
    this.price,
    this.compareAtPrice,
    this.costPrice,
    this.stock = 0,
    this.sku,
    this.inventoryType,

    // Category / Brand
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,

    // Status
    this.status = 'Active',
    this.isFeatured = false,
    this.isTrending = false,
    this.isFlashDeal = false,

    // Sales / Analytics
    this.totalSales = 0,
    this.views = 0,

    // Images
    this.images = const [],

    // SEO
    this.slug,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.arabicMetaTitle,
    this.arabicMetaDescription,
    this.arabicMetaKeywords,

    // Variants
    this.variants = const [],

    // Dates
    this.createdAt,
    this.updatedAt,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  final int id;

  final String productName;

  final String? shortDescription;

  final String? fullDescription;

  final String? arabicName;

  final String? arabicShortDescription;

  final String? arabicFullDescription;

  final bool allowAffiliates;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICING & INVENTORY
  // ═══════════════════════════════════════════════════════════════════════════

  final double? price;

  final double? compareAtPrice;

  final double? costPrice;

  final int stock;

  final String? sku;

  final String? inventoryType;

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY / BRAND
  // ═══════════════════════════════════════════════════════════════════════════

  final int? categoryId;

  final String? categoryName;

  final int? brandId;

  final String? brandName;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  final String status;

  final bool isFeatured;

  final bool isTrending;

  final bool isFlashDeal;

  // ═══════════════════════════════════════════════════════════════════════════
  // SALES / ANALYTICS
  // ═══════════════════════════════════════════════════════════════════════════

  final int totalSales;

  final int views;

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGES
  // ═══════════════════════════════════════════════════════════════════════════

  final List<String> images;

  // ═══════════════════════════════════════════════════════════════════════════
  // SEO
  // ═══════════════════════════════════════════════════════════════════════════

  final String? slug;

  final String? metaTitle;

  final String? metaDescription;

  final String? metaKeywords;

  final String? arabicMetaTitle;

  final String? arabicMetaDescription;

  final String? arabicMetaKeywords;

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  final List<ProductVariantModel> variants;

  // ═══════════════════════════════════════════════════════════════════════════
  // DATES
  // ═══════════════════════════════════════════════════════════════════════════

  final DateTime? createdAt;

  final DateTime? updatedAt;

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPUTED VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  bool get isInStock => stock > 0;

  bool get isLowStock => stock > 0 && stock <= 10;

  bool get isOutOfStock => stock <= 0;

  bool get hasComparePrice =>
      compareAtPrice != null && price != null && compareAtPrice! > price!;

  bool get hasImages => images.isNotEmpty;

  bool get hasVariants => variants.isNotEmpty;

  bool get hasArabicContent =>
      (arabicName?.trim().isNotEmpty ?? false) ||
      (arabicShortDescription?.trim().isNotEmpty ?? false) ||
      (arabicFullDescription?.trim().isNotEmpty ?? false);

  bool get hasSeo =>
      (metaTitle?.trim().isNotEmpty ?? false) ||
      (metaDescription?.trim().isNotEmpty ?? false) ||
      (metaKeywords?.trim().isNotEmpty ?? false);

  // ═══════════════════════════════════════════════════════════════════════════
  // FROM JSON
  // ═══════════════════════════════════════════════════════════════════════════

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final categoryValue = json['category'];
    final brandValue = json['brand'];

    return ProductDetailModel(
      id: _toInt(json['id']) ?? 0,

      // Basic Information
      productName:
          _toString(
            json['product_name'] ?? json['productName'] ?? json['name'],
          ) ??
          '',

      shortDescription: _toString(
        json['short_description'] ?? json['shortDescription'],
      ),

      fullDescription: _toString(
        json['full_description'] ?? json['fullDescription'],
      ),

      arabicName: _toString(json['arabic_name'] ?? json['arabicName']),

      arabicShortDescription: _toString(
        json['arabic_short_description'] ?? json['arabicShortDescription'],
      ),

      arabicFullDescription: _toString(
        json['arabic_full_description'] ?? json['arabicFullDescription'],
      ),

      allowAffiliates: _toBool(
        json['allow_affiliates'] ?? json['allowAffiliates'],
      ),

      // Pricing
      price: _toDouble(json['price']),

      compareAtPrice: _toDouble(
        json['compare_at_price'] ?? json['compareAtPrice'],
      ),

      costPrice: _toDouble(json['cost_price'] ?? json['costPrice']),

      stock:
          _toInt(
            json['stock'] ?? json['stock_quantity'] ?? json['stockQuantity'],
          ) ??
          0,

      sku: _toString(json['sku']),

      inventoryType: _toString(json['inventory_type'] ?? json['inventoryType']),

      // Category
      categoryId: _toInt(json['category_id'] ?? json['categoryId']),

      categoryName: _toString(
        json['category_name'] ??
            json['categoryName'] ??
            (categoryValue is String ? categoryValue : null),
      ),

      // Brand
      brandId: _toInt(json['brand_id'] ?? json['brandId']),

      brandName: _toString(
        json['brand_name'] ??
            json['brandName'] ??
            (brandValue is String ? brandValue : null),
      ),

      // Status
      status: _toString(json['status']) ?? 'Active',

      isFeatured: _toBool(
        json['featured'] ?? json['is_featured'] ?? json['isFeatured'],
      ),

      isTrending: _toBool(
        json['trending'] ?? json['is_trending'] ?? json['isTrending'],
      ),

      isFlashDeal: _toBool(
        json['flash_deal'] ?? json['is_flash_deal'] ?? json['isFlashDeal'],
      ),

      // Analytics
      totalSales:
          _toInt(json['total_sales'] ?? json['totalSales'] ?? json['sales']) ??
          0,

      views: _toInt(json['views']) ?? 0,

      // Images
      images: _parseImages(
        json['images'] ?? json['product_images'] ?? json['productImages'],
      ),

      // SEO
      slug: _toString(json['slug']),

      metaTitle: _toString(json['meta_title'] ?? json['metaTitle']),

      metaDescription: _toString(
        json['meta_description'] ?? json['metaDescription'],
      ),

      metaKeywords: _toString(json['meta_keywords'] ?? json['metaKeywords']),

      arabicMetaTitle: _toString(
        json['arabic_meta_title'] ?? json['arabicMetaTitle'],
      ),

      arabicMetaDescription: _toString(
        json['arabic_meta_description'] ?? json['arabicMetaDescription'],
      ),

      arabicMetaKeywords: _toString(
        json['arabic_meta_keywords'] ?? json['arabicMetaKeywords'],
      ),

      // Variants
      variants: _parseVariants(
        json['variants'] ??
            json['variant_attributes'] ??
            json['variantAttributes'],
      ),

      // Dates
      createdAt: _toDateTime(json['created_at'] ?? json['createdAt']),

      updatedAt: _toDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TO JSON
  // ═══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      // Basic Information
      'product_name': productName,
      'short_description': shortDescription,
      'full_description': fullDescription,

      'arabic_name': arabicName,
      'arabic_short_description': arabicShortDescription,
      'arabic_full_description': arabicFullDescription,

      'allow_affiliates': allowAffiliates,

      // Pricing
      'price': price,
      'compare_at_price': compareAtPrice,
      'cost_price': costPrice,
      'stock': stock,
      'sku': sku,
      'inventory_type': inventoryType,

      // Category / Brand
      'category_id': categoryId,
      'category_name': categoryName,
      'brand_id': brandId,
      'brand_name': brandName,

      // Status
      'status': status,
      'featured': isFeatured,
      'trending': isTrending,
      'flash_deal': isFlashDeal,

      // Analytics
      'total_sales': totalSales,
      'views': views,

      // Images
      'images': images,

      // SEO
      'slug': slug,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,

      'arabic_meta_title': arabicMetaTitle,
      'arabic_meta_description': arabicMetaDescription,
      'arabic_meta_keywords': arabicMetaKeywords,

      // Variants
      'variants': variants.map((variant) => variant.toJson()).toList(),

      // Dates
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COPY WITH
  // ═══════════════════════════════════════════════════════════════════════════

  ProductDetailModel copyWith({
    int? id,
    String? productName,
    String? shortDescription,
    String? fullDescription,
    String? arabicName,
    String? arabicShortDescription,
    String? arabicFullDescription,
    bool? allowAffiliates,

    double? price,
    double? compareAtPrice,
    double? costPrice,
    int? stock,
    String? sku,
    String? inventoryType,

    int? categoryId,
    String? categoryName,
    int? brandId,
    String? brandName,

    String? status,
    bool? isFeatured,
    bool? isTrending,
    bool? isFlashDeal,

    int? totalSales,
    int? views,

    List<String>? images,

    String? slug,
    String? metaTitle,
    String? metaDescription,
    String? metaKeywords,
    String? arabicMetaTitle,
    String? arabicMetaDescription,
    String? arabicMetaKeywords,

    List<ProductVariantModel>? variants,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductDetailModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,

      shortDescription: shortDescription ?? this.shortDescription,

      fullDescription: fullDescription ?? this.fullDescription,

      arabicName: arabicName ?? this.arabicName,

      arabicShortDescription:
          arabicShortDescription ?? this.arabicShortDescription,

      arabicFullDescription:
          arabicFullDescription ?? this.arabicFullDescription,

      allowAffiliates: allowAffiliates ?? this.allowAffiliates,

      price: price ?? this.price,

      compareAtPrice: compareAtPrice ?? this.compareAtPrice,

      costPrice: costPrice ?? this.costPrice,

      stock: stock ?? this.stock,

      sku: sku ?? this.sku,

      inventoryType: inventoryType ?? this.inventoryType,

      categoryId: categoryId ?? this.categoryId,

      categoryName: categoryName ?? this.categoryName,

      brandId: brandId ?? this.brandId,

      brandName: brandName ?? this.brandName,

      status: status ?? this.status,

      isFeatured: isFeatured ?? this.isFeatured,

      isTrending: isTrending ?? this.isTrending,

      isFlashDeal: isFlashDeal ?? this.isFlashDeal,

      totalSales: totalSales ?? this.totalSales,

      views: views ?? this.views,

      images: images ?? this.images,

      slug: slug ?? this.slug,

      metaTitle: metaTitle ?? this.metaTitle,

      metaDescription: metaDescription ?? this.metaDescription,

      metaKeywords: metaKeywords ?? this.metaKeywords,

      arabicMetaTitle: arabicMetaTitle ?? this.arabicMetaTitle,

      arabicMetaDescription:
          arabicMetaDescription ?? this.arabicMetaDescription,

      arabicMetaKeywords: arabicMetaKeywords ?? this.arabicMetaKeywords,

      variants: variants ?? this.variants,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static String? _toString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static bool _toBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = value.toString().toLowerCase().trim();

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'active';
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  static List<String> _parseImages(dynamic value) {
    if (value == null) {
      return const [];
    }

    if (value is List) {
      return value
          .map((item) {
            if (item is String) {
              return item.trim();
            }

            if (item is Map) {
              final map = Map<String, dynamic>.from(item);

              return _toString(
                    map['url'] ??
                        map['image_url'] ??
                        map['imageUrl'] ??
                        map['path'],
                  ) ??
                  '';
            }

            return '';
          })
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }

    return const [];
  }

  static List<ProductVariantModel> _parseVariants(dynamic value) {
    if (value == null || value is! List) {
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

// ═════════════════════════════════════════════════════════════════════════════
// PRODUCT VARIANT MODEL
// ═════════════════════════════════════════════════════════════════════════════

class ProductVariantModel {
  const ProductVariantModel({required this.name, this.values = const []});

  final String name;

  final List<String> values;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] ?? json['options'] ?? json['items'];

    return ProductVariantModel(
      name:
          ProductDetailModel._toString(
            json['name'] ?? json['attribute_name'] ?? json['attributeName'],
          ) ??
          '',
      values: rawValues is List
          ? rawValues
                .map((value) => value.toString().trim())
                .where((value) => value.isNotEmpty)
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'values': values};
  }

  ProductVariantModel copyWith({String? name, List<String>? values}) {
    return ProductVariantModel(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }
}
