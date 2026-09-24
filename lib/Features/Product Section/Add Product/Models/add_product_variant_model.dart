import 'add_product_option_value_model.dart';

class AddProductVariantModel {
  const AddProductVariantModel({
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

  /// Attribute ID -> Attribute Value ID.
  ///
  /// Example:
  /// {
  ///   "4": 9
  /// }
  final Map<String, int> attributes;

  final List<AddProductOptionValueModel> optionValues;

  factory AddProductVariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddProductVariantModel();
    }

    return AddProductVariantModel(
      id: _parseInt(json['id']),
      sku: _parseString(json['sku']),
      price: _parseNum(json['price']),
      priceOld: _parseNum(json['price_old']),
      stockQty: _parseInt(json['stock_qty']),
      weight: _parseNum(json['weight']),
      barcode: _parseString(json['barcode']),
      isActive: _parseBool(json['is_active']),
      isPriceOverride: _parseBool(json['is_price_override']),
      attributes: _parseIntMap(json['attributes']),
      optionValues: _parseList(
        json['option_values'],
        AddProductOptionValueModel.fromJson,
      ),
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
      'option_values': optionValues.map((e) => e.toJson()).toList(),
    };
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    return value.toString();
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

  static Map<String, int> _parseIntMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }

    final result = <String, int>{};

    value.forEach((key, value) {
      if (key == null) return;

      final parsed = _parseInt(value);

      if (parsed != null) {
        result[key.toString()] = parsed;
      }
    });

    return result;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
