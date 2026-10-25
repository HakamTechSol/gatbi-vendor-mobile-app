// ============================================================
// Countries Model
// ============================================================

class CountriesModel {
  const CountriesModel({
    this.success = false,
    this.countries = const [],
    this.total,
  });

  final bool success;
  final List<CountryModel> countries;
  final int? total;

  // ============================================================
  // From JSON
  // ============================================================

  factory CountriesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CountriesModel();
    }

    final rawCountries = json['countries'];

    return CountriesModel(
      success: _parseBool(json['success']),
      total: _parseInt(json['total']),
      countries: rawCountries is List
          ? rawCountries
                .whereType<Map>()
                .map(
                  (item) =>
                      CountryModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'total': total,
      'countries': countries.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1';
    }
    if (value is num) return value != 0;
    return false;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

// ============================================================
// Country Model
// ============================================================

class CountryModel {
  const CountryModel({
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

  factory CountryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CountryModel();
    }

    return CountryModel(
      id: _parseInt(json['id']),
      code: _parseString(json['code']),
      name: _parseString(json['name']),
      nameAr: _parseString(json['name_ar']),
      dialCode: _parseString(json['dial_code']),
      emoji: _parseString(json['emoji']),
      currencyCode: _parseString(json['currency_code']),
      region: _parseString(json['region']),
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
  // Helpers
  // ============================================================

  /// Whether this country has a usable dial code.
  bool get hasDialCode => dialCode != null && dialCode!.trim().isNotEmpty;

  /// Whether this country has a usable code (e.g. "AE").
  bool get hasCode => code != null && code!.trim().isNotEmpty;

  /// Display label like "🇦🇪 United Arab Emirates (+971)".
  String get displayLabel {
    final buffer = StringBuffer();

    if (emoji != null && emoji!.trim().isNotEmpty) {
      buffer.write('${emoji!.trim()} ');
    }

    buffer.write(name ?? code ?? 'Unknown');

    if (hasDialCode) {
      buffer.write(' (${dialCode!.trim()})');
    }

    return buffer.toString();
  }

  // ============================================================
  // Parsers
  // ============================================================

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
