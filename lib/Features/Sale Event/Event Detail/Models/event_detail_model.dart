class EventDetailModel {
  const EventDetailModel({
    this.success = false,
    this.event,
    this.kycStatus,
    this.kycLocked = false,
  });

  final bool success;
  final EventDetailItemModel? event;
  final String? kycStatus;
  final bool kycLocked;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventDetailModel();
    }

    return EventDetailModel(
      success: _parseBool(json['success']),
      event: json['event'] is Map
          ? EventDetailItemModel.fromJson(
              Map<String, dynamic>.from(json['event'] as Map),
            )
          : null,
      kycStatus: json['kyc_status']?.toString(),
      kycLocked: _parseBool(json['kyc_locked']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'event': event?.toJson(),
      'kyc_status': kycStatus,
      'kyc_locked': kycLocked,
    };
  }

  // ============================================================
  // Helpers
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
}

// ═══════════════════════════════════════════════════════════════════════════
// Event Detail Item Model
// ═══════════════════════════════════════════════════════════════════════════

class EventDetailItemModel {
  const EventDetailItemModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.bannerUrl,
    this.bannerMobileUrl,
    this.startDate,
    this.endDate,
    this.minDiscountPercentage,
    this.status,
    this.myParticipation,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? bannerUrl;
  final String? bannerMobileUrl;
  final String? startDate;
  final String? endDate;
  final num? minDiscountPercentage;
  final String? status;

  /// Vendor's participation in this event.
  final EventParticipationModel? myParticipation;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventDetailItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventDetailItemModel();
    }

    return EventDetailItemModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      bannerUrl: json['banner_url']?.toString(),
      bannerMobileUrl: json['banner_mobile_url']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      minDiscountPercentage: _parseNum(json['min_discount_percentage']),
      status: json['status']?.toString(),

      myParticipation: json['my_participation'] is Map
          ? EventParticipationModel.fromJson(
              Map<String, dynamic>.from(json['my_participation'] as Map),
            )
          : null,
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
      'description': description,
      'banner_url': bannerUrl,
      'banner_mobile_url': bannerMobileUrl,
      'start_date': startDate,
      'end_date': endDate,
      'min_discount_percentage': minDiscountPercentage,
      'status': status,
      'my_participation': myParticipation?.toJson(),
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
}

// ═══════════════════════════════════════════════════════════════════════════
// Event Participation Model
// ═══════════════════════════════════════════════════════════════════════════

class EventParticipationModel {
  const EventParticipationModel({
    this.campaignId,
    this.status,
    this.requestedDiscountPercentage,
    this.discountPercentage,
    this.productIds = const [],
    this.products = const [],
  });

  final int? campaignId;
  final String? status;

  final num? requestedDiscountPercentage;
  final num? discountPercentage;

  final List<int> productIds;

  final List<EventParticipationProductModel> products;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventParticipationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventParticipationModel();
    }

    final rawProductIds = json['product_ids'];

    final List<int> parsedProductIds = [];

    if (rawProductIds is List) {
      for (final item in rawProductIds) {
        final id = _parseInt(item);

        if (id != null && id > 0) {
          parsedProductIds.add(id);
        }
      }
    }

    final rawProducts = json['products'];

    final List<EventParticipationProductModel> parsedProducts = [];

    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          parsedProducts.add(
            EventParticipationProductModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return EventParticipationModel(
      campaignId: _parseInt(json['campaign_id']),
      status: json['status']?.toString(),
      requestedDiscountPercentage: _parseNum(
        json['requested_discount_percentage'],
      ),
      discountPercentage: _parseNum(json['discount_percentage']),
      productIds: parsedProductIds,
      products: parsedProducts,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'campaign_id': campaignId,
      'status': status,
      'requested_discount_percentage': requestedDiscountPercentage,
      'discount_percentage': discountPercentage,
      'product_ids': productIds,
      'products': products.map((product) => product.toJson()).toList(),
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
}

// ═══════════════════════════════════════════════════════════════════════════
// Event Participation Product Model
// ═══════════════════════════════════════════════════════════════════════════

class EventParticipationProductModel {
  const EventParticipationProductModel({
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

  factory EventParticipationProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventParticipationProductModel();
    }

    return EventParticipationProductModel(
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
