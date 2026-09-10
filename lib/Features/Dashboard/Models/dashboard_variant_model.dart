class DashboardVariantModel {
  const DashboardVariantModel({
    this.id,
    this.name,
    this.sku,
    this.price,
    this.priceOld,
    this.stockQty,
    this.isActive = false,
    this.values = const [],
  });

  final int? id;
  final String? name;
  final String? sku;
  final double? price;
  final double? priceOld;
  final int? stockQty;
  final bool isActive;
  final List<DashboardVariantValueModel> values;

  factory DashboardVariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardVariantModel();
    }

    return DashboardVariantModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      sku: _parseString(json['sku']),
      price: _parseDouble(json['price']),
      priceOld: _parseDouble(json['price_old']),
      stockQty: _parseInt(json['stock_qty']),
      isActive: _parseBool(json['is_active']),
      values: _parseValues(json['values']),
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
      'is_active': isActive,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }

  static List<DashboardVariantValueModel> _parseValues(dynamic value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) => DashboardVariantValueModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
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

class DashboardVariantValueModel {
  const DashboardVariantValueModel({this.id, this.name, this.value});

  final int? id;
  final String? name;
  final String? value;

  factory DashboardVariantValueModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const DashboardVariantValueModel();
    }

    return DashboardVariantValueModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      value: _parseString(json['value']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'value': value};
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
}
