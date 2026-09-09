import '../Models/order_customer_model.dart';
import '../Models/order_item_model.dart';
import '../Models/order_model.dart';
import '../Models/order_pagination_model.dart';

class DummyOrders {
  DummyOrders._();

  static final List<OrderModel> orders = [
    // ============================================================
    // Order 1 - Pending
    // ============================================================

    OrderModel(
      id: 'ORD-001',
      orderNumber: '#GTB-10001',
      status: OrderStatus.pending,
      totalAmount: 245.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 8, 10, 30),
      itemCount: 2,
      customer: const OrderCustomerModel(
        id: 'CUS-001',
        name: 'Ahmed Khan',
        email: 'ahmed@example.com',
        phone: '+971 50 123 4567',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-001',
          productName: 'Premium Cotton T-Shirt',
          sku: 'TSH-001',
          quantity: 2,
          price: 75.00,
          variantName: 'Black / Large',
        ),
        OrderItemModel(
          id: 'ITEM-002',
          productName: 'Classic Cap',
          sku: 'CAP-001',
          quantity: 1,
          price: 95.00,
          variantName: 'Black',
        ),
      ],
      subtotal: 245.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 2 - Processing
    // ============================================================

    OrderModel(
      id: 'ORD-002',
      orderNumber: '#GTB-10002',
      status: OrderStatus.processing,
      totalAmount: 580.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 7, 14, 15),
      itemCount: 3,
      customer: const OrderCustomerModel(
        id: 'CUS-002',
        name: 'Sarah Williams',
        email: 'sarah@example.com',
        phone: '+971 55 234 5678',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-003',
          productName: 'Leather Handbag',
          sku: 'BAG-001',
          quantity: 1,
          price: 350.00,
          variantName: 'Brown',
        ),
        OrderItemModel(
          id: 'ITEM-004',
          productName: 'Premium Wallet',
          sku: 'WAL-001',
          quantity: 1,
          price: 150.00,
          variantName: 'Brown',
        ),
        OrderItemModel(
          id: 'ITEM-005',
          productName: 'Key Holder',
          sku: 'KEY-001',
          quantity: 1,
          price: 80.00,
        ),
      ],
      subtotal: 580.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 3 - Shipped
    // ============================================================

    OrderModel(
      id: 'ORD-003',
      orderNumber: '#GTB-10003',
      status: OrderStatus.shipped,
      totalAmount: 1250.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 6, 9, 45),
      itemCount: 4,
      customer: const OrderCustomerModel(
        id: 'CUS-003',
        name: 'Mohammed Ali',
        email: 'mohammed@example.com',
        phone: '+971 52 345 6789',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-006',
          productName: 'Premium Sneakers',
          sku: 'SNK-001',
          quantity: 1,
          price: 450.00,
          variantName: 'White / 42',
        ),
        OrderItemModel(
          id: 'ITEM-007',
          productName: 'Sports Jacket',
          sku: 'JKT-001',
          quantity: 1,
          price: 400.00,
          variantName: 'Navy / Large',
        ),
        OrderItemModel(
          id: 'ITEM-008',
          productName: 'Sports T-Shirt',
          sku: 'TSH-002',
          quantity: 2,
          price: 200.00,
          variantName: 'White / Large',
        ),
      ],
      subtotal: 1250.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 4 - Delivered
    // ============================================================

    OrderModel(
      id: 'ORD-004',
      orderNumber: '#GTB-10004',
      status: OrderStatus.delivered,
      totalAmount: 890.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 5, 16, 20),
      itemCount: 2,
      customer: const OrderCustomerModel(
        id: 'CUS-004',
        name: 'Emily Johnson',
        email: 'emily@example.com',
        phone: '+971 56 456 7890',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-009',
          productName: 'Designer Shoulder Bag',
          sku: 'BAG-002',
          quantity: 1,
          price: 650.00,
          variantName: 'Beige',
        ),
        OrderItemModel(
          id: 'ITEM-010',
          productName: 'Silk Scarf',
          sku: 'SCR-001',
          quantity: 1,
          price: 240.00,
          variantName: 'Blue',
        ),
      ],
      subtotal: 890.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 5 - Cancelled
    // ============================================================

    OrderModel(
      id: 'ORD-005',
      orderNumber: '#GTB-10005',
      status: OrderStatus.cancelled,
      totalAmount: 320.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 4, 11, 10),
      itemCount: 2,
      customer: const OrderCustomerModel(
        id: 'CUS-005',
        name: 'Omar Hassan',
        email: 'omar@example.com',
        phone: '+971 50 567 8901',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-011',
          productName: 'Casual Shirt',
          sku: 'SHR-001',
          quantity: 2,
          price: 120.00,
          variantName: 'White / Medium',
        ),
        OrderItemModel(
          id: 'ITEM-012',
          productName: 'Leather Belt',
          sku: 'BLT-001',
          quantity: 1,
          price: 80.00,
          variantName: 'Black',
        ),
      ],
      subtotal: 320.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 6 - Pending
    // ============================================================

    OrderModel(
      id: 'ORD-006',
      orderNumber: '#GTB-10006',
      status: OrderStatus.pending,
      totalAmount: 165.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 3, 13, 40),
      itemCount: 3,
      customer: const OrderCustomerModel(
        id: 'CUS-006',
        name: 'Fatima Noor',
        email: 'fatima@example.com',
        phone: '+971 54 678 9012',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-013',
          productName: 'Basic T-Shirt',
          sku: 'TSH-003',
          quantity: 1,
          price: 65.00,
          variantName: 'Pink / Medium',
        ),
        OrderItemModel(
          id: 'ITEM-014',
          productName: 'Fashion Bracelet',
          sku: 'BRC-001',
          quantity: 1,
          price: 50.00,
        ),
        OrderItemModel(
          id: 'ITEM-015',
          productName: 'Hair Accessories Set',
          sku: 'HAC-001',
          quantity: 1,
          price: 50.00,
        ),
      ],
      subtotal: 165.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 7 - Processing
    // ============================================================

    OrderModel(
      id: 'ORD-007',
      orderNumber: '#GTB-10007',
      status: OrderStatus.processing,
      totalAmount: 740.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 2, 10, 25),
      itemCount: 2,
      customer: const OrderCustomerModel(
        id: 'CUS-007',
        name: 'Daniel Smith',
        email: 'daniel@example.com',
        phone: '+971 58 789 0123',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-016',
          productName: 'Running Shoes',
          sku: 'SNK-002',
          quantity: 1,
          price: 420.00,
          variantName: 'Black / 43',
        ),
        OrderItemModel(
          id: 'ITEM-017',
          productName: 'Smart Sports Watch',
          sku: 'WAT-001',
          quantity: 1,
          price: 320.00,
          variantName: 'Black',
        ),
      ],
      subtotal: 740.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 8 - Shipped
    // ============================================================

    OrderModel(
      id: 'ORD-008',
      orderNumber: '#GTB-10008',
      status: OrderStatus.shipped,
      totalAmount: 460.00,
      currency: 'AED',
      createdAt: DateTime(2026, 9, 1, 15, 30),
      itemCount: 3,
      customer: const OrderCustomerModel(
        id: 'CUS-008',
        name: 'Aisha Ahmed',
        email: 'aisha@example.com',
        phone: '+971 55 890 1234',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-018',
          productName: 'Perfume',
          sku: 'PER-001',
          quantity: 1,
          price: 220.00,
          variantName: '100ml',
        ),
        OrderItemModel(
          id: 'ITEM-019',
          productName: 'Body Lotion',
          sku: 'LOT-001',
          quantity: 1,
          price: 120.00,
        ),
        OrderItemModel(
          id: 'ITEM-020',
          productName: 'Face Wash',
          sku: 'FWS-001',
          quantity: 1,
          price: 120.00,
        ),
      ],
      subtotal: 460.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 9 - Delivered
    // ============================================================

    OrderModel(
      id: 'ORD-009',
      orderNumber: '#GTB-10009',
      status: OrderStatus.delivered,
      totalAmount: 1320.00,
      currency: 'AED',
      createdAt: DateTime(2026, 8, 31, 12, 15),
      itemCount: 3,
      customer: const OrderCustomerModel(
        id: 'CUS-009',
        name: 'Yousef Mahmoud',
        email: 'yousef@example.com',
        phone: '+971 52 901 2345',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-021',
          productName: 'Premium Backpack',
          sku: 'BAG-003',
          quantity: 1,
          price: 520.00,
          variantName: 'Black',
        ),
        OrderItemModel(
          id: 'ITEM-022',
          productName: 'Travel Organizer',
          sku: 'ORG-001',
          quantity: 2,
          price: 150.00,
        ),
        OrderItemModel(
          id: 'ITEM-023',
          productName: 'Travel Shoes',
          sku: 'SNK-003',
          quantity: 1,
          price: 500.00,
          variantName: 'Black / 43',
        ),
      ],
      subtotal: 1320.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),

    // ============================================================
    // Order 10 - Pending
    // ============================================================

    OrderModel(
      id: 'ORD-010',
      orderNumber: '#GTB-10010',
      status: OrderStatus.pending,
      totalAmount: 210.00,
      currency: 'AED',
      createdAt: DateTime(2026, 8, 30, 9, 50),
      itemCount: 2,
      customer: const OrderCustomerModel(
        id: 'CUS-010',
        name: 'Hassan Raza',
        email: 'hassan@example.com',
        phone: '+971 50 012 3456',
      ),
      items: const [
        OrderItemModel(
          id: 'ITEM-024',
          productName: 'Casual Sneakers',
          sku: 'SNK-004',
          quantity: 1,
          price: 150.00,
          variantName: 'White / 41',
        ),
        OrderItemModel(
          id: 'ITEM-025',
          productName: 'Sports Socks',
          sku: 'SOC-001',
          quantity: 2,
          price: 30.00,
          variantName: 'White',
        ),
      ],
      subtotal: 210.00,
      shippingAmount: 0.00,
      discountAmount: 0.00,
    ),
  ];

  // ============================================================
  // Pagination
  // ============================================================

  static OrderPaginationModel get firstPage {
    const perPage = 10;

    return OrderPaginationModel(
      orders: orders,
      currentPage: 1,
      perPage: perPage,
      total: orders.length,
      lastPage: 1,
      hasMore: false,
    );
  }

  // ============================================================
  // Helpers for UI filtering
  // ============================================================

  static List<OrderModel> get pendingOrders {
    return orders
        .where((order) => order.status == OrderStatus.pending)
        .toList();
  }

  static List<OrderModel> get processingOrders {
    return orders
        .where((order) => order.status == OrderStatus.processing)
        .toList();
  }

  static List<OrderModel> get shippedOrders {
    return orders
        .where((order) => order.status == OrderStatus.shipped)
        .toList();
  }

  static List<OrderModel> get deliveredOrders {
    return orders
        .where((order) => order.status == OrderStatus.delivered)
        .toList();
  }

  static List<OrderModel> get cancelledOrders {
    return orders
        .where((order) => order.status == OrderStatus.cancelled)
        .toList();
  }
}