class UpdateProductVariantModel {
  const UpdateProductVariantModel({
    this.id,
    this.sku,
    this.price,
    this.priceOld,
    this.stockQty,
    this.weight,
    this.barcode,
    this.isActive = false,
    this.isPriceOverride = false,
    this.attributes = const {},
    this.optionValues = const [],
  });

  final int? id;

  final String? sku;

  final num? price;

  final num? priceOld;

  final int? stockQty;

  final num? weight;

  final String? barcode;

  final bool isActive;

  final bool isPriceOverride;

  final Map<String, dynamic> attributes;

  final List<dynamic> optionValues;

  factory UpdateProductVariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UpdateProductVariantModel();
    }

    return UpdateProductVariantModel(
      id: _parseInt(json['id']),
      sku: json['sku']?.toString(),
      price: _parseNum(json['price']),
      priceOld: _parseNum(json['price_old']),
      stockQty: _parseInt(json['stock_qty']),
      weight: _parseNum(json['weight']),
      barcode: json['barcode']?.toString(),
      isActive: _parseBool(json['is_active']),
      isPriceOverride: _parseBool(json['is_price_override']),
      attributes: _parseMap(json['attributes']),
      optionValues: json['option_values'] is List
          ? List<dynamic>.from(json['option_values'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'price': price,
      'price_old': priceOld,
      'stock_qty': stockQty,
      'weight': weight,
      'barcode': barcode,
      'is_active': isActive,
      'is_price_override': isPriceOverride,
      'attributes': attributes,
      'option_values': optionValues,
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

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

  static num? _parseNum(dynamic value) {
    if (value is num) return value;

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }

    return Map<String, dynamic>.from(value);
  }
}
