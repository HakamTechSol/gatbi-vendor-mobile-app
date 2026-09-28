class CampaignDetailModel {
  const CampaignDetailModel({this.success = false, this.campaign});

  final bool success;
  final CampaignDetailData? campaign;

  factory CampaignDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignDetailModel();
    }

    return CampaignDetailModel(
      success: _parseBool(json['success']),
      campaign: json['campaign'] is Map
          ? CampaignDetailData.fromJson(
              Map<String, dynamic>.from(json['campaign'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'campaign': campaign?.toJson()};
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
}

// ============================================================
// Campaign Detail Data
// ============================================================

class CampaignDetailData {
  const CampaignDetailData({
    this.id,
    this.name,
    this.campaignType,
    this.status,
    this.statusLabel,
    this.discountPercentage,
    this.requestedDiscountPercentage,
    this.productUrls,
    this.productIds,
    this.products = const [],
    this.startDate,
    this.endDate,
    this.vendorNotes,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.activatedAt,
  });

  final int? id;

  final String? name;

  final String? campaignType;

  final String? status;

  final String? statusLabel;

  final double? discountPercentage;

  final double? requestedDiscountPercentage;

  final dynamic productUrls;

  final String? productIds;

  /// Actual campaign products returned by API.
  final List<CampaignDetailProductModel> products;

  final String? startDate;

  final String? endDate;

  final String? vendorNotes;

  final String? adminNotes;

  final String? createdAt;

  final String? updatedAt;

  final String? approvedAt;

  final String? activatedAt;

  factory CampaignDetailData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignDetailData();
    }

    return CampaignDetailData(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      campaignType: _parseString(json['campaign_type']),
      status: _parseString(json['status']),
      statusLabel: _parseString(json['status_label']),
      discountPercentage: _parseDouble(json['discount_percentage']),
      requestedDiscountPercentage: _parseDouble(
        json['requested_discount_percentage'],
      ),
      productUrls: json['product_urls'],
      productIds: _parseString(json['product_ids']),

      // --------------------------------------------------------
      // Products
      // --------------------------------------------------------
      products: _parseProductList(json['products']),

      startDate: _parseString(json['start_date']),
      endDate: _parseString(json['end_date']),
      vendorNotes: _parseString(json['vendor_notes']),
      adminNotes: _parseString(json['admin_notes']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      approvedAt: _parseString(json['approved_at']),
      activatedAt: _parseString(json['activated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'campaign_type': campaignType,
      'status': status,
      'status_label': statusLabel,
      'discount_percentage': discountPercentage,
      'requested_discount_percentage': requestedDiscountPercentage,
      'product_urls': productUrls,
      'product_ids': productIds,

      // --------------------------------------------------------
      // Products
      // --------------------------------------------------------
      'products': products.map((product) => product.toJson()).toList(),

      'start_date': startDate,
      'end_date': endDate,
      'vendor_notes': vendorNotes,
      'admin_notes': adminNotes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'approved_at': approvedAt,
      'activated_at': activatedAt,
    };
  }

  // ============================================================
  // Parsers
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

  static double? _parseDouble(dynamic value) {
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  static List<CampaignDetailProductModel> _parseProductList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => CampaignDetailProductModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}

// ============================================================
// Campaign Detail Product Model
// ============================================================

class CampaignDetailProductModel {
  const CampaignDetailProductModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.price,
    this.dealPrice,
  });

  final int? id;

  final String? name;

  final String? slug;

  final String? image;

  final double? price;

  final double? dealPrice;

  factory CampaignDetailProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignDetailProductModel();
    }

    return CampaignDetailProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      image: _parseString(json['image']),
      price: _parseDouble(json['price']),
      dealPrice: _parseDouble(json['deal_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'price': price,
      'deal_price': dealPrice,
    };
  }

  // ============================================================
  // Parsers
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

  static double? _parseDouble(dynamic value) {
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
