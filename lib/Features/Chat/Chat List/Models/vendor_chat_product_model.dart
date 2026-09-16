class VendorChatProductModel {
  const VendorChatProductModel({
    this.id,
    this.name,
    this.slug,
    this.price,
    this.oldPrice,
    this.currency,
    this.heroImageUrl,
    this.productUrl,
    this.merchantName,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? slug;
  final double? price;
  final double? oldPrice;
  final String? currency;
  final String? heroImageUrl;
  final String? productUrl;
  final String? merchantName;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatProductModel();
    }

    return VendorChatProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      price: _parseDouble(json['price']),
      oldPrice: _parseDouble(json['old_price']),
      currency: _parseString(json['currency']),
      heroImageUrl: _parseString(json['hero_image_url']),
      productUrl: _parseString(json['product_url']),
      merchantName: _parseString(json['merchant_name']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'price': price,
      'old_price': oldPrice,
      'currency': currency,
      'hero_image_url': heroImageUrl,
      'product_url': productUrl,
      'merchant_name': merchantName,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}