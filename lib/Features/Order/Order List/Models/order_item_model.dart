class OrderItemModel {
  const OrderItemModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    this.sku,
    this.imageUrl,
    this.variantName,
  });

  final String id;
  final String productName;
  final int quantity;
  final double price;
  final String? sku;
  final String? imageUrl;
  final String? variantName;

  double get total => price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      quantity: _parseInt(json['quantity']),
      price: _parseDouble(json['price']),
      sku: json['sku']?.toString(),
      imageUrl: json['image_url']?.toString(),
      variantName: json['variant_name']?.toString(),
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
    };
  }

  OrderItemModel copyWith({
    String? id,
    String? productName,
    int? quantity,
    double? price,
    String? sku,
    String? imageUrl,
    String? variantName,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      sku: sku ?? this.sku,
      imageUrl: imageUrl ?? this.imageUrl,
      variantName: variantName ?? this.variantName,
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