import 'dart:io';

class AddProductRequestModel {
  const AddProductRequestModel({
    required this.name,
    required this.heroImage,
    required this.categoryId,
    required this.price,
    required this.stockQty,

    // ==========================================================
    // STATUS
    // ==========================================================
    this.isActive = 1,

    this.galleryImages = const [],
    this.priceOld,
    this.sku,
    this.brand,
    this.brandId,
    this.description,
    this.shortDescription,
    this.allowAffiliate = false,
    this.hasVariants = false,
    this.variantAttributes = const [],
    this.attributeValues = const {},
    this.attributeValueModifiers = const {},
    this.variants = const [],
    this.nameAr,
    this.shortDescriptionAr,
    this.descriptionAr,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.metaTitleAr,
    this.metaDescriptionAr,
    this.metaKeywordsAr,
  });

  // ============================================================
  // Required Fields
  // ============================================================

  final String name;

  final File heroImage;

  final int categoryId;

  final num price;

  final int stockQty;

  // ============================================================
  // Product Status
  // ============================================================

  /// Product active status.
  ///
  /// API value:
  /// 1 = Active
  /// 0 = Inactive
  ///
  /// Default:
  /// 1
  final int isActive;

  // ============================================================
  // Images
  // ============================================================

  final List<File> galleryImages;

  // ============================================================
  // Pricing
  // ============================================================

  final num? priceOld;

  // ============================================================
  // Basic Product Information
  // ============================================================

  final String? sku;

  final String? brand;

  /// Existing brand ID.
  final int? brandId;

  final String? description;

  final String? shortDescription;

  // ============================================================
  // Affiliate
  // ============================================================

  final bool allowAffiliate;

  // ============================================================
  // Variants
  // ============================================================

  final bool hasVariants;

  final List<int> variantAttributes;

  final Map<int, List<int>> attributeValues;

  final Map<int, num> attributeValueModifiers;

  /// Variant matrix.
  final List<AddProductVariantRequestModel> variants;

  // ============================================================
  // Arabic / SEO
  // ============================================================

  final String? nameAr;

  final String? shortDescriptionAr;

  final String? descriptionAr;

  final String? metaTitle;

  final String? metaDescription;

  final String? metaKeywords;

  final String? metaTitleAr;

  final String? metaDescriptionAr;

  final String? metaKeywordsAr;
}

// ============================================================
// Variant Request Model
// ============================================================

class AddProductVariantRequestModel {
  const AddProductVariantRequestModel({
    this.sku,
    required this.price,
    this.priceOld,
    required this.stockQty,

    // ==========================================================
    // STATUS
    // ==========================================================
    this.isActive = 1,

    this.attributeValues = const {},
  });

  // ============================================================
  // Variant Basic Fields
  // ============================================================

  final String? sku;

  final num price;

  final num? priceOld;

  final int stockQty;

  // ============================================================
  // Variant Status
  // ============================================================

  /// Variant active status.
  ///
  /// API value:
  /// 1 = Active
  /// 0 = Inactive
  ///
  /// Default:
  /// 1
  final int isActive;

  // ============================================================
  // Variant Attribute Values
  // ============================================================

  final Map<int, int> attributeValues;
}
