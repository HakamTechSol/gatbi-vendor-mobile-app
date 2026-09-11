class PhoneRulesModel {
  const PhoneRulesModel({
    this.success,
    this.phoneRules = const [],
    this.defaultMinLength,
    this.defaultMaxLength,
    this.total,
  });

  // ============================================================
  // Response Fields
  // ============================================================

  final bool? success;
  final List<PhoneRuleItemModel> phoneRules;
  final int? defaultMinLength;
  final int? defaultMaxLength;
  final int? total;

  // ============================================================
  // From JSON
  // ============================================================

  factory PhoneRulesModel.fromJson(Map<String, dynamic> json) {
    return PhoneRulesModel(
      success: json['success'] as bool?,
      phoneRules: _parsePhoneRules(json['phone_rules']),
      defaultMinLength: _parseInt(json['default_min_length']),
      defaultMaxLength: _parseInt(json['default_max_length']),
      total: _parseInt(json['total']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'phone_rules': phoneRules.map((phoneRule) => phoneRule.toJson()).toList(),
      'default_min_length': defaultMinLength,
      'default_max_length': defaultMaxLength,
      'total': total,
    };
  }

  // ============================================================
  // Safe Phone Rules Parsing
  // ============================================================

  static List<PhoneRuleItemModel> _parsePhoneRules(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) =>
              PhoneRuleItemModel.fromJson(Map<String, dynamic>.from(item)),
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
// Phone Rule Item Model
// ============================================================

class PhoneRuleItemModel {
  const PhoneRuleItemModel({
    this.countryCode,
    this.minLength,
    this.maxLength,
    this.example,
  });

  // ============================================================
  // Fields
  // ============================================================

  final String? countryCode;
  final int? minLength;
  final int? maxLength;
  final String? example;

  // ============================================================
  // From JSON
  // ============================================================

  factory PhoneRuleItemModel.fromJson(Map<String, dynamic> json) {
    return PhoneRuleItemModel(
      countryCode: json['country_code'] as String?,
      minLength: _parseInt(json['min_length']),
      maxLength: _parseInt(json['max_length']),
      example: json['example'] as String?,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      'min_length': minLength,
      'max_length': maxLength,
      'example': example,
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
