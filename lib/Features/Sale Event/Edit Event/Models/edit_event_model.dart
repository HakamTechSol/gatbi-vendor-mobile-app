class EditEventModel {
  const EditEventModel({
    this.success = false,
    this.message,
    this.campaignId,
    this.status,
    this.productIds = const [],
    this.products = const [],
    this.requestedDiscountPercentage,
  });

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;
  final String? message;
  final int? campaignId;
  final String? status;
  final List<int> productIds;
  final List<EditEventProductModel> products;
  final num? requestedDiscountPercentage;

  // ============================================================
  // From JSON
  // ============================================================

  factory EditEventModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EditEventModel();
    }

    return EditEventModel(
      success: _parseBool(json['success']),
      message: json['message']?.toString(),
      campaignId: _parseInt(json['campaign_id']),
      status: json['status']?.toString(),
      productIds: _parseIntList(json['product_ids']),
      products: _parseProducts(json['products']),
      requestedDiscountPercentage: _parseNum(
        json['requested_discount_percentage'],
      ),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'campaign_id': campaignId,
      'status': status,
      'product_ids': productIds,
      'products': products.map((e) => e.toJson()).toList(),
      'requested_discount_percentage': requestedDiscountPercentage,
    };
  }

  // ============================================================
  // Parse Bool
  // ============================================================

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

  // ============================================================
  // Parse Int
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

  // ============================================================
  // Parse Num
  // ============================================================

  static num? _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  // ============================================================
  // Parse Int List
  // ============================================================

  static List<int> _parseIntList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map(_parseInt)
        .whereType<int>()
        .toList();
  }

  // ============================================================
  // Parse Products
  // ============================================================

  static List<EditEventProductModel> _parseProducts(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => EditEventProductModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Edit Event Product Model
// ═══════════════════════════════════════════════════════════════════════════

class EditEventProductModel {
  const EditEventProductModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.hasVariants = false,
    this.price,
    this.priceMin,
    this.priceMax,
    this.dealPriceMin,
    this.dealPriceMax,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? slug;
  final String? image;
  final bool hasVariants;
  final num? price;
  final num? priceMin;
  final num? priceMax;
  final num? dealPriceMin;
  final num? dealPriceMax;

  // ============================================================
  // From JSON
  // ============================================================

  factory EditEventProductModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const EditEventProductModel();
    }

    return EditEventProductModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      image: json['image']?.toString(),
      hasVariants: _parseBool(json['has_variants']),
      price: _parseNum(json['price']),
      priceMin: _parseNum(json['price_min']),
      priceMax: _parseNum(json['price_max']),
      dealPriceMin: _parseNum(json['deal_price_min']),
      dealPriceMax: _parseNum(json['deal_price_max']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'has_variants': hasVariants,
      'price': price,
      'price_min': priceMin,
      'price_max': priceMax,
      'deal_price_min': dealPriceMin,
      'deal_price_max': dealPriceMax,
    };
  }

  // ============================================================
  // Helpers
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

  static num? _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
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