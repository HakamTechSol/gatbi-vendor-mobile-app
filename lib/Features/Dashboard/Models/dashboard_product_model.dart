import 'dashboard_variant_model.dart';

class DashboardProductModel {
  const DashboardProductModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.shortDescription,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.currency,
    this.currencySymbol,
    this.stockStatus,
    this.stockQuantity,
    this.hasVariants = false,
    this.rating,
    this.reviewCount,
    this.onSale = false,
    this.featured = false,
    this.image,
    this.merchantId,
    this.merchantName,
    this.createdAt,
    this.updatedAt,
    this.variants = const [],
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? shortDescription;

  final double? price;
  final double? regularPrice;
  final double? salePrice;

  final String? currency;
  final String? currencySymbol;

  final String? stockStatus;
  final int? stockQuantity;

  final bool hasVariants;

  final double? rating;
  final int? reviewCount;

  final bool onSale;
  final bool featured;

  final String? image;

  final int? merchantId;
  final String? merchantName;

  final String? createdAt;
  final String? updatedAt;

  final List<DashboardVariantModel> variants;

  factory DashboardProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardProductModel();
    }

    return DashboardProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      description: _parseString(json['description']),
      shortDescription: _parseString(json['short_description']),
      price: _parseDouble(json['price']),
      regularPrice: _parseDouble(json['regular_price']),
      salePrice: _parseDouble(json['sale_price']),
      currency: _parseString(json['currency']),
      currencySymbol: _parseString(json['currency_symbol']),
      stockStatus: _parseString(json['stock_status']),
      stockQuantity: _parseInt(json['stock_quantity']),
      hasVariants: _parseBool(json['has_variants']),
      rating: _parseDouble(json['rating']),
      reviewCount: _parseInt(json['review_count']),
      onSale: _parseBool(json['on_sale']),
      featured: _parseBool(json['featured']),
      image: _parseString(json['image']),
      merchantId: _parseInt(json['merchant_id']),
      merchantName: _parseString(json['merchant_name']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      variants: _parseVariants(json['variants']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'short_description': shortDescription,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'stock_status': stockStatus,
      'stock_quantity': stockQuantity,
      'has_variants': hasVariants,
      'rating': rating,
      'review_count': reviewCount,
      'on_sale': onSale,
      'featured': featured,
      'image': image,
      'merchant_id': merchantId,
      'merchant_name': merchantName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'variants': variants.map((e) => e.toJson()).toList(),
    };
  }

  static List<DashboardVariantModel> _parseVariants(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) =>
              DashboardVariantModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) return value;

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) return value.toInt();

    if (value is String) return int.tryParse(value);

    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) return value.toDouble();

    if (value is String) return double.tryParse(value);

    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}
