class BusinessTypeModel {
  const BusinessTypeModel({
    required this.success,
    required this.businessTypes,
    required this.total,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool? success;
  final List<BusinessTypeItemModel> businessTypes;
  final int? total;

  // ============================================================
  // From JSON
  // ============================================================

  factory BusinessTypeModel.fromJson(Map<String, dynamic> json) {
    return BusinessTypeModel(
      success: json['success'] as bool?,
      businessTypes: _parseBusinessTypes(json['business_types']),
      total: _parseInt(json['total']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'business_types': businessTypes
          .map((businessType) => businessType.toJson())
          .toList(),
      'total': total,
    };
  }

  // ============================================================
  // Safe List Parsing
  // ============================================================

  static List<BusinessTypeItemModel> _parseBusinessTypes(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) =>
              BusinessTypeItemModel.fromJson(Map<String, dynamic>.from(item)),
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
// Business Type Item Model
// ============================================================

class BusinessTypeItemModel {
  const BusinessTypeItemModel({
    this.value,
    this.label,
    this.labelAr,
    this.description,
  });

  final String? value;
  final String? label;
  final String? labelAr;
  final String? description;

  // ============================================================
  // From JSON
  // ============================================================

  factory BusinessTypeItemModel.fromJson(Map<String, dynamic> json) {
    return BusinessTypeItemModel(
      value: json['value'] as String?,
      label: json['label'] as String?,
      labelAr: json['label_ar'] as String?,
      description: json['description'] as String?,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'label_ar': labelAr,
      'description': description,
    };
  }
}
