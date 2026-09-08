class ProductVariantModel {
  const ProductVariantModel({
    this.id,
    this.sku = '',
    this.price,
    this.compareAtPrice,
    this.stockQuantity = 0,
    this.image,
    this.attributes = const {},
    this.isActive = true,
  });

  final int? id;

  /// Variant SKU.
  final String sku;

  /// Variant selling price.
  final double? price;

  /// Original / compare-at price.
  final double? compareAtPrice;

  /// Available stock.
  final int stockQuantity;

  /// Optional variant-specific image.
  final String? image;

  /// Attribute combination.
  ///
  /// Example:
  /// {
  ///   "Size": "M",
  ///   "Color": "Black",
  /// }
  final Map<String, String> attributes;

  final bool isActive;

  bool get isInStock => stockQuantity > 0;

  ProductVariantModel copyWith({
    int? id,
    String? sku,
    double? price,
    double? compareAtPrice,
    int? stockQuantity,
    String? image,
    Map<String, String>? attributes,
    bool? isActive,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      image: image ?? this.image,
      attributes: attributes ?? this.attributes,
      isActive: isActive ?? this.isActive,
    );
  }

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: _parseNullableInt(json['id']),
      sku: json['sku']?.toString() ?? '',
      price: _parseNullableDouble(
        json['price'],
      ),
      compareAtPrice: _parseNullableDouble(
        json['compare_at_price'] ??
            json['compareAtPrice'] ??
            json['original_price'],
      ),
      stockQuantity: _parseInt(
        json['stock_quantity'] ??
            json['stock'] ??
            json['quantity'],
      ),
      image: json['image']?.toString(),
      attributes: _parseAttributes(
        json['attributes'],
      ),
      isActive: _parseBool(
        json['is_active'] ??
            json['active'],
        defaultValue: true,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sku': sku,
      if (price != null) 'price': price,
      if (compareAtPrice != null)
        'compare_at_price': compareAtPrice,
      'stock_quantity': stockQuantity,
      if (image != null) 'image': image,
      'attributes': attributes,
      'is_active': isActive,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    );
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  static bool _parseBool(
    dynamic value, {
    required bool defaultValue,
  }) {
    if (value is bool) return value;

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      if (normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes') {
        return true;
      }

      if (normalized == 'false' ||
          normalized == '0' ||
          normalized == 'no') {
        return false;
      }
    }

    return defaultValue;
  }

  static Map<String, String> _parseAttributes(
    dynamic value,
  ) {
    if (value is! Map) {
      return const {};
    }

    return value.map(
      (key, value) => MapEntry(
        key.toString(),
        value?.toString() ?? '',
      ),
    );
  }
}