class CountryModel {
  const CountryModel({
    required this.success,
    required this.countries,
    required this.total,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool? success;
  final List<CountryItemModel> countries;
  final int? total;

  // ============================================================
  // From JSON
  // ============================================================

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      success: json['success'] as bool?,
      countries: _parseCountries(json['countries']),
      total: _parseInt(json['total']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'countries': countries.map((country) => country.toJson()).toList(),
      'total': total,
    };
  }

  // ============================================================
  // Safe List Parsing
  // ============================================================

  static List<CountryItemModel> _parseCountries(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => CountryItemModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  // ============================================================
  // Safe Integer Parsing
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}

// ============================================================
// Country Item Model
// ============================================================

class CountryItemModel {
  const CountryItemModel({
    this.id,
    this.code,
    this.name,
    this.nameAr,
    this.dialCode,
    this.emoji,
    this.currencyCode,
    this.region,
    this.sortOrder,
  });

  final int? id;
  final String? code;
  final String? name;
  final String? nameAr;
  final String? dialCode;
  final String? emoji;
  final String? currencyCode;
  final String? region;
  final int? sortOrder;

  // ============================================================
  // From JSON
  // ============================================================

  factory CountryItemModel.fromJson(Map<String, dynamic> json) {
    return CountryItemModel(
      id: _parseInt(json['id']),
      code: json['code'] as String?,
      name: json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      dialCode: json['dial_code'] as String?,
      emoji: json['emoji'] as String?,
      currencyCode: json['currency_code'] as String?,
      region: json['region'] as String?,
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'name_ar': nameAr,
      'dial_code': dialCode,
      'emoji': emoji,
      'currency_code': currencyCode,
      'region': region,
      'sort_order': sortOrder,
    };
  }

  // ============================================================
  // Safe Integer Parsing
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
