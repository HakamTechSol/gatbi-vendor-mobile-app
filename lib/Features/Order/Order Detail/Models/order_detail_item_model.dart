class OrderDetailItemModel {
  const OrderDetailItemModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    this.sku,
    this.imageUrl,
    this.variantName,
    this.variantId,
    this.productId,
    this.total,
  });

  final String id;
  final String productName;
  final int quantity;
  final double price;

  final String? sku;
  final String? imageUrl;
  final String? variantName;
  final String? variantId;
  final String? productId;
  final double? total;

  double get calculatedTotal => total ?? (price * quantity);

  factory OrderDetailItemModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailItemModel(
      id: json['id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      quantity: _parseInt(json['quantity']),
      price: _parseDouble(json['price']),
      sku: json['sku']?.toString(),
      imageUrl: json['image_url']?.toString(),
      variantName: json['variant_name']?.toString(),
      variantId: json['variant_id']?.toString(),
      productId: json['product_id']?.toString(),
      total: json['total'] != null ? _parseDouble(json['total']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'sku': sku,
      'image_url': imageUrl,
      'variant_name': variantName,
      'variant_id': variantId,
      'product_id': productId,
      'total': total,
    };
  }

  OrderDetailItemModel copyWith({
    String? id,
    String? productName,
    int? quantity,
    double? price,
    String? sku,
    String? imageUrl,
    String? variantName,
    String? variantId,
    String? productId,
    double? total,
  }) {
    return OrderDetailItemModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      sku: sku ?? this.sku,
      imageUrl: imageUrl ?? this.imageUrl,
      variantName: variantName ?? this.variantName,
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      total: total ?? this.total,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
