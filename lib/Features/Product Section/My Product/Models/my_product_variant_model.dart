import 'my_product_variant_value_model.dart';

class MyProductVariantModel {
  const MyProductVariantModel({
    this.id,
    this.name,
    this.sku,
    this.price,
    this.priceOld,
    this.stockQty,
    this.image,
    this.isActive = false,
    this.isPriceOverride = false,
    this.values = const [],
  });

  final int? id;
  final String? name;
  final String? sku;
  final double? price;
  final double? priceOld;
  final int? stockQty;
  final String? image;
  final bool isActive;
  final bool isPriceOverride;
  final List<MyProductVariantValueModel> values;

  factory MyProductVariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductVariantModel();
    }

    return MyProductVariantModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      sku: _parseString(json['sku']),
      price: _parseDouble(json['price']),
      priceOld: _parseDouble(json['price_old']),
      stockQty: _parseInt(json['stock_qty']),
      image: _parseString(json['image']),
      isActive: _parseBool(json['is_active']),
      isPriceOverride: _parseBool(json['is_price_override']),
      values: _parseList(json['values'], MyProductVariantValueModel.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'price': price,
      'price_old': priceOld,
      'stock_qty': stockQty,
      'image': image,
      'is_active': isActive,
      'is_price_override': isPriceOverride,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }

  static List<MyProductVariantValueModel> _parseList(
    dynamic value,
    MyProductVariantValueModel Function(Map<String, dynamic>) fromJson,
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
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
