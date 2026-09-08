import '../Models/my_product_model.dart';

class DummyMyProducts {
  DummyMyProducts._();

  static const List<MyProductModel> products = [
    // ═══════════════════════════════════════════════════════════════════════════
    // PRODUCT 1
    // Same product as DummyProductFormData
    // ═══════════════════════════════════════════════════════════════════════════
    MyProductModel(
      id: 1,

      name: 'Premium Wireless Headphones',

      price: 299.00,

      originalPrice: 349.00,

      stockQuantity: 50,

      status: 'active',

      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',

      category: 'Electronics',

      inStock: true,

      sku: 'GATBI-WH-001',
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // PRODUCT 2
    // ═══════════════════════════════════════════════════════════════════════════
    MyProductModel(
      id: 2,

      name: 'Classic Leather Backpack',

      price: 189.00,

      originalPrice: 229.00,

      stockQuantity: 8,

      status: 'active',

      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',

      category: 'Fashion',

      inStock: true,

      sku: 'GATBI-BP-002',
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // PRODUCT 3
    // ═══════════════════════════════════════════════════════════════════════════
    MyProductModel(
      id: 3,

      name: 'Smart Watch Series 5',

      price: 399.00,

      originalPrice: 459.00,

      stockQuantity: 3,

      status: 'active',

      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',

      category: 'Electronics',

      inStock: true,

      sku: 'GATBI-SW-003',
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // PRODUCT 4
    // ═══════════════════════════════════════════════════════════════════════════
    MyProductModel(
      id: 4,

      name: 'Minimal Ceramic Coffee Set',

      price: 79.00,

      originalPrice: 99.00,

      stockQuantity: 0,

      status: 'inactive',

      imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d',

      category: 'Home & Living',

      inStock: false,

      sku: 'GATBI-CS-004',
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // PRODUCT 5
    // ═══════════════════════════════════════════════════════════════════════════
    MyProductModel(
      id: 5,

      name: 'Organic Cotton T-Shirt',

      price: 59.00,

      originalPrice: 69.00,

      stockQuantity: 42,

      status: 'draft',

      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',

      category: 'Fashion',

      inStock: true,

      sku: 'GATBI-TS-005',
    ),
  ];
}
