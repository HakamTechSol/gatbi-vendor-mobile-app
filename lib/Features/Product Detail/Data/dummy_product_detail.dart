import '../Model/product_detail_model.dart';

/// Dummy Product Detail Data
///
/// UI development ke waqt API ki jagah ye data use hoga.
///
/// Later:
///
/// API
///  ↓
/// ProductDetailModel.fromJson()
///  ↓
/// ProductDetailScreen
///
/// UI ko change karne ki zaroorat nahi hogi.
class DummyProductDetail {
  DummyProductDetail._();

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  static final ProductDetailModel product = ProductDetailModel(
    id: 1001,

    // ═════════════════════════════════════════════════════════════════════
    // BASIC INFORMATION
    // ═════════════════════════════════════════════════════════════════════
    productName: 'Rolex Watch Elegant Design Luxury Timepiece With Stylish',

    shortDescription:
        'Rolex Watch Elegant Design Luxury Timepiece With Stylish '
        'Appearance And Reliable Performance For Everyday Wear - Golden Silver',

    fullDescription:
        'Rolex Watch Is Crafted To Deliver Premium Style Alongside '
        'Dependable Performance. Designed With Attention To Detail It '
        'Offers A Luxurious Look While Ensuring Practical Use. Built '
        'With Durable Materials And Elegant Finish It Provides Comfort '
        'And Reliability. This Timepiece Is Perfect For Those Seeking '
        'A Blend Of Fashion And Functionality Making It Suitable For '
        'Everyday Wear Or Special Occasions.',

    allowAffiliates: true,

    // ═════════════════════════════════════════════════════════════════════
    // ARABIC
    // ═════════════════════════════════════════════════════════════════════
    arabicName: 'ساعة رولكس بتصميم أنيق وفاخر',

    arabicShortDescription:
        'ساعة فاخرة بتصميم أنيق وأداء موثوق للاستخدام اليومي.',

    arabicFullDescription:
        'تم تصميم هذه الساعة الفاخرة لتقديم مظهر أنيق وأداء موثوق. '
        'تتميز بتصميم فاخر ومواد متينة وتشطيب أنيق يجعلها مناسبة '
        'للاستخدام اليومي والمناسبات الخاصة.',

    // ═════════════════════════════════════════════════════════════════════
    // PRICING & INVENTORY
    // ═════════════════════════════════════════════════════════════════════
    price: 18.00,

    compareAtPrice: 26.00,

    costPrice: 12.00,

    stock: 10,

    sku: 'SKU0029-A36032',

    inventoryType: 'track',

    // ═════════════════════════════════════════════════════════════════════
    // CATEGORY / BRAND
    // ═════════════════════════════════════════════════════════════════════
    categoryId: 12,

    categoryName: 'Men Accessories',

    brandId: 0,

    brandName: 'Unknown',

    // ═════════════════════════════════════════════════════════════════════
    // STATUS
    // ═════════════════════════════════════════════════════════════════════
    status: 'Active',

    isFeatured: false,

    isTrending: false,

    isFlashDeal: false,

    // ═════════════════════════════════════════════════════════════════════
    // SALES / ANALYTICS
    // ═════════════════════════════════════════════════════════════════════
    totalSales: 0,

    views: 0,

    // ═════════════════════════════════════════════════════════════════════
    // PRODUCT IMAGES
    // ═════════════════════════════════════════════════════════════════════
    images: const [
      'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1000&q=85',
      'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=1000&q=85',
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=1000&q=85',
    ],

    // ═════════════════════════════════════════════════════════════════════
    // SEO
    // ═════════════════════════════════════════════════════════════════════
    slug: 'rolex-watch-elegant-design-luxury-timepiece',

    metaTitle: 'Rolex Watch Elegant Design Luxury Timepiece With Stylish',

    metaDescription:
        'Rolex Watch Elegant Design Luxury Timepiece With Stylish '
        'Appearance And Reliable Performance For Everyday Wear - Golden Silver',

    metaKeywords: 'rolex,watch,elegant,design,luxury,timepiece,with,stylish',

    // Arabic SEO
    arabicMetaTitle: 'ساعة رولكس بتصميم أنيق وفاخر',

    arabicMetaDescription:
        'ساعة رولكس فاخرة بتصميم أنيق وأداء موثوق للاستخدام اليومي.',

    arabicMetaKeywords: 'رولكس، ساعة، فاخر، أنيق، تصميم، إكسسوارات',

    // ═════════════════════════════════════════════════════════════════════
    // VARIANTS
    // ═════════════════════════════════════════════════════════════════════
    variants: const [
      ProductVariantModel(name: 'Color', values: ['Golden', 'Silver', 'Black']),
      ProductVariantModel(name: 'Size', values: ['Standard', 'Large']),
    ],

    // ═════════════════════════════════════════════════════════════════════
    // DATES
    // ═════════════════════════════════════════════════════════════════════
    createdAt: DateTime(2026, 9, 2),

    updatedAt: DateTime(2026, 9, 2),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SECOND DUMMY PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Useful for testing navigation between different products later.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  static final ProductDetailModel headphones = ProductDetailModel(
    id: 1002,

    productName: 'Premium Wireless Headphones',

    shortDescription:
        'High-quality wireless headphones with premium sound '
        'and comfortable design.',

    fullDescription:
        'Experience immersive sound with our premium wireless '
        'headphones. Designed for everyday use with long battery '
        'life, comfortable ear cups, powerful bass and crystal-clear audio.',

    allowAffiliates: true,

    arabicName: 'سماعات رأس لاسلكية فاخرة',

    arabicShortDescription:
        'سماعات رأس لاسلكية عالية الجودة مع صوت مميز وتصميم مريح.',

    arabicFullDescription:
        'استمتع بصوت غامر مع سماعات الرأس اللاسلكية الفاخرة. '
        'مصممة للاستخدام اليومي مع عمر بطارية طويل وأكواب أذن مريحة '
        'وصوت جهير قوي وصوت واضح ونقي.',

    price: 299.00,

    compareAtPrice: 349.00,

    costPrice: 180.00,

    stock: 50,

    sku: 'GATBI-WH-001',

    inventoryType: 'track',

    categoryId: 1,

    categoryName: 'Electronics',

    brandId: 1,

    brandName: 'Gatbi',

    status: 'Active',

    isFeatured: true,

    isTrending: true,

    isFlashDeal: false,

    totalSales: 124,

    views: 1850,

    images: const [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1000&q=85',
      'https://images.unsplash.com/photo-1484704849700-f032a568e944?auto=format&fit=crop&w=1000&q=85',
      'https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=1000&q=85',
    ],

    slug: 'premium-wireless-headphones',

    metaTitle: 'Premium Wireless Headphones | Gatbi',

    metaDescription:
        'Shop premium wireless headphones with immersive sound, '
        'long battery life and comfortable design.',

    metaKeywords: 'wireless headphones,bluetooth headphones,headphones,audio',

    arabicMetaTitle: 'سماعات رأس لاسلكية فاخرة',

    arabicMetaDescription:
        'استمتع بصوت غامر مع سماعات الرأس اللاسلكية الفاخرة.',

    arabicMetaKeywords: 'سماعات رأس لاسلكية، سماعات بلوتوث، سماعات رأس، صوت',

    variants: const [
      ProductVariantModel(name: 'Color', values: ['Black', 'White', 'Silver']),
      ProductVariantModel(name: 'Storage', values: ['64GB', '128GB']),
    ],

    createdAt: DateTime(2026, 9, 1),

    updatedAt: DateTime(2026, 9, 2),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ALL DUMMY PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  static final List<ProductDetailModel> products = [product, headphones];

  // ═══════════════════════════════════════════════════════════════════════════
  // FIND BY ID
  // ═══════════════════════════════════════════════════════════════════════════

  static ProductDetailModel? findById(int id) {
    for (final item in products) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEFAULT PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  static ProductDetailModel get defaultProduct => product;
}
