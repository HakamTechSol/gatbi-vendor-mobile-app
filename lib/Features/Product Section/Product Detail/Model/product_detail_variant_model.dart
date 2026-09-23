import 'product_detail_option_value_model.dart';

class ProductDetailVariantModel {
  const ProductDetailVariantModel({
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

  final double? price;
  final double? priceOld;

  final int? stockQty;

  final double? weight;
  final String? barcode;

  final bool isActive;
  final bool isPriceOverride;

  final Map<String, dynamic> attributes;

  final List<ProductDetailOptionValueModel> optionValues;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailVariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailVariantModel();
    }

    return ProductDetailVariantModel(
      id: _parseInt(json['id']),
      sku: json['sku']?.toString(),

      price: _parseDouble(json['price']),
      priceOld: _parseDouble(json['price_old']),

      stockQty: _parseInt(json['stock_qty']),

      weight: _parseDouble(json['weight']),
      barcode: json['barcode']?.toString(),

      isActive: _parseBool(json['is_active']),
      isPriceOverride: _parseBool(json['is_price_override']),

      attributes: _parseMap(json['attributes']),

      optionValues: _parseList(
        json['option_values'],
        ProductDetailOptionValueModel.fromJson,
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

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
      'option_values': optionValues.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value is! Map) return const {};

    return Map<String, dynamic>.from(value);
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
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
}
