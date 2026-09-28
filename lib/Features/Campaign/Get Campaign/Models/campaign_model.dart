class CampaignModel {
  const CampaignModel({
    this.id,
    this.name,
    this.campaignType,
    this.status,
    this.statusLabel,
    this.discountPercentage,
    this.requestedDiscountPercentage,
    this.productIds,
    this.startDate,
    this.endDate,
    this.vendorNotes,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? campaignType;
  final String? status;
  final String? statusLabel;

  final double? discountPercentage;
  final double? requestedDiscountPercentage;

  final String? productIds;

  final String? startDate;
  final String? endDate;

  final String? vendorNotes;
  final String? adminNotes;

  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // Convenience Getter
  // ============================================================

  List<int> get productIdList {
    if (productIds == null || productIds!.trim().isEmpty) {
      return const [];
    }

    return productIds!
        .split(',')
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>()
        .toList();
  }

  // ============================================================
  // From JSON
  // ============================================================

  factory CampaignModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignModel();
    }

    return CampaignModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      campaignType: _parseString(json['campaign_type']),
      status: _parseString(json['status']),
      statusLabel: _parseString(json['status_label']),
      discountPercentage: _parseDouble(json['discount_percentage']),
      requestedDiscountPercentage: _parseDouble(
        json['requested_discount_percentage'],
      ),
      productIds: _parseString(json['product_ids']),
      startDate: _parseString(json['start_date']),
      endDate: _parseString(json['end_date']),
      vendorNotes: _parseString(json['vendor_notes']),
      adminNotes: _parseString(json['admin_notes']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'campaign_type': campaignType,
      'status': status,
      'status_label': statusLabel,
      'discount_percentage': discountPercentage,
      'requested_discount_percentage': requestedDiscountPercentage,
      'product_ids': productIds,
      'start_date': startDate,
      'end_date': endDate,
      'vendor_notes': vendorNotes,
      'admin_notes': adminNotes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

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

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
