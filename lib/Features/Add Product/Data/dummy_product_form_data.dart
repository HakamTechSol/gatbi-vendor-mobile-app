import '../Reuse Widgets/product_dropdown_field.dart';

class DummyProductFormData {
  DummyProductFormData._();

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  static const productName = 'Premium Wireless Headphones';

  static const shortDescription =
      'High-quality wireless headphones with premium sound and comfortable design.';

  static const fullDescription =
      'Experience immersive sound with our premium wireless headphones. '
      'Designed for everyday use with long battery life, comfortable ear '
      'cups, powerful bass and crystal-clear audio.';

  static const allowAffiliates = true;

  // ═══════════════════════════════════════════════════════════════════════════
  // ARABIC TRANSLATION
  // ═══════════════════════════════════════════════════════════════════════════

  static const arabicName = 'سماعات رأس لاسلكية فاخرة';

  static const arabicShortDescription =
      'سماعات رأس لاسلكية عالية الجودة مع صوت مميز وتصميم مريح.';

  static const arabicFullDescription =
      'استمتع بصوت غامر مع سماعات الرأس اللاسلكية الفاخرة. '
      'مصممة للاستخدام اليومي مع عمر بطارية طويل وأكواب أذن مريحة '
      'وصوت جهير قوي وصوت واضح ونقي.';

  // Arabic SEO
  static const arabicMetaTitle = 'سماعات رأس لاسلكية فاخرة';

  static const arabicMetaKeywords =
      'سماعات رأس لاسلكية، سماعات بلوتوث، سماعات رأس، صوت';

  static const arabicMetaDescription =
      'استمتع بصوت غامر مع سماعات الرأس اللاسلكية الفاخرة. '
      'مصممة للاستخدام اليومي مع عمر بطارية طويل وأكواب أذن مريحة '
      'وصوت جهير قوي وصوت واضح ونقي.';

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICING & INVENTORY
  // ═══════════════════════════════════════════════════════════════════════════

  static const price = '299.00';

  static const compareAtPrice = '349.00';

  static const costPrice = '180.00';

  static const stock = '50';

  static const sku = 'GATBI-WH-001';

  static const inventoryType = 'track';

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY / BRAND
  // ═══════════════════════════════════════════════════════════════════════════

  static const categoryId = '1';

  static const brandId = '1';

  static const categoryName = 'Electronics';

  static const brandName = 'Gatbi';

  static const categories = <ProductDropdownItem<String>>[
    ProductDropdownItem<String>(
      value: '1',
      label: 'Electronics',
      subtitle: 'Electronic products',
    ),
    ProductDropdownItem<String>(
      value: '2',
      label: 'Fashion',
      subtitle: 'Clothing and fashion',
    ),
    ProductDropdownItem<String>(
      value: '3',
      label: 'Home & Living',
      subtitle: 'Home and lifestyle products',
    ),
    ProductDropdownItem<String>(
      value: '4',
      label: 'Beauty',
      subtitle: 'Beauty and personal care',
    ),
  ];

  static const brands = <ProductDropdownItem<String>>[
    ProductDropdownItem<String>(value: '1', label: 'Gatbi'),
    ProductDropdownItem<String>(value: '2', label: 'Apple'),
    ProductDropdownItem<String>(value: '3', label: 'Samsung'),
    ProductDropdownItem<String>(value: '4', label: 'Sony'),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SEO
  // ═══════════════════════════════════════════════════════════════════════════

  static const slug = 'premium-wireless-headphones';

  static const metaTitle = 'Premium Wireless Headphones | Gatbi';

  static const metaDescription =
      'Shop premium wireless headphones with immersive sound, '
      'long battery life and comfortable design.';

  static const metaKeywords =
      'wireless headphones, bluetooth headphones, headphones, audio';

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const variantAttributes = <Map<String, dynamic>>[
    {
      'name': 'Color',
      'values': ['Black', 'White', 'Silver'],
    },
    {
      'name': 'Storage',
      'values': ['64GB', '128GB'],
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER
  // ═══════════════════════════════════════════════════════════════════════════

  static Map<String, dynamic> toMap() {
    return {
      // ═══════════════════════════════════════════════════════════════════════
      // BASIC
      // ═══════════════════════════════════════════════════════════════════════
      'product_name': productName,
      'short_description': shortDescription,
      'full_description': fullDescription,
      'allow_affiliates': allowAffiliates,

      // ═══════════════════════════════════════════════════════════════════════
      // ARABIC
      // ═══════════════════════════════════════════════════════════════════════
      'arabic_name': arabicName,
      'arabic_short_description': arabicShortDescription,
      'arabic_full_description': arabicFullDescription,

      // Arabic SEO
      'arabic_meta_title': arabicMetaTitle,
      'arabic_meta_keywords': arabicMetaKeywords,
      'arabic_meta_description': arabicMetaDescription,

      // ═══════════════════════════════════════════════════════════════════════
      // PRICING & INVENTORY
      // ═══════════════════════════════════════════════════════════════════════
      'price': price,
      'compare_at_price': compareAtPrice,
      'cost_price': costPrice,
      'stock': stock,
      'sku': sku,
      'inventory_type': inventoryType,

      // ═══════════════════════════════════════════════════════════════════════
      // CATEGORY / BRAND
      // ═══════════════════════════════════════════════════════════════════════
      'category_id': categoryId,
      'category_name': categoryName,

      'brand_id': brandId,
      'brand_name': brandName,

      // ═══════════════════════════════════════════════════════════════════════
      // SEO
      // ═══════════════════════════════════════════════════════════════════════
      'slug': slug,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keywords': metaKeywords,

      // ═══════════════════════════════════════════════════════════════════════
      // VARIANTS
      // ═══════════════════════════════════════════════════════════════════════
      'variant_attributes': variantAttributes,
    };
  }
}
