import 'package:flutter/foundation.dart';

@immutable
class MyProductModel {
  const MyProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.status,
    required this.imageUrl,
    required this.category,
    required this.inStock,
    this.sku,
    this.originalPrice,
    this.createdAt,
  });

  final int id;
  final String name;

  final double price;
  final double? originalPrice;

  final int stockQuantity;

  /// active / draft / inactive
  final String status;

  final String imageUrl;

  final String category;

  final bool inStock;

  final String? sku;

  final DateTime? createdAt;

  bool get isActive => status.toLowerCase() == 'active';

  bool get isDraft => status.toLowerCase() == 'draft';

  bool get isInactive => status.toLowerCase() == 'inactive';

  bool get isOutOfStock => !inStock || stockQuantity <= 0;

  factory MyProductModel.fromJson(Map<String, dynamic> json) {
    return MyProductModel(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      price: _toDouble(json['price']),
      originalPrice: json['original_price'] == null
          ? null
          : _toDouble(json['original_price']),
      stockQuantity: _toInt(
        json['stock_qty'] ?? json['stock_quantity'] ?? json['quantity'],
      ),
      status: json['status']?.toString() ?? 'active',
      imageUrl:
          json['image']?.toString() ?? json['image_url']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Uncategorized',
      inStock: _toBool(json['in_stock']),
      sku: json['sku']?.toString(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;

    if (value is num) {
      return value != 0;
    }

    final stringValue = value?.toString().toLowerCase();

    return stringValue == '1' || stringValue == 'true' || stringValue == 'yes';
  }
}
