import 'dart:io';

class UpdateProductRequestModel {
  const UpdateProductRequestModel({
    this.name,
    this.heroImage,
    this.galleryImages,
    this.price,
    this.priceOld,
    this.stockQty,
    this.categoryId,
    this.brand,
    this.brandId,
    this.sku,
    this.weight,
    this.description,
    this.shortDescription,
    this.allowAffiliate,
    this.hasVariants,
    this.variantAttributes,
    this.attributeValues,
    this.attributeValueModifiers,
    this.variants,
    this.isFeatured,
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
  // Basic Product Information
  // ============================================================

  final String? name;

  final String? description;

  final String? shortDescription;

  final String? sku;

  // ============================================================
  // Product Image
  // ============================================================

  /// New hero image.
  ///
  /// If null:
  /// Existing hero image remains unchanged.
  final File? heroImage;

  /// New gallery images.
  ///
  /// If null:
  /// Existing gallery remains unchanged.
  ///
  /// Update API field:
  /// images[]
  final List<File>? galleryImages;

  // ============================================================
  // Pricing
  // ============================================================

  final num? price;

  final num? priceOld;

  // ============================================================
  // Inventory
  // ============================================================

  final int? stockQty;

  // ============================================================
  // Category
  // ============================================================

  final int? categoryId;

  // ============================================================
  // Brand
  // ============================================================

  final String? brand;

  final int? brandId;

  // ============================================================
  // Physical Product
  // ============================================================

  final num? weight;

  // ============================================================
  // Affiliate
  // ============================================================

  final bool? allowAffiliate;

  // ============================================================
  // Featured
  // ============================================================

  final bool? isFeatured;

  // ============================================================
  // Variants
  // ============================================================

  /// Whether product uses variants.
  ///
  /// If null:
  /// Existing variant configuration remains unchanged.
  final bool? hasVariants;

  /// Selected attribute IDs.
  ///
  /// Example:
  /// [4, 3]
  final List<int>? variantAttributes;

  /// Product attribute values.
  ///
  /// Example:
  ///
  /// {
  ///   4: [9, 12],
  ///   3: [6],
  /// }
  final Map<int, List<int>>? attributeValues;

  /// Attribute value price modifiers.
  ///
  /// Example:
  ///
  /// {
  ///   9: 10,
  /// }
  final Map<int, num>? attributeValueModifiers;

  /// Variant matrix.
  final List<UpdateProductVariantRequestModel>? variants;

  // ============================================================
  // Arabic
  // ============================================================

  final String? nameAr;

  final String? shortDescriptionAr;

  final String? descriptionAr;

  // ============================================================
  // SEO
  // ============================================================

  final String? metaTitle;

  final String? metaDescription;

  final String? metaKeywords;

  final String? metaTitleAr;

  final String? metaDescriptionAr;

  final String? metaKeywordsAr;
}

// ============================================================
// Update Product Variant Request Model
// ============================================================

class UpdateProductVariantRequestModel {
  const UpdateProductVariantRequestModel({
    this.sku,
    this.price,
    this.priceOld,
    this.stockQty,
    this.isActive,
    this.attributeValues,
  });

  // ============================================================
  // Variant Basic Fields
  // ============================================================

  final String? sku;

  final num? price;

  final num? priceOld;

  final int? stockQty;

  // ============================================================
  // Variant Status
  // ============================================================

  /// Variant active status.
  ///
  /// Optional during update.
  ///
  /// If null, the field will NOT be sent.
  final int? isActive;

  // ============================================================
  // Variant Attribute Values
  // ============================================================

  final Map<int, int>? attributeValues;
}